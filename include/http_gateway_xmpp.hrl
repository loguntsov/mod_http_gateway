%% This file was generated automatically by compile_xmpp_spec.sh script


-record(http_gateway_body, {type :: 'binary' | 'json' | 'text',
                            body = <<>> :: binary()}).
-type http_gateway_body() :: #http_gateway_body{}.

-record(http_gateway_response, {status = <<>> :: binary(),
                                body = [] :: [#http_gateway_body{}]}).
-type http_gateway_response() :: #http_gateway_response{}.

-record(http_gateway_request, {url = <<>> :: binary(),
                               body = [] :: [#http_gateway_body{}]}).
-type http_gateway_request() :: #http_gateway_request{}.

