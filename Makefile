APP=shootingserver

.PHONY: all compile deps clean distclean

all: deps compile eunit

DIALYZER_OPTS=-Werror_handling -Wrace_conditions -Wunmatched_returns

init:
	@./rebar get-deps compile

deps: update-deps get-deps

update-deps:
	@./rebar get-deps

compile:
	@./rebar compile skip_deps=true

get-deps:
	@./rebar get-deps

clean:
	@./rebar clean skip_deps=true

distclean: clean
	@./rebar clean
	@./rebar delete-deps

eunit:
	@./rebar eunit skip_deps=true

dialyze-init:
	dialyzer --build_plt --apps erts kernel stdlib mnesia crypto public_key snmp reltool
	dialyzer --add_to_plt --plt ~/.dialyzer_plt --output_plt $(APP).plt -c .
	dialyzer -c ebin -Wunmatched_returns -Werror_handling -Wrace_conditions -Wunderspecs

dialyze: compile
	dialyzer --check_plt --plt $(APP).plt -c .
	dialyzer -c ebin

create_app:
	@./rebar create-app appid=$(APP) skip_deps=true

