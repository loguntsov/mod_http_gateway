#!/bin/bash

rm -rf tmp
mkdir tmp
cd tmp
# cp -r ../lib/ejabberd/deps/xmpp ./xmpp
git clone https://github.com/processone/xmpp.git
cd xmpp &&
git checkout 1.4.9 &&
cat ../../specs/mod_http_gateway.spec >> specs/xmpp_codec.spec &&
cp include/xmpp_codec.hrl include/xmpp_code_old.hrl &&
make all &&
make spec &&
cp src/http_gateway_xmpp.erl ../../src/http_gateway_xmpp.erl &&
echo -e "%% This file was generated automatically by compile_xmpp_spec.sh script\n\n" > ../../include/http_gateway_xmpp.hrl &&
diff -n include/xmpp_code_old.hrl include/xmpp_codec.hrl |  grep -A1 '-' | grep -A1 http_gateway >> ../../include/http_gateway_xmpp.hrl &&
cd ../..
rm -rf tmp
