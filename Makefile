APP=shootingserver

.PHONY: all compile deps clean distclean

all: compile xref eunit

DIALYZER_OPTS=-Werror_handling -Wrace_conditions -Wunmatched_returns

init:
	@./rebar3 compile

compile:
	@./rebar3 as dev compile

xref:
	@./rebar3 xref

clean:
	@./rebar3 clean

eunit:
	@./rebar3 eunit

dialyze:
	@./rebar3 dialyzer

create_app:
	@./rebar3 new app $(APP)

