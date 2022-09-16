// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract PobEscrow is AccessControl {
    mapping(address => uint256) _balance;
    mapping(address => uint256) _balanceLocked;
    mapping(uint256 => Sale) _lockedSales;

    struct Sale {
        address seller;
        address buyer;
        address commissioner;
        uint256 amount;
        uint256 commission;
    }
    
    constructor() {

    }
    
    
}