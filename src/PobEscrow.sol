// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "src/interfaces/IPobEscrow.sol";
import "lens/core/LensHub.sol";

uint256 constant NON_EXISTANT = 0;
uint256 constant PUBLISHED = 1;
uint256 constant LOCKED = 2;
uint256 constant SOLD = 3;
address constant MAINNET_LENS_HUB = 0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d;
address constant MUMBAI_LENS_HUB = 0x60Ae865ee4C725cd04353b5AAb364553f56ceF82;


contract PobEscrow is IPobEscrow, Ownable {
    LensHub private _lensHub = LensHub(MUMBAI_LENS_HUB);

    uint256 public currentCommission; // Commission percentaje with 2 decimals

    mapping(address => uint256) internal _balance;
    mapping(uint256 => mapping(uint256 => Sale)) internal _sales;
    
    struct Sale {
        uint256 state; // Publication state

        uint256 price; // total price del producto
        address seller; // --

        address buyer; // --
        address commissioner; // address del commisioner
        uint256 commission; // percentage per 10000 of commission

    }
    
    modifier isPublisher(address publisher, uint256 profileId, uint256 pubId) {
        require(_lensHub.ownerOf(profileId) == publisher, "NOT PROFILE OWNER");
        require(_lensHub.getPub(profileId, pubId).profileIdPointed == profileId, "NOT PUBLISHER");
        _;
    }

    constructor(uint256 _commission) {
        currentCommission = _commission;
    }

    /** FUNCTIONS */
    /** @notice function to set the commission
     *  @param _commission the new commission (per 10000)
     *  @dev reverts if msg.sender is not owner
     */
    function setCurrentCommission(uint256 _commission) external onlyOwner {
        currentCommission = _commission;
    }

    /** @notice function to sell an item 
     *  @param pubId Id of the Lens Publication
     *  @param price Price of the item to sell
     *  @dev seller will be the msg.sender
     */
    function sell(uint256 profileId, uint256 pubId, uint256 price) external isPublisher(msg.sender, profileId, pubId) {
        require(_sales[profileId][pubId].seller == address(0), "ALREADY PUBLISHED");
        require(price > 0, "PRICE IS ZERO");

        _sales[profileId][pubId].seller = msg.sender;
        _sales[profileId][pubId].price = price;
        _sales[profileId][pubId].state = PUBLISHED;
        _sales[profileId][pubId].commission = currentCommission;

        emit Sell(profileId, pubId, price, currentCommission);
    }

    /** @notice function to buy an item
     *  @param pubId Id of the Lens Publication
     *  @param commissioner address of the user that mirrored the publication or marketplace if 0x0
     *  @dev buyer will be the msg.sender
     */
    function buy(uint256 profileId, uint256 pubId, address commissioner) external payable {
        Sale storage sale = _sales[profileId][pubId];
        
        require(sale.state == PUBLISHED, "NOT AVAIBLE");
        require(msg.sender != sale.seller, "BUYER = SELLER");
        require(msg.value == sale.price);

        // TODO: Add check of PoH for commissioners

        sale.buyer = msg.sender;
        sale.state = LOCKED;
        
        if (sale.commissioner == address(0)){
            sale.commissioner = owner();
            // TODO: update balances
        } else {
            sale.commissioner = commissioner;
            // TODO: update balances
        }


        emit Buy(profileId, pubId, sale.commissioner);
    }

    /** @notice function to cancel an item bought and return the value locked
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the seller 
     */
    function cancelBuy(uint256 profileId, uint256 pubId) external {
        Sale storage sale = _sales[profileId][pubId];
        require(msg.sender == sale.seller, "SENDER IS NOT SELLER");
        require(sale.state == LOCKED, "ITEM NOT BOUGHT");

        sale.buyer = address(0);
        sale.state = PUBLISHED;
        sale.commissioner = address(0);

        // TODO: update balances

        (bool success, ) = payable(sale.buyer).call{ value: sale.price }("");
        require(success, "REFUND FAILED");

        emit BuyCanceled(profileId, pubId);
    }

    /** @notice function to signal a confirmed buy and unlock the value for seller and commissioner
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the buyer
     */
    function confirmBuy(uint256 profileId, uint256 pubId) external {
        Sale storage sale = _sales[profileId][pubId];

        require(msg.sender == sale.buyer, "SENDER IS NOT BUYER");
        require(sale.state == LOCKED, "ITEM NOT BOUGHT");

        sale.state = SOLD;

        uint256 commissionAmount = sale.price * sale.commission / 10000;
        uint256 amount = sale.price - commissionAmount;

        // TODO: update balances

        (bool successSell, ) = payable(sale.seller).call{ value: amount }("");
        require(successSell, "SELLER TRANSFER FAILED");
    
        if (sale.commissioner != address(0)){
            (bool successComm, ) = payable(sale.commissioner).call{ value: commissionAmount }("");
            require(successComm, "COMMISSION TRANSFER FAILED");
        }
    
        emit BuyConfirmed(profileId, pubId);
    }

    function withdraw() external onlyOwner {
        // TODO: withdraw only leftovers
    }

    function state(uint256 profileId, uint256 pubId) public view returns (uint256) {
        require(_sales[profileId][pubId].state != NON_EXISTANT, "NON EXISTANT ITEM");
        return _sales[profileId][pubId].state;
    }
}