// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/PobEscrow.sol";
import "lens/core/LensHub.sol";
import "lens/libraries/DataTypes.sol";
import "lens/mocks/MockProfileCreationProxy.sol";

// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --rpc-url $BOMBAI_RPC_URL --broadcast --verify --private-key $PRIVATE_KEY_DEPLOYER --etherscan-api-key $POLYGONSCAN_API_KEY -vvvv
// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_DEPLOYER -vvvv
// forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/MyContract.sol:MyContract
contract SimulateOperationScript is Script {
    PobEscrow escrow = PobEscrow(0x05402989C618759832c1D259eD07BFeCC8E6979c);
    LensHub lensHub = LensHub(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);
    MockProfileCreationProxy profileFactory = MockProfileCreationProxy(0x420f0257D43145bb002E69B14FF2Eb9630Fc4736);

    function setUp() public {

    }

    function run() public {
        
    }
}
