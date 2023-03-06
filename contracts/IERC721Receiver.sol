// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


interface IERC721Receiver {
    function onERC721Received(address from, address operator, uint tokenId, bytes memory data) external returns(bytes4 retval);
}