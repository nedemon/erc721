// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./NFTToken.sol";
import "./CurrencyToken.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract CurrencyMinter is IERC721Receiver {

    struct Staker {
        mapping(uint256 => bool) tokenIds;
        mapping(uint256 => uint256) tokenStakingRefreshTimestamp;
    }

    CurrencyToken private erc20;
    IERC721 private erc721;
    
    uint256 constant STAKING_TIME = 60 seconds;
    uint256 constant STAKING_REWARD = 20;

    mapping (uint => address) public originalOwner;
    mapping (address => Staker) private stakers;

    constructor(address _erc20, address _erc721) {
        erc20 = CurrencyToken(_erc20);
        erc721 = IERC721(_erc721);
    }

    function withdrawNFT(uint tokenId) external {
        require(originalOwner[tokenId] == msg.sender, "Not the original owner withdrawing");
        Staker storage staker = stakers[msg.sender];
        staker.tokenIds[tokenId] = false;        
        erc721.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    function getRewards(uint tokenId) external {
        // check that i have msg.sender's nft
        require(stakers[msg.sender].tokenIds[tokenId] == true, "NFT wasn't staked");
        // check that stakingTime has passed
        require(stakers[msg.sender].tokenStakingRefreshTimestamp[tokenId] < block.timestamp, "Staking time hasn't passed yet");
        stakers[msg.sender].tokenStakingRefreshTimestamp[tokenId] = block.timestamp + STAKING_TIME;
        erc20.mint(msg.sender, STAKING_REWARD);
    }

    function onERC721Received(
        address, //operator,
        address from,
        uint256 tokenId,
        bytes calldata // data
    ) external override returns (bytes4) {
        originalOwner[tokenId] = from;
        Staker storage staker = stakers[from];
        staker.tokenIds[tokenId] = true; 
        return IERC721Receiver.onERC721Received.selector;
    }
}