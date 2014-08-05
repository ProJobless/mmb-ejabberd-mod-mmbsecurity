-module(mod_mmbsecurity).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

-behavior(gen_mod).

-export([start/2, stop/1, on_filter_packet/1]).

start(_Host, _Opts) ->
%%     ?INFO_MSG("mod_sunshine starting", []),
	ejabberd_hooks:add(filter_packet, global, ?MODULE, on_filter_packet, 50),
    ok.

stop(_Host) ->
%%     ?INFO_MSG("mod_sunshine stopping", []),
	ejabberd_hooks:delete(filter_packet, global, ?MODULE, on_filter_packet, 50),
    ok.

%% ************************
%% ** FILTERING
%% ************************

%% ALLOW: cloud -> any
on_filter_packet({ #jid{user = <<"cloud">>, server = <<"mmbnetworks.com">>}, _, _ } = Input) -> Input;
%% ALLOW: any -> cloud
on_filter_packet({ _, #jid{user = <<"cloud">>, server = <<"mmbnetworks.com">>}, _ } = Input) -> Input;
%% DENY: any -> any  (messages)
on_filter_packet({From, _, #xmlel{name = <<"message">>, attrs = _, children = _}}) ->
	Message = <<"You are only allowed to send messages to <cloud@mmbnetworks.com> !">>,
	XmlBody = #xmlel{name = <<"message">>,
					attrs = [{<<"type">>, <<"normal">>}],
					children =
			    		[#xmlel{name = <<"body">>, attrs = [],
				    		children = [{xmlcdata, Message}]}
						]
				},
	ReplyFrom = #jid{user = <<"cloud">>, server = <<"mmbnetworks.com">>, resource = <<"Server">>},
	ejabberd_router:route(ReplyFrom, From, XmlBody),
	drop;
%% ALLOW: any -> any (other packets besides messages)
on_filter_packet(Packet) -> Packet.
