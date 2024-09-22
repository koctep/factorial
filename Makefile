PROJECT = factorial
PROJECT_DESCRIPTION = Calculate factorial
ERLANG_MK = erlang.mk

EUNIT_OPTS = verbose

NODE ?= node
IP ?= $(shell ip route get 8.8.8.8 | head -n1 | awk '{print $$7}')
NODENAME = $(NODE)@$(IP)

SHELL_OPTS = -setcookie changeme -config etc/$(PROJECT).config -name $(NODENAME)

ifeq ($(shell ls $(ERLANG_MK)),)
%:
	curl https://erlang.mk/erlang.mk -o $(ERLANG_MK) $(CURL_OPTS)
	$(MAKE) -f $(ERLANG_MK) erlang-mk
	$(MAKE) $@
else
include erlang.mk
endif

force:
