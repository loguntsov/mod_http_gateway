# Ejabberd's simple http gateway for fixed URN

This modules allows xmpp users to make http requests to predefined URL 

## XMPP Protocol

Domain what processes requests should be define in config. The example of config for module:
```
  mod_http_gateway:
    domains:
      test:
        domain: "https://ya.ru"

```

This config means:
1. We are using subdomain for each host named as test. So if you have boorchat.ru host, then client should send requests to 'test.boorchat.ru'.
2. This 'test.boorchat.ru' domain linked with http-domain (URL): 'https://ya.ru'

Client must send request like this:

```
<iq to="test.boorchat.ru" type="set" id="id"><query xmlns="urn:xmpp:http_gateway" url="/"><http type="json">hello</http></query></iq>
```

Types of IQ:
    * set - will generate post request
    * get - will generate get request. http tag will be ignored.
    
Url in query tag is continuous of URL. The full URL will be buit from start part from config and sent part from query.

Http tag contains all information related of content of request. Usually it should be json string (type="json").

Supported types:

* json (mime type: application/json)
* text (mime type: application/text)
* binary (mime type: application/binary)
    
Response of service:

```
<iq type="result" to="test1@boorchat.ru/Psi+" xml:lang="ru" from="test.boorchat.ru" id="id">
<response xmlns="urn:xmpp:http_gateway" status="403">
<http type="json">

... RESPONSE FROM HTTP SERVICE ...

</http>
</response>
</iq>

```

All requests could be processed in asyncronous mode.

## Requirements

* installed ejabbberd

Tested with Ejabberd 20.07

* make 

    ```sudo apt-get install make```
* rebar3 

```
    wget https://rebar3.s3.amazonaws.com/rebar3
    ./rebar3 local install
    export PATH=/home/loguntsov/.cache/rebar3/bin:$PATH    
```
* git
    
    ```sudo apt-get install git```
    
   
## Compilation

Just use make command to build everything.    

## Installation

Put folder with compiled beam files from (_build/default/lib/http_gateway) to folder with all ejabberd's dependencies.

### Ejabberd 20

# Installation Ejabberd from sources

## Installation dependencies

```
apt install gcc libssl-dev libexpat1-dev libyaml-dev g++ zlib1g-dev
```


