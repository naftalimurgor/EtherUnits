// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0;

/**
 * A sample contract to test transfer of Ether for EOA to Contract and Contract to owner.
 */

contract Transfer {
    address public owner;

    event EtherCharged(address amountWei, address indexed from);

    constructor() {
        owner = payable(msg.sender);
    }

    function chargeEther() external {
        // msg.value vs msg.sender stuff
    }
}
