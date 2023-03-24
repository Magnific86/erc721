// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./ERC721.sol";

abstract contract ERC721URIStorage is ERC721 {
    mapping(uint => string) private _tokenURIs;

    function _setTokenURI(
        uint tokenId,
        string memory currTokenURI
    ) public virtual requireMinted(tokenId) {
        _tokenURIs[tokenId] = currTokenURI;
    }

    function tokenURI(
        uint tokenId
    )
        public
        view
        virtual
        override
        requireMinted(tokenId)
        returns (string memory)
    {
        string memory currTokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        if (bytes(base).length == 0) {
            return currTokenURI;
        }
        if (bytes(currTokenURI).length > 0) {
            return string(abi.encodePacked(base, currTokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _burn(uint tokenId) public virtual override {
        super._burn(tokenId);
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}
