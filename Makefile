CONTRACTS_DIR := packages/contracts
APP_DIR := packages/app
ABI_DIR := $(APP_DIR)/abis
CONTRACT_NAME := LucidBlob
DEPLOY_SCRIPT_DIR := packages/contracts/broadcast/LucidBlobDeploy.s.sol
ANVIL := 31337

all: build move_abi deploy_contract_anvil update_env

build:
	@echo "Compiling..."
	cd $(CONTRACTS_DIR) && forge build

move_abi:
	@echo "Moving abi to apps..."
	mkdir -p $(ABI_DIR)
	cp $(CONTRACTS_DIR)/out/$(CONTRACT_NAME).sol/$(CONTRACT_NAME).json $(ABI_DIR)/

deploy_contract_anvil:
	@echo "Deploying..."
	cd $(CONTRACTS_DIR) && forge script script/LucidBlobDeploy.s.sol --broadcast --fork-url http://localhost:8545

update_env:
	@echo "Updation .env file with deployment info"
	$(eval CONTRACT_ADDRESS=$(shell grep -A 3 "lucidBlob" $(DEPLOY_SCRIPT_DIR)/$(ANVIL)/run-latest.json | sed -n 's/.*"value": "\([^"]*\)".*/\1/p'))
	@echo $(CONTRACT_ADDRESS)
	if [ ! -f $(APP_DIR)/.env ]; then \
		touch $(APP_DIR)/.env; \
	fi
	if grep -q "LUCID_BLOB_ADDRESS" $(APP_DIR)/.env; then \
		sed -i '' 's/LUCID_BLOB_ADDRESS=.*/LUCID_BLOB_ADDRESS='"$(CONTRACT_ADDRESS)"'/' $(APP_DIR)/.env; \
	else \
		echo "LUCID_BLOB_ADDRESS=$(CONTRACT_ADDRESS)" >> $(APP_DIR)/.env; \
	fi


.PHONY: build move_abi deploy_contract_anvil update_env