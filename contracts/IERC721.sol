// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed appproved,
        uint indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool indexed approved
    );

    function balanceOf(address owner) external view returns (uint);

    function ownerOf(uint tokenId) external view returns (address);

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function setApprovalForAll(address operator, bool approved) external;

    function getApproved(uint tokenId) external view returns (address);

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}
