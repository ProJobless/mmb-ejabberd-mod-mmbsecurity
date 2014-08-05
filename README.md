##################
## SECURITY
##################

TODO


Compiling ejabberd
===========================

- download ejabberd source package
- install erlanc
	sudo apt-get install \
		erlang-base \
		erlang-crypto \
		libyaml-dev \
		libexpat-dev

- compile 
   erlc -I include/ -I deps/ -pz src  src/mod_sunshine.erl

Useful Links
===========================

http://www.ejabberd.im/node/4823
http://sysmagazine.com/posts/130396/
http://www.ejabberd.im/Events+and+hooks
https://github.com/knobo/mod_filter  http://www.ejabberd.im/mod_filter
http://stackoverflow.com/questions/1939879/how-to-filter-messages-in-ejabberd


Possible Communication
===========================

- Gateway1 -> Cloud:  commissioning, update model
- Cloud -> Client1: update_model, response
- Gateway1 -> GatewayX : DENY
- Client1 -> ClientX : DENY
- Client1 -> Gateway1 : DENY (should pass through the cloud)



