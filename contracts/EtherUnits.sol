// SPDX-License-Identifier: none

pragma solidity ^0.8.0;

contract EtherUnits {
    uint256 private oneWei = 1 wei;
    uint256 private oneEther = 1 ether;
    bool private isOneWei = 1 wei == 1;
    // 1 ether = 10^18 wei
    uint256 private oneEtherinWei = 10e18 wei;
    bool private isOneEther = oneEtherinWei == 1 ether;

    function getOneEtherInWei() public view returns (uint256) {
        return oneEtherinWei;
    }

    function getOneEther() public view returns (uint256) {
        return oneEtherinWei;
    }
}
