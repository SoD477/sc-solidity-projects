gen-input:
	forge script script/GenerateInput.s.sol:GenerateInput
make-merkle:
	forge script script/MakeMerkle.s.sol:MakeMerkle

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

deploy:
	forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop $(NETWORK_ARGS)

interact:
	forge script script/Interact.s.sol:ClaimAirdrop $(NETWORK_ARGS)