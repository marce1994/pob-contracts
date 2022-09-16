// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/PobEscrow.sol";
import "lens/core/LensHub.sol";
import "lens/libraries/DataTypes.sol";
import "lens/mocks/MockProfileCreationProxy.sol";

contract PobEscrowTest is Test {
    address deployer = makeAddr("deployer");
    address seller = makeAddr("seller");
    address buyer = makeAddr("buyer");

    PobEscrow target;
    LensHub lensHub = LensHub(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);
    MockProfileCreationProxy profileFactory = MockProfileCreationProxy(0x420f0257D43145bb002E69B14FF2Eb9630Fc4736);

    function setUp() public {
        vm.startPrank(deployer);
        target = new PobEscrow(1);
        vm.stopPrank();

        vm.startPrank(seller);
        // Seller profile
        DataTypes.CreateProfileData memory sellerProfileData = DataTypes.CreateProfileData(
            seller,
            "pobseller",
            "https://ipfs.io/ipfs/QmY9dUwYu67puaWBMxRKW98LPbXCznPwHUbhX5NeWnCJbX",
            address(0),
            bytes(""),
            "https://ipfs.io/ipfs/QmTFLSXdEQ6qsSzaXaCSNtiv6wA56qq87ytXJ182dXDQJS"
        );

        profileFactory.proxyCreateProfile(sellerProfileData);
        vm.stopPrank();

        vm.startPrank(buyer);
        // Buyer profile
        DataTypes.CreateProfileData memory buyerProfileData = DataTypes.CreateProfileData(
            buyer,
            "pobbuyer",
            "https://ipfs.io/ipfs/QmY9dUwYu67puaWBMxRKW98LPbXCznPwHUbhX5NeWnCJbX",
            address(0),
            bytes(""),
            "https://ipfs.io/ipfs/QmTFLSXdEQ6qsSzaXaCSNtiv6wA56qq87ytXJ182dXDQJS"
        );

        profileFactory.proxyCreateProfile(buyerProfileData);
        vm.stopPrank();
    }

    function testPublish() public {
        vm.startPrank(seller);

        uint256 profileId = lensHub.tokenOfOwnerByIndex(seller, 0);
        console.log("profileId", profileId);

        // DataTypes.ProfileStruct memory profile = lensHub.getProfile(profileId);
        // uint256 sellerProfileId 
        // bytes memory aux = 0x0000000000000000000000000000000000000000000000000000000000000001;
        console.log(string(toBytes(1)));
        DataTypes.PostData memory sellerPost = DataTypes.PostData(
            profileId,// uint256 profileId;
            "https://pastebin.com/raw/hBhU7Re0",// string contentURI;
            address(0x0BE6bD7092ee83D44a6eC1D949626FeE48caB30c),// address collectModule;
            toBytes(1),// bytes collectModuleInitData;
            address(0),// address referenceModule;
            bytes("")// bytes referenceModuleInitData;
        );

        lensHub.post(sellerPost);
        
        vm.stopPrank();
    }

    function toBytes(uint256 x) public returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}
