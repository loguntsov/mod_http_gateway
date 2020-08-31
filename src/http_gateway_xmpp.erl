%% Created automatically by XML generator (fxml_gen.erl)
%% Source: xmpp_codec.spec

-module(http_gateway_xmpp).

-compile(export_all).

do_decode(<<"response">>, <<"urn:xmpp:http_gateway">>,
          El, Opts) ->
    decode_http_gateway_response(<<"urn:xmpp:http_gateway">>,
                                 Opts,
                                 El);
do_decode(<<"query">>, <<"urn:xmpp:http_gateway">>, El,
          Opts) ->
    decode_http_gateway_request(<<"urn:xmpp:http_gateway">>,
                                Opts,
                                El);
do_decode(<<"http">>, <<"urn:xmpp:http_gateway">>, El,
          Opts) ->
    decode_body(<<"urn:xmpp:http_gateway">>, Opts, El);
do_decode(Name, <<>>, _, _) ->
    erlang:error({xmpp_codec, {missing_tag_xmlns, Name}});
do_decode(Name, XMLNS, _, _) ->
    erlang:error({xmpp_codec, {unknown_tag, Name, XMLNS}}).

tags() ->
    [{<<"response">>, <<"urn:xmpp:http_gateway">>},
     {<<"query">>, <<"urn:xmpp:http_gateway">>},
     {<<"http">>, <<"urn:xmpp:http_gateway">>}].

do_encode({http_gateway_body, _, _} = Http, TopXMLNS) ->
    encode_body(Http, TopXMLNS);
do_encode({http_gateway_request, _, _} = Query,
          TopXMLNS) ->
    encode_http_gateway_request(Query, TopXMLNS);
do_encode({http_gateway_response, _, _} = Response,
          TopXMLNS) ->
    encode_http_gateway_response(Response, TopXMLNS).

do_get_name({http_gateway_body, _, _}) -> <<"http">>;
do_get_name({http_gateway_request, _, _}) ->
    <<"query">>;
do_get_name({http_gateway_response, _, _}) ->
    <<"response">>.

do_get_ns({http_gateway_body, _, _}) ->
    <<"urn:xmpp:http_gateway">>;
do_get_ns({http_gateway_request, _, _}) ->
    <<"urn:xmpp:http_gateway">>;
do_get_ns({http_gateway_response, _, _}) ->
    <<"urn:xmpp:http_gateway">>.

pp(http_gateway_body, 2) -> [type, body];
pp(http_gateway_request, 2) -> [url, body];
pp(http_gateway_response, 2) -> [status, body];
pp(_, _) -> no.

records() ->
    [{http_gateway_body, 2},
     {http_gateway_request, 2},
     {http_gateway_response, 2}].

dec_enum(Val, Enums) ->
    AtomVal = erlang:binary_to_existing_atom(Val, utf8),
    case lists:member(AtomVal, Enums) of
        true -> AtomVal
    end.

enc_enum(Atom) -> erlang:atom_to_binary(Atom, utf8).

decode_http_gateway_response(__TopXMLNS, __Opts,
                             {xmlel, <<"response">>, _attrs, _els}) ->
    Body = decode_http_gateway_response_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            []),
    Status = decode_http_gateway_response_attrs(__TopXMLNS,
                                                _attrs,
                                                undefined),
    {http_gateway_response, Status, Body}.

decode_http_gateway_response_els(__TopXMLNS, __Opts, [],
                                 Body) ->
    lists:reverse(Body);
decode_http_gateway_response_els(__TopXMLNS, __Opts,
                                 [{xmlel, <<"http">>, _attrs, _} = _el | _els],
                                 Body) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:http_gateway">> ->
            decode_http_gateway_response_els(__TopXMLNS,
                                             __Opts,
                                             _els,
                                             [decode_body(<<"urn:xmpp:http_gateway">>,
                                                          __Opts,
                                                          _el)
                                              | Body]);
        _ ->
            decode_http_gateway_response_els(__TopXMLNS,
                                             __Opts,
                                             _els,
                                             Body)
    end;
decode_http_gateway_response_els(__TopXMLNS, __Opts,
                                 [_ | _els], Body) ->
    decode_http_gateway_response_els(__TopXMLNS,
                                     __Opts,
                                     _els,
                                     Body).

decode_http_gateway_response_attrs(__TopXMLNS,
                                   [{<<"status">>, _val} | _attrs], _Status) ->
    decode_http_gateway_response_attrs(__TopXMLNS,
                                       _attrs,
                                       _val);
decode_http_gateway_response_attrs(__TopXMLNS,
                                   [_ | _attrs], Status) ->
    decode_http_gateway_response_attrs(__TopXMLNS,
                                       _attrs,
                                       Status);
decode_http_gateway_response_attrs(__TopXMLNS, [],
                                   Status) ->
    decode_http_gateway_response_attr_status(__TopXMLNS,
                                             Status).

encode_http_gateway_response({http_gateway_response,
                              Status,
                              Body},
                             __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:http_gateway">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_http_gateway_response_$body'(Body,
                                                           __NewTopXMLNS,
                                                           [])),
    _attrs =
        encode_http_gateway_response_attr_status(Status,
                                                 xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                            __TopXMLNS)),
    {xmlel, <<"response">>, _attrs, _els}.

'encode_http_gateway_response_$body'([], __TopXMLNS,
                                     _acc) ->
    _acc;
'encode_http_gateway_response_$body'([Body | _els],
                                     __TopXMLNS, _acc) ->
    'encode_http_gateway_response_$body'(_els,
                                         __TopXMLNS,
                                         [encode_body(Body, __TopXMLNS)
                                          | _acc]).

decode_http_gateway_response_attr_status(__TopXMLNS,
                                         undefined) ->
    <<>>;
decode_http_gateway_response_attr_status(__TopXMLNS,
                                         _val) ->
    _val.

encode_http_gateway_response_attr_status(<<>>, _acc) ->
    _acc;
encode_http_gateway_response_attr_status(_val, _acc) ->
    [{<<"status">>, _val} | _acc].

decode_http_gateway_request(__TopXMLNS, __Opts,
                            {xmlel, <<"query">>, _attrs, _els}) ->
    Body = decode_http_gateway_request_els(__TopXMLNS,
                                           __Opts,
                                           _els,
                                           []),
    Url = decode_http_gateway_request_attrs(__TopXMLNS,
                                            _attrs,
                                            undefined),
    {http_gateway_request, Url, Body}.

decode_http_gateway_request_els(__TopXMLNS, __Opts, [],
                                Body) ->
    lists:reverse(Body);
decode_http_gateway_request_els(__TopXMLNS, __Opts,
                                [{xmlel, <<"http">>, _attrs, _} = _el | _els],
                                Body) ->
    case xmpp_codec:get_attr(<<"xmlns">>,
                             _attrs,
                             __TopXMLNS)
        of
        <<"urn:xmpp:http_gateway">> ->
            decode_http_gateway_request_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            [decode_body(<<"urn:xmpp:http_gateway">>,
                                                         __Opts,
                                                         _el)
                                             | Body]);
        _ ->
            decode_http_gateway_request_els(__TopXMLNS,
                                            __Opts,
                                            _els,
                                            Body)
    end;
decode_http_gateway_request_els(__TopXMLNS, __Opts,
                                [_ | _els], Body) ->
    decode_http_gateway_request_els(__TopXMLNS,
                                    __Opts,
                                    _els,
                                    Body).

decode_http_gateway_request_attrs(__TopXMLNS,
                                  [{<<"url">>, _val} | _attrs], _Url) ->
    decode_http_gateway_request_attrs(__TopXMLNS,
                                      _attrs,
                                      _val);
decode_http_gateway_request_attrs(__TopXMLNS,
                                  [_ | _attrs], Url) ->
    decode_http_gateway_request_attrs(__TopXMLNS,
                                      _attrs,
                                      Url);
decode_http_gateway_request_attrs(__TopXMLNS, [],
                                  Url) ->
    decode_http_gateway_request_attr_url(__TopXMLNS, Url).

encode_http_gateway_request({http_gateway_request,
                             Url,
                             Body},
                            __TopXMLNS) ->
    __NewTopXMLNS =
        xmpp_codec:choose_top_xmlns(<<"urn:xmpp:http_gateway">>,
                                    [],
                                    __TopXMLNS),
    _els =
        lists:reverse('encode_http_gateway_request_$body'(Body,
                                                          __NewTopXMLNS,
                                                          [])),
    _attrs = encode_http_gateway_request_attr_url(Url,
                                                  xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                                             __TopXMLNS)),
    {xmlel, <<"query">>, _attrs, _els}.

'encode_http_gateway_request_$body'([], __TopXMLNS,
                                    _acc) ->
    _acc;
'encode_http_gateway_request_$body'([Body | _els],
                                    __TopXMLNS, _acc) ->
    'encode_http_gateway_request_$body'(_els,
                                        __TopXMLNS,
                                        [encode_body(Body, __TopXMLNS) | _acc]).

decode_http_gateway_request_attr_url(__TopXMLNS,
                                     undefined) ->
    <<>>;
decode_http_gateway_request_attr_url(__TopXMLNS,
                                     _val) ->
    _val.

encode_http_gateway_request_attr_url(<<>>, _acc) ->
    _acc;
encode_http_gateway_request_attr_url(_val, _acc) ->
    [{<<"url">>, _val} | _acc].

decode_body(__TopXMLNS, __Opts,
            {xmlel, <<"http">>, _attrs, _els}) ->
    Body = decode_body_els(__TopXMLNS, __Opts, _els, <<>>),
    Type = decode_body_attrs(__TopXMLNS, _attrs, undefined),
    {http_gateway_body, Type, Body}.

decode_body_els(__TopXMLNS, __Opts, [], Body) ->
    decode_body_cdata(__TopXMLNS, Body);
decode_body_els(__TopXMLNS, __Opts,
                [{xmlcdata, _data} | _els], Body) ->
    decode_body_els(__TopXMLNS,
                    __Opts,
                    _els,
                    <<Body/binary, _data/binary>>);
decode_body_els(__TopXMLNS, __Opts, [_ | _els], Body) ->
    decode_body_els(__TopXMLNS, __Opts, _els, Body).

decode_body_attrs(__TopXMLNS,
                  [{<<"type">>, _val} | _attrs], _Type) ->
    decode_body_attrs(__TopXMLNS, _attrs, _val);
decode_body_attrs(__TopXMLNS, [_ | _attrs], Type) ->
    decode_body_attrs(__TopXMLNS, _attrs, Type);
decode_body_attrs(__TopXMLNS, [], Type) ->
    decode_body_attr_type(__TopXMLNS, Type).

encode_body({http_gateway_body, Type, Body},
            __TopXMLNS) ->
    __NewTopXMLNS = xmpp_codec:choose_top_xmlns(<<>>,
                                                [<<"urn:xmpp:http_gateway">>],
                                                __TopXMLNS),
    _els = encode_body_cdata(Body, []),
    _attrs = encode_body_attr_type(Type,
                                   xmpp_codec:enc_xmlns_attrs(__NewTopXMLNS,
                                                              __TopXMLNS)),
    {xmlel, <<"http">>, _attrs, _els}.

decode_body_attr_type(__TopXMLNS, undefined) ->
    erlang:error({xmpp_codec,
                  {missing_attr, <<"type">>, <<"http">>, __TopXMLNS}});
decode_body_attr_type(__TopXMLNS, _val) ->
    case catch dec_enum(_val, [json, text, binary]) of
        {'EXIT', _} ->
            erlang:error({xmpp_codec,
                          {bad_attr_value,
                           <<"type">>,
                           <<"http">>,
                           __TopXMLNS}});
        _res -> _res
    end.

encode_body_attr_type(_val, _acc) ->
    [{<<"type">>, enc_enum(_val)} | _acc].

decode_body_cdata(__TopXMLNS, <<>>) -> <<>>;
decode_body_cdata(__TopXMLNS, _val) -> _val.

encode_body_cdata(<<>>, _acc) -> _acc;
encode_body_cdata(_val, _acc) ->
    [{xmlcdata, _val} | _acc].
