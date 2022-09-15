// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTFree is ERC721, ERC721Enumerable {
    using Counters for Counters.Counter;

    uint public constant MAX_SUPPLY = 11;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NFTFree", "NFTF") {
        _tokenIdCounter.increment();
    }

    function safeMint(address to) public {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Can only mint 10 NFTs!");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
    
    function _baseURI() internal pure override  returns (string memory) {
        return "ipfs://QmTUVpaFaebsaFyG4qqmgnCXoGxVGvXENEbrFaTgAjSYNg/";
    }



    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}