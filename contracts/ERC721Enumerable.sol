// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./ERC721.sol";
import "./IERC721Enumerable.sol";

abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    uint[] private _allTokens;
    mapping(address => mapping(uint => uint)) private _ownedTokens; //address, tokenIndex => tokenId
    mapping(uint => uint) private _allTokensIndex; //tokenId => tokenIndex
    mapping(uint => uint) private _ownedTokensIndex; // tokenId (ownera) => tokenIndex(indexes of owner not all indexes)

    function totalSupply() public view returns (uint) {
        return _allTokens.length;
    }

    function tokenOfOwnerByIndex(
        address owner,
        uint index
    ) public view returns (uint) {
        require(index < balanceOf(owner), "out of bonds!");
        return _ownedTokens[owner][index];
    }

    function _addTokenToAllTokensEnumeration(uint tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumaration(uint tokenId) private {
        uint lastTokenIndex = _allTokens.length - 1;
        uint tokenIndex = _allTokensIndex[tokenId];
        uint lastTokenId = _allTokens[lastTokenIndex];
        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenId;
        delete _allTokensIndex[tokenId];

        _allTokens.pop();
    }

    function _addTokenToOwnerEnumeration(address to, uint tokenId) private {
        uint _length = balanceOf(to);

        _ownedTokensIndex[tokenId] = _length;
        _ownedTokens[to][_length] = tokenId;
    }

    function _removeTokenFromAllTokensEnumaration(
        address from,
        uint tokenId
    ) private {
        uint lastTokenIndex = balanceOf(from) - 1;
        uint tokenIndex = _allTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId;
            _allTokensIndex[lastTokenId] = tokenIndex;
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function tokenByIndex(uint index) public view returns (uint) {
        require(index < totalSupply(), "out of bonds!");
        return _allTokens[index];
    }

    function _beforeTokenTransfer(
        address to,
        address from,
        uint tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(to, from, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumaration(tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumaration(from, tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }
}
