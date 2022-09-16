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
        target = new PobEscrow();
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

        // DataTypes.PostData = DataTypes.PostData(
        //     uint256 profileId;
        //     string contentURI;
        //     address collectModule;
        //     bytes collectModuleInitData;
        //     address referenceModule;
        //     bytes referenceModuleInitData;
        // ); 

        lensHub.post(vars);
        vm.stopPrank();
    }
}
