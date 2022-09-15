// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTPaid is ERC721, Ownable {
    
    address private minter;

    constructor() ERC721("NFTPaid", "NFTP") {}
    function setMinter(address _minter) external  onlyOwner {
        minter = _minter;
    }

    function safeMint(address to, uint256 tokenId) external {
        require(msg.sender == minter, "only minter contract is allowed to mint");
        require(msg.sender == tx.origin, "minter must be a contract");
        _safeMint(to, tokenId);
    }                
}