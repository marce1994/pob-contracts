// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IPobEscrow {

    /** EVENTS */

    /** @notice event to signal that a new publication has been published
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @param price Price of the item to sell
     *  @param commission Percentage of commission per 10000
     */
    event Sell(uint256 profileId, uint256 pubId, uint256 price, uint256 commission);

    /** @notice event to signal that a publication received an offer to buy
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @param commissioner address of the user that mirrored the publication or marketplace if 0x0
     */
    event Buy(uint256 profileId, uint256 pubId, address commissioner);

    /** @notice event to signal that a buy has been canceled by the seller
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     */
    event BuyCanceled(uint256 profileId, uint256 pubId);

    /** @notice event to signal that a buy has been confirmed by the buyer
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     */
    event BuyConfirmed(uint256 profileId, uint256 pubId);


    /** FUNCTIONS */

    /** @notice function to sell an item 
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @param price Price of the item to sell
     *  @dev seller will be the msg.sender
     */
    function sell(uint256 profileId, uint256 pubId, uint256 price) external;

    /** @notice function to buy an item
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @param commissioner address of the user that mirrored the publication or marketplace if 0x0
     *  @dev buyer will be the msg.sender
     */
    function buy(uint256 profileId, uint256 pubId, address commissioner) external payable;

    /** @notice function to cancel an item bought and return the value locked
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the seller 
     */
    function cancelBuy(uint256 profileId, uint256 pubId) external;

    /** @notice function to signal a confirmed buy and unlock the value for seller and commissioner
     *  @param profileId Id of the Lens Profile
     *  @param pubId Id of the Lens Publication
     *  @dev reverts if msg.sender is not the buyer
     */
    function confirmBuy(uint256 profileId, uint256 pubId) external;
}