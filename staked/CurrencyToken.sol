// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CurrencyToken is ERC20, Ownable {
    address private minter;
    constructor() ERC20("CurrencyToken", "NFTC") {}

    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == minter, "only minter contract is allowed to mint");
        //require(msg.sender == tx.origin, "minter must be a contract");
        _mint(to, amount);
    }    

}
