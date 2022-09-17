// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/PobEscrow.sol";
import "lens/core/LensHub.sol";
import "lens/libraries/DataTypes.sol";
import "lens/mocks/MockProfileCreationProxy.sol";

// One line per each user (private key changes)

// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --rpc-url $BOMBAI_RPC_URL --broadcast --verify --private-key $PRIVATE_KEY_DEPLOYER --etherscan-api-key $POLYGONSCAN_API_KEY -vvvv
// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_DEPLOYER -vvvv

// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --rpc-url $BOMBAI_RPC_URL --broadcast --verify --private-key $PRIVATE_KEY_DEPLOYER --etherscan-api-key $POLYGONSCAN_API_KEY -vvvv
// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_DEPLOYER -vvvv

// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --rpc-url $BOMBAI_RPC_URL --broadcast --verify --private-key $PRIVATE_KEY_DEPLOYER --etherscan-api-key $POLYGONSCAN_API_KEY -vvvv
// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_DEPLOYER -vvvv
contract CreateLensProfileScript is Script {
    MockProfileCreationProxy profileFactory = MockProfileCreationProxy(0x420f0257D43145bb002E69B14FF2Eb9630Fc4736);
    mapping(address => string) _names;

    function setUp() public {
        _names[0xbea30bccA5961F3616E42De16C54e240778D193A] = "pablito";
        _names[0xbea6726E3c780134abA5476620AC70d3631Dc1E3] = "0x7i70";
        _names[0xbeaDd25A448f6245A1E121cdEBb62Fc7BEE0C6f4] = "luagiusto";
    }

    function run() public {
        vm.startBroadcast();
        DataTypes.CreateProfileData memory sellerProfileData = DataTypes.CreateProfileData(
            msg.sender,
            _names[msg.sender],
            "https://ipfs.io/ipfs/QmY9dUwYu67puaWBMxRKW98LPbXCznPwHUbhX5NeWnCJbX",
            address(0),
            bytes(""),
            "https://ipfs.io/ipfs/QmTFLSXdEQ6qsSzaXaCSNtiv6wA56qq87ytXJ182dXDQJS"
        );

        // console.log(sellerProfileData);

        profileFactory.proxyCreateProfile(sellerProfileData);
        vm.stopBroadcast();
    }
}
