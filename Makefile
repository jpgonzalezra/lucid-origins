CONTRACTS_DIR := packages/contracts
APP_DIR := packages/app
ABI_DIR := $(APP_DIR)/abis
CONTRACT_NAME := LucidBlob

all: build move_abi

build:
	@echo "Compiling..."
	cd $(CONTRACTS_DIR) && forge build

move_abi:
	@echo "Moving abi to apps..."
	mkdir -p $(ABI_DIR)
	cp $(CONTRACTS_DIR)/out/$(CONTRACT_NAME).sol/$(CONTRACT_NAME).json $(ABI_DIR)/

.PHONY: build move_abi