// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "src/interfaces/IPobEscrow.sol";
import "lens/core/LensHub.sol";

uint256 constant PUBLISHED = 0;
uint256 constant LOCKED = 1;
uint256 constant SOLD = 2;
address constant MAINNET_LENS_HUB = 0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d;
address constant MUMBAI_LENS_HUB = 0x60Ae865ee4C725cd04353b5AAb364553f56ceF82;


contract PobEscrow is IPobEscrow, Ownable {
    LensHub private _lensHub = LensHub(MUMBAI_LENS_HUB);

    mapping(address => uint256) internal _balance;
    mapping(address => uint256) internal _balanceLocked;
    mapping(uint256 => mapping(uint256 => Sale)) internal _lockedSales;
    
    struct Sale {
        uint256 price; // total price del producto

        address seller; // --
        address buyer; // --
        address commissioner; // address del commisioner

        uint256 amount; // ammount que recibe el seller
        uint256 commission; // ammount que recibe el commissioner

        uint256 state; // Publication state
    }
    
    constructor() {
    }

    /** FUNCTIONS */

    /** @notice function to sell an item 
     *  @param pubId Id of the Lens Publication
     *  @param price Price of the item to sell
     *  @dev seller will be the msg.sender
     */
    function sell(uint256 profileId, uint256 pubId, uint256 price) external {
        address seller = msg.sender;
         
        //  getPub(uint256 profileId, uint256 pubId)

        // require(_lensHub.getPub[pubId].seller == address(0), "ALREADY PUBLISHED");
        require(_lockedSales[pubId].seller == address(0), "ALREADY PUBLISHED");


        // Sale sale = new Sale();
        // sale.
    }

    /** @notice function to buy an item
     *  @param pubId Id of the Lens Publication
     *  @param commissioner address of the user that mirrored the publication or marketplace if 0x0
     *  @dev buyer will be the msg.sender
     */
    function buy(uint256 profileId, uint256 pubId, address commissioner) external payable {
        Sale storage sale = _lockedSales[profileId][pubId];
        
        require(_lockedSales[profileId][pubId].buyer == address(0), "ALREADY SOLD");
        require(msg.sender != sale.seller, "");

        _balance[msg.sender] = msg.value;
        sale.buyer = msg.sender;
        sale.state = LOCKED;

        if(commissioner == address(0))
        {
            sale.commisioner = address(this);
        } else {
            sale.commissioner = commissioner;
        }


        emit Buy(profileId, pubId, sale.commissioner);
    }

    /** @notice function to cancel an item bought and return the value locked
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the seller 
     */
    function cancelBuy(uint256 profileId, uint256 pubId) external {
        Sale storage sale = _lockedSales[profileId][pubId];
        require(msg.sender == sale.seller, "SENDER_MUST_BE_SELLER");

        sale.buyer = address(0);
        sale.state = PUBLISHED;

        payable(sale.buyer).call{ value: sale.price }("");

        emit BuyCanceled(profileId, pubId);
    }

    /** @notice function to signal a confirmed buy and unlock the value for seller and commissioner
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the buyer
     */
    function confirmBuy(uint256 profileId, uint256 pubId) external {
        require(msg.sender == sale.buyer, "SENDER_MUST_BE_BUYER");

        sale.state = SOLD;

        payable(sale.commissioner).call{ value: sale.commission }("");
        payable(sale.seller).call{ value: sale.amount }("");

        emit BuyConfirmed(profileId, pubId);
    }

    function sold(uint256 profileId, uint256 pubId) public view returns (bool) {
        return _lockedSales[pubId].buyer != address(0);
    }
}