# EXAMPLES := src/misc/sdi_tx/tests
EXAMPLES := src/misc/crc18/tests \
            src/misc/scram/tests \
			src/misc/sdi_tx/tests \



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
