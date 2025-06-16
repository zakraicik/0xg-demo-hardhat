// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VulnerableToken is ERC20, Ownable {
    constructor() ERC20("VulnerableToken", "VULN") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    // VULNERABILITY: Missing access control
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    // VULNERABILITY: tx.origin usage
    function adminTransfer(address from, address to, uint256 amount) external {
        require(tx.origin == owner(), "Only owner");
        _transfer(from, to, amount);
    }
}
