// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./ERC721.sol";
import "./ERC721URIStorage.sol";
import "./ERC721Enumerable.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage {
    address private _owner;
    uint currTokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _owner = msg.sender;
    }

    function safeMint(address to, string memory tokenId) public {
        require(_owner == msg.sender, "Only owner!");
        _safeMint(to, currTokenId);
        _setTokenURI(currTokenId, tokenId);

        currTokenId++;
    }

    function _baseURI() public pure override returns (string memory) {
        return "ipfs://";
    }

    function tokenURI(
        uint tokenId
    )
        public
        view
        override(ERC721, ERC721URIStorage)
        requireMinted(tokenId)
        returns (string memory)
    {}

    function _burn(uint tokenId) public override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(
        address to,
        address from,
        uint tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(to, from, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
