// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "src/interfaces/IPobEscrow.sol";

uint256 constant PUBLISHED = 0;
uint256 constant LOCKED = 1;
uint256 constant SOLD = 2;

contract PobEscrow is IPobEscrow, Ownable {
    mapping(address => uint256) _balance;
    mapping(address => uint256) _balanceLocked;
    mapping(uint256 => Sale) _lockedSales;

    struct Sale {
        uint256 price; // total price del producto

        address seller; // --
        address buyer; // --
        address commissioner; // address del commisioner

        uint256 amount; // ammount que recibe el seller
        uint256 commission; // ammount que recibe el commissioner

        uint256 state; // Publication state
    }
    
    constructor(address newOwner) {
        _transferOwnership(newOwner);
    }

    function test() public onlyOwner returns (bool) {
        return true;
    }

    /** FUNCTIONS */

    /** @notice function to sell an item 
     *  @param pubId Id of the Lens Publication
     *  @param price Price of the item to sell
     *  @dev seller will be the msg.sender
     */
    function sell(uint256 pubId, uint256 price) external {
        address seller = msg.sender;

        require(_lockedSales[pubId].seller == address(0), "ALREADY PUBLISHED");

        // Sale sale = new Sale();
        // sale.
    }

    /** @notice function to buy an item
     *  @param pubId Id of the Lens Publication
     *  @param commissioner address of the user that mirrored the publication or marketplace if 0x0
     *  @dev buyer will be the msg.sender
     */
    function buy(uint256 pubId, address commissioner) external payable {

    }

    /** @notice function to cancel an item bought and return the value locked
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the seller 
     */
    function cancelBuy(uint256 pubId) external {

    }

    /** @notice function to signal a confirmed buy and unlock the value for seller and commissioner
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the buyer
     */
    function confirmBuy(uint256 pubId) external {

    }

    function sold(uint256 pubId) public view returns (bool) {
        return _lockedSales[pubId].buyer != address(0);
    }
}