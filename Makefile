# EXAMPLES := src/sdi_tx/tests
EXAMPLES := src/crc18/tests \
            src/scram/tests \
			src/bit_rep/tests \
			# src/sdi_tx/tests \

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

