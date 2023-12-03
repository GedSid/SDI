EXAMPLES := src/misc/crc18/tests \
            src/misc/scram/tests \
# EXAMPLES := src/misc/scram/tests \
#             src/misc/ln/tests \

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

#   374  rm -r venv/
# 375  python3 -m venv venv
# 376  venv/bin/python -m pip install -U pip
# 377  venv/bin/python -m pip install -e . --no-cache-dir
# 378  venv/bin/python -m pip install -r requirements.txt --no-cache-dir
# 379  . venv/bin/activate; sudo apt install -y ghdl
# 380  make
# 381  sudo apt autoremove
# 382  make
# 383  make SIM=ghdl clean