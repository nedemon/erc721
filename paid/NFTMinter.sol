// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./NFTPaid.sol";
import "./PayToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMinter {
    IERC20 private erc20;
    NFTPaid private erc721;
    uint constant public MINTING_PRICE = 20;

    constructor(address _erc20, address _erc721) {
        erc20 = IERC20(_erc20);
        erc721 = NFTPaid(_erc721);
    }

    function mint(uint tokenId) external {
        require(erc20.allowance(msg.sender, address(this)) >= MINTING_PRICE, "Unable to pay the minting price");
        erc20.transferFrom(msg.sender, address(this), MINTING_PRICE);
        erc721.safeMint(msg.sender, tokenId);
    }
}