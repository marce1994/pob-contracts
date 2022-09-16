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
    address commissioner = makeAddr("commissioner");

    PobEscrow target;
    LensHub lensHub = LensHub(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);
    MockProfileCreationProxy profileFactory = MockProfileCreationProxy(0x420f0257D43145bb002E69B14FF2Eb9630Fc4736);

    function setUp() public {
        vm.startPrank(deployer);
        target = new PobEscrow(100);
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
        // console.log(string(toBytes(1)));
        DataTypes.PostData memory sellerPost = DataTypes.PostData(
            profileId,// uint256 profileId;
            "https://pastebin.com/raw/hBhU7Re0",// string contentURI;
            address(0x0BE6bD7092ee83D44a6eC1D949626FeE48caB30c),// address collectModule;
            toBytes(1),// bytes collectModuleInitData;
            address(0),// address referenceModule;
            bytes("")// bytes referenceModuleInitData;
        );

        uint256 pubId = lensHub.post(sellerPost);
        // uint256 pubId1 = lensHub.post(sellerPost);
        
        console.log(pubId);

// struct PublicationStruct {
//         uint256 profileIdPointed;
//         uint256 pubIdPointed;
//         string contentURI;
//         address referenceModule;
//         address collectModule;
//         address collectNFT;
//     }
        DataTypes.PublicationStruct memory publication = lensHub.getPub(profileId, pubId);
        // DataTypes.PublicationStruct memory publication1 = lensHub.getPub(profileId, pubId1);

        console.log(publication.profileIdPointed, profileId);
        console.log(publication.pubIdPointed, profileId);
        console.log(publication.contentURI, profileId);

        // console.log(publication1.profileIdPointed, profileId);
        // console.log(publication1.pubIdPointed, profileId);
        // console.log(publication1.contentURI, profileId);

        target.sell(profileId, pubId, 10 ether);
        // target.sell(profileId, pubId1, 10 ether);
        
        vm.stopPrank();

        vm.startPrank(buyer);
        vm.deal(buyer, 100 ether);
        // profileId = lensHub.tokenOfOwnerByIndex(buyer, 0);
        target.buy{value: 10 ether}(profileId, pubId, commissioner);
        target.confirmBuy(profileId, pubId);

        console.log(buyer.balance);
        console.log(deployer.balance);
        console.log(seller.balance);
        console.log(commissioner.balance);

        vm.stopPrank();
    }

    function toBytes(uint256 x) public returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}
