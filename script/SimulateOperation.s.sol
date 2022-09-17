// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/PobEscrow.sol";
import "lens/core/LensHub.sol";
import "lens/libraries/DataTypes.sol";
import "lens/mocks/MockProfileCreationProxy.sol";

// source .env && forge script script/PobEscrow.s.sol:PobEscrowScript --rpc-url $BOMBAI_RPC_URL --broadcast --verify --private-key $PRIVATE_KEY_DEPLOYER --etherscan-api-key $POLYGONSCAN_API_KEY -vvvv
// source .env && forge script script/SimulateOperation.s.sol:SimulateOperationScript --fork-url $BOMBAI_RPC_URL --private-key $PRIVATE_KEY_USER_1 -vvvv
contract SimulateOperationScript is Script {
    PobEscrow escrow = PobEscrow(0x05402989C618759832c1D259eD07BFeCC8E6979c);
    LensHub lensHub = LensHub(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);
    MockProfileCreationProxy profileFactory = MockProfileCreationProxy(0x420f0257D43145bb002E69B14FF2Eb9630Fc4736);

    function setUp() public {

    }

    function run() public {
        console.log(address(0xbea30bccA5961F3616E42De16C54e240778D193A).balance);
        console.log(address(0xbea6726E3c780134abA5476620AC70d3631Dc1E3).balance);
        console.log(address(0xbeaDd25A448f6245A1E121cdEBb62Fc7BEE0C6f4).balance);

        uint256 profileId = lensHub.tokenOfOwnerByIndex(msg.sender, 0);
        uint256 pubCount = lensHub.getProfile(profileId).pubCount;
        console.log("profileId", profileId);
        console.log("PubCOunt", pubCount);

        // NO FUNCA :(
        // DataTypes.PostData memory sellerPost = DataTypes.PostData(
        //     profileId,// uint256 profileId;
        //     "https://bearbuilders.sfo3.digitaloceanspaces.com/b90f447c",// string contentURI;
        //     address(0x0BE6bD7092ee83D44a6eC1D949626FeE48caB30c),// address collectModule;
        //     toBytes(1),// bytes collectModuleInitData;
        //     address(0),// address referenceModule;
        //     bytes("")// bytes referenceModuleInitData;
        // );

        // lensHub.post(sellerPost);
    }

    function toBytes(uint256 x) public returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}
