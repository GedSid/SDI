EXAMPLES := libs/test \
            # simple_dff \
            # matrix_multiplier/tests \
            # mixed_language/tests \

# ifeq ($(TOPLEVEL_LANG),verilog)
# EXAMPLES += doc_examples/quickstart
# endif

.PHONY: $(EXAMPLES)

.PHONY: all
all: $(EXAMPLES)

$(EXAMPLES):
	@cd $@ && $(MAKE)

.PHONY: clean
clean:
	$(foreach TEST, $(EXAMPLES), $(MAKE) -C $(TEST) clean;)

regression:
	$(foreach TEST, $(EXAMPLES), $(MAKE) -C $(TEST) regression;)