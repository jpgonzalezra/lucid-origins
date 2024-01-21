CONTRACTS_DIR := packages/contracts
APP_DIR := apps/web
ABI_DIR := $(APP_DIR)/src/config/abis
CONTRACT_NAME := LucidOrigins
DEPLOY_SCRIPT_DIR := packages/contracts/broadcast/LucidOriginsDeploy.s.sol
JSON_FILE := $(CONTRACTS_DIR)/out/$(CONTRACT_NAME).sol/$(CONTRACT_NAME).json
ANVIL := 31337

all: build move_abi deploy_contract_anvil update_env

build:
	@echo "Compiling..."
	cd $(CONTRACTS_DIR) && forge build

move_abi:
	@echo "Moving abi to apps..."
	mkdir -p $(ABI_DIR)
	cat $(JSON_FILE) | python3 -c "import json,sys;obj=json.load(sys.stdin); print('export default', obj['abi'], 'as const');" > $(ABI_DIR)/$(CONTRACT_NAME).ts
	sed -i .bak 's/True/true/g' $(ABI_DIR)/$(CONTRACT_NAME).ts
	sed -i .bak 's/False/false/g' $(ABI_DIR)/$(CONTRACT_NAME).ts

deploy_contract_anvil:
	@echo "Deploying..."
	cd $(CONTRACTS_DIR) && forge script script/LucidOriginsDeploy.s.sol --broadcast --fork-url http://localhost:8545

update_env:
	@echo "Updation .env file with deployment info"
	$(eval CONTRACT_ADDRESS=$(shell grep -A 3 "lucidOrigins" $(DEPLOY_SCRIPT_DIR)/$(ANVIL)/run-latest.json | sed -n 's/.*"value": "\([^"]*\)".*/\1/p'))
	@echo $(CONTRACT_ADDRESS)
	if [ ! -f $(APP_DIR)/.env ]; then \
		touch $(APP_DIR)/.env; \
	fi
	if grep -q "VITE_LUCID_BLOB_ADDRESS" $(APP_DIR)/.env; then \
		sed -i '' 's/VITE_LUCID_BLOB_ADDRESS=.*/VITE_LUCID_BLOB_ADDRESS='"$(CONTRACT_ADDRESS)"'/' $(APP_DIR)/.env; \
	else \
		echo "VITE_LUCID_BLOB_ADDRESS=$(CONTRACT_ADDRESS)" >> $(APP_DIR)/.env; \
	fi


.PHONY: build move_abi deploy_contract_anvil update_env