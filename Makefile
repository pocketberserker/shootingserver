.PHONY: all compile deps clean distclean

all: deps compile test

REBAR_CONFIG = ./rebar.config

deps: get-deps update-deps
	@./rebar -C $(REBAR_CONFIG) compile

update-deps:
	@./rebar -C $(REBAR_CONFIG) get-deps

compile:
	@./rebar -C $(REBAR_CONFIG) compile skip_deps=true

get-deps:
	@./rebar -C $(REBAR_CONFIG) get-deps

clean:
	@./rebar -C $(REBAR_CONFIG) clean skip_deps=true

distclean: clean
	@./rebar -C $(REBAR_CONFIG) clean
	@./rebar -C $(REBAR_CONFIG) delete-deps

test:
	rm -rf .eunit
	@./rebar -C $(REBAR_CONFIG) eunit skip_deps=true
