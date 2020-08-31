-module(mod_http_gateway).


-behavior(gen_mod).
-export([
  start/2, stop/1,
  mod_opt_type/1, depends/2,
  mod_options/1
]).

%% -behavior(ejabberd_router).
-export([
  route/1
]).

%% Hooks

-export([
  process_iq/1
]).

-define(LAGER, true).
-include("logger.hrl").

-include("xmpp.hrl").
-include("http_gateway_xmpp.hrl").

-define(NS_HTTP_GATEWAY, <<"urn:xmpp:http_gateway">>).
-define(XMPP_CODEC,http_gateway_xmpp).
-define(APP, http_gateway).

%% gen_mod callbacks

start(Host, Opts) ->
  ok = xmpp:register_codec(?XMPP_CODEC),
  ok = application:load(?APP),
  Domains = lists:map(fun({DomainAtom, Opt}) ->
    Domain = atom_to_binary(DomainAtom, utf8),
    DomainHost = iolist_to_binary([Domain, <<".">>, Host]),
    http_gateway_app:set_env({domain, DomainHost}, Opt),
    { DomainHost, Domain, Opt}
  end, maps:get(domains, Opts)),
  http_gateway_app:set_env(domains, Domains),
  { ok, _ } = application:ensure_all_started(?APP),
  lists:foreach(fun({DomainHost, _Domain, Opt}) ->
    http_gateway_app:set_env({domain, DomainHost}, maps:from_list(Opt)),
    gen_iq_handler:add_iq_handler(ejabberd_local, DomainHost, ?NS_HTTP_GATEWAY,
      ?MODULE, process_iq)
  end, Domains),
  register_routes(Host, [element(1, X) || X<- Domains]),
  ok.

stop(Host) ->
  Domains = http_gateway_app:get_env(domains),
  lists:foreach(fun({Domain, _DomainOpt}) ->
    gen_iq_handler:remove_iq_handler(ejabberd_local, iolist_to_binary([Domain, <<".">>, Host]), ?NS_HTTP_GATEWAY)
  end, maps:to_list(Domains)),
  xmpp:unregister_codec(?XMPP_CODEC),
  proc_lib:spawn(fun() ->
    ok = application:stop(?APP)
  end),
  ok.

depends(_Host, _Opts) ->
  [].

mod_opt_type(domains) ->
  fun(Domains) -> Domains end;

mod_opt_type(_) ->
  [domains].

mod_options(_Host) -> [
  {domains, #{}}
].

-spec register_routes(binary(), [binary()]) -> ok.
register_routes(ServerHost, Hosts) ->
  %% Only register routes on first worker
  lists:foreach(
    fun(Host) ->
      ok = ejabberd_router:register_route(
        Host, ServerHost, {apply, ?MODULE, route})
    end, Hosts).

-spec route(stanza()) -> ok.
route(Pkt = #iq{}) ->
  ejabberd_router:process_iq(Pkt);
route(_Packet) -> ok.


process_iq(IQ = #iq{ sub_els = [#http_gateway_request{ url = Url, body = [#http_gateway_body{} = Body]}]}) ->
  ?INFO_MSG("IQ ~p", [ IQ ]),
  To = xmpp:get_to(IQ),
  From = binary_to_list(jid:to_string(xmpp:get_from(IQ))),
  case get_domain(To#jid.lserver) of
    undefined -> xmpp:make_error(IQ, xmpp:err_item_not_found());
    { ok, Opts} ->
      Address = binary_to_list(iolist_to_binary([ maps:get(domain, Opts), Url ])),
      Mime = case Body#http_gateway_body.type of
        json -> "application/json";
        text -> "text/plain";
        binary -> "application/binary"
      end,
      Result = case IQ#iq.type of
        set ->
          httpc:request(post, {Address, [{"from_jid", From}], Mime, Body#http_gateway_body.body
          }, [],[{ body_format, binary }]);
        get ->
          httpc:request(get, {Address, [{"from_jid", From}]}, [],[{ body_format, binary }])
      end,
      case Result of
        {ok, {{_,Status, _}, _Headers, ResponseBody}} ->
          Type = json,
          Response = #http_gateway_response{
            status = integer_to_binary(Status),
            body = [#http_gateway_body{
              type = Type,
              body = ResponseBody
            }]
          },
          xmpp:make_iq_result(IQ, Response)
      end
  end;

process_iq(IQ) ->
  ?INFO_MSG("IQ ~p", [ IQ ]),
  xmpp:make_error(IQ, xmpp:err_bad_request()).

%% INTERNAL

get_domain(Host) ->
  application:get_env(?APP, {domain, Host}).
