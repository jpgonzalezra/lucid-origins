-include .env

.PHONY: all test clean

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install --no-commit rari-capital/solmate && forge install --no-commit chiru-labs/ERC721A && forge install --no-commit foundry-rs/forge-std && forge install --no-commit PaulRBerg/prb-test && forge install --no-commit mds1/solidity-trigonometry

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; prettier --write src/**/*.sol && prettier --write src/*.sol

# solhint should be installed globally
lint :; solhint src/**/*.sol && solhint src/*.sol

anvil :; anvil -m 'test test test test test test test test test test test junk'

-include ${FCT_PLUGIN_PATH}/makefile-external
