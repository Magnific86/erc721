// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./LibStrings.sol";

contract ERC721 is IERC721, IERC721Metadata {
    using Strings for uint;
    string public _name;
    string public _symbol;

    mapping(address => uint) public _balances;
    mapping(uint => address) public _owners;
    mapping(uint => address) public _tokenApprovals;
    mapping(address => mapping(address => bool)) public _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    modifier requireMinted(uint tokenId) {
        require(exist(tokenId), "Not minted!");
        _;
    }

    function _isApprovedOrOwner(address spender, uint tokenId) public view returns(bool) {
        address owner = ownerOf(tokenId);
        return(
            spender == owner ||
                isApprovedForAll(owner, spender) ||
                getApproved(tokenId) == spender
        );
    }

    modifier ownerExist(address owner) {
        require(owner != address(0), "Owner not exist!");
        _;
    }

    function exist(uint tokenId) public view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function transferFrom(
        address to,
        address from,
        uint tokenId
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner!");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) public  {
        _safeTransfer(from, to, tokenId, data);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function _baseURI() public view virtual returns (string memory) {
        return "";
    }

    function tokenURI(
        uint tokenId
    ) public view requireMinted(tokenId) returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function balanceOf(
        address owner
    ) public view ownerExist(owner) returns (uint) {
        return _balances[owner];
    }

    function ownerOf(
        uint tokenId
    )
        public
        view
        ownerExist(_owners[tokenId])
        requireMinted(tokenId)
        returns (address)
    {
        return _owners[tokenId];
    }

    function approve(address to, uint tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner != to, "Cannot approve yourself!");
        require(
            owner == msg.sender || isApprovedForAll(owner, msg.sender),
            "You cannot operate!"
        );
        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public {
        require(msg.sender != operator, "Cannot approve yourself!");
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function getApproved(uint tokenId) public view requireMinted(tokenId) returns (address) {
        return _tokenApprovals[tokenId];
    }

    function _safeTransfer(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) public {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, data),
            "This _transfer to non-ERC721 receiver!"
        );
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) public returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    from,
                    msg.sender,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Transfer to non-ERC721 receiver");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _transfer(address from, address to, uint tokenId) internal {
        require(ownerOf(tokenId) == from, "incorrect owner!");
        require(to != address(0), "You transfer to zero address!");

        _beforeTokenTransfer(from, to, tokenId);

        delete _tokenApprovals[tokenId];
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    function _beforeTokenTransfer(
        address to,
        address from,
        uint tokenId
    ) internal virtual {}

    function _afterTokenTransfer(
        address to,
        address from,
        uint tokenId
    ) internal virtual {}
}

