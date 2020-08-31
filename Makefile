all: compile

compile: lib xmpp_spec
	rebar3 compile
	cp mod_http_gateway.spec _build/default/lib/http_gateway/mod_http_gateway.spec

lib: lib/ejabberd

xmpp_spec: src/http_gateway_xmpp.erl

src/http_gateway_xmpp.erl: specs/mod_http_gateway.spec scripts/compile_xmpp_spec.sh
	./scripts/compile_xmpp_spec.sh

lib/ejabberd:
	mkdir -p lib && cd lib && \
	git clone https://github.com/processone/ejabberd.git && \
	cd ejabberd && \
	git checkout 20.07 && \
	./rebar get-deps compile

upload: compile
	rsync -rltxSRzv \
	    --exclude .git \
	    --exclude *.log* \
	    --exclude *.pid \
	    --exclude .idea \
	    --exclude .rebar \
	    --exclude *.beam \
	    --exclude _build \
	    --exclude lib \
		. loguntsov@boorchat.ru:~/ejabberd/mod_http_gateway

