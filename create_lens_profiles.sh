# source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_1 -vvvv
# source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_2 -vvvv
# source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_3 -vvvv
source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --rpc-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_1 -vvvv
source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --rpc-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_2 -vvvv
source .env && forge script script/CreateLensProfile.s.sol:CreateLensProfileScript --rpc-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_3 -vvvv