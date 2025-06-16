// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VulnerableToken.sol";

contract VulnerableVault {
    mapping(address => uint256) public balances;
    VulnerableToken public immutable token;

    constructor(address _token) {
        token = VulnerableToken(_token);
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    // VULNERABILITY: Reentrancy attack vector
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // External call before state change - VULNERABLE!
        token.transfer(msg.sender, amount);
        balances[msg.sender] -= amount;
    }

    // VULNERABILITY: Unchecked external call
    function emergencyWithdraw(address payable recipient) external {
        uint256 balance = address(this).balance;
        recipient.call{value: balance}("");
    }
}
