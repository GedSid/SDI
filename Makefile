EXAMPLES := libs/test \
            src/misc/scram/tests \

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