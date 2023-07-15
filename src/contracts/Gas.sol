// SPDX-License-Identifier: none
pragma solidity ^0.8.0;

contract Gas {
    uint256 i = 0;
    // gas = unit of computation
    // gas_spent equal to units spent in a transaction
    // gas price, how much ether one is willing to pay per gas
    // gas_cost = gas_price * total_gas_units
    // gas spent will never be refunded
    // forever runs unil all Ether is exhausted in term of gas spent
    function forever() public {
        while (true) {
          i += 1; // when all gas is depleted, the transaction fails
        }
    }
}
