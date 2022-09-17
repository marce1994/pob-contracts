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
        // Deploy Escrow contract
        vm.startPrank(deployer);
        target = new PobEscrow(100);
        vm.deal(deployer, 0 ether);
        vm.stopPrank();

        // Set balances
        vm.deal(buyer, 100 ether);

        // Seller profile
        vm.startPrank(seller);
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

        // Buyer profile
        vm.startPrank(buyer);
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

    function testBuy() public {
        uint256 buyerStartBalance = buyer.balance;
        uint256 deployerStartBalance = deployer.balance;
        uint256 sellerStartBalance = seller.balance;
        uint256 commissionerStartBalance = commissioner.balance;

        vm.startPrank(seller);

        uint256 profileId = lensHub.tokenOfOwnerByIndex(seller, 0);
        console.log("profileId", profileId);

        DataTypes.PostData memory sellerPost = DataTypes.PostData(
            profileId,// uint256 profileId;
            "https://pastebin.com/raw/hBhU7Re0",// string contentURI;
            address(0x0BE6bD7092ee83D44a6eC1D949626FeE48caB30c),// address collectModule;
            toBytes(1),// bytes collectModuleInitData;
            address(0),// address referenceModule;
            bytes("")// bytes referenceModuleInitData;
        );

        uint256 pubId = lensHub.post(sellerPost);
        console.log(pubId);

        target.sell(profileId, pubId, 10 ether);
        
        vm.stopPrank();

        vm.startPrank(buyer);

        target.buy{value: 10 ether}(profileId, pubId, commissioner);
        target.confirmBuy(profileId, pubId);

        vm.stopPrank();

        // Asserts
        console.log(buyer.balance);
        assertEq(buyer.balance, buyerStartBalance - 10 ether);
        console.log(deployer.balance);
        assertEq(deployer.balance, deployerStartBalance + 0.05 ether);
        console.log(seller.balance);
        assertEq(seller.balance, sellerStartBalance + 9.9 ether);
        console.log(commissioner.balance);
        assertEq(commissioner.balance, commissionerStartBalance + 0.05 ether);
        
    }

    function testCancelBuy() public {
        uint256 buyerStartBalance = buyer.balance;
        uint256 deployerStartBalance = deployer.balance;
        uint256 sellerStartBalance = seller.balance;
        uint256 commissionerStartBalance = commissioner.balance;

        vm.startPrank(seller);

        uint256 profileId = lensHub.tokenOfOwnerByIndex(seller, 0);
        console.log("profileId", profileId);

        DataTypes.PostData memory sellerPost = DataTypes.PostData(
            profileId,// uint256 profileId;
            "https://pastebin.com/raw/hBhU7Re0",// string contentURI;
            address(0x0BE6bD7092ee83D44a6eC1D949626FeE48caB30c),// address collectModule;
            toBytes(1),// bytes collectModuleInitData;
            address(0),// address referenceModule;
            bytes("")// bytes referenceModuleInitData;
        );

        uint256 pubId = lensHub.post(sellerPost);
        
        console.log(pubId);

        target.sell(profileId, pubId, 10 ether);
        
        vm.stopPrank();

        vm.startPrank(buyer);
        
        target.buy{value: 10 ether}(profileId, pubId, commissioner);
        
        vm.stopPrank();

        vm.startPrank(seller);
        
        target.cancelBuy(profileId, pubId);
        
        vm.stopPrank();

        // Asserts
        console.log(buyer.balance);
        assertEq(buyer.balance, buyerStartBalance);
        console.log(deployer.balance);
        assertEq(deployer.balance, deployerStartBalance);
        console.log(seller.balance);
        assertEq(seller.balance, sellerStartBalance);
        console.log(commissioner.balance);
        assertEq(commissioner.balance, commissionerStartBalance);
    }

    function toBytes(uint256 x) public returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}
