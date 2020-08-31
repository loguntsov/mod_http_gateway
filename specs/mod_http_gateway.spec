-xml(body,
    #elem{
        name = <<"http">>,
        xmlns = [<<"urn:xmpp:http_gateway">>],
        module = http_gateway_xmpp,
        result = {http_gateway_body, '$type', '$body'},
        attrs = [
            #attr{
                name = <<"type">>,
                required = true,
                enc = {enc_enum, []},
                dec = {dec_enum, [[json, text, binary]]},
		label = '$type'
            }
        ],
        cdata = #cdata{ label = '$body'}
    }
).

-xml(http_gateway_request,
    #elem{
        name = <<"query">>,
        xmlns = <<"urn:xmpp:http_gateway">>,
        module = http_gateway_xmpp,
        result = {http_gateway_request, '$url','$body'},
        attrs = [
            #attr{
                name = <<"url">>,
                label = '$url'
            }
        ],
        refs = [
            #ref{
                name = body,
                label = '$body'
            }]
    }
).

-xml(http_gateway_response,
    #elem{
        name = <<"response">>,
        xmlns = <<"urn:xmpp:http_gateway">>,
        module = http_gateway_xmpp,
        result = {http_gateway_response, '$status', '$body'},
        attrs = [
            #attr{
                name = <<"status">>,
                label = '$status'
            }
        ],
        refs = [
            #ref{
                name = body,
                label = '$body'
            }
        ]
    }
).

