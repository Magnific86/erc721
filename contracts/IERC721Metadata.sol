// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./IERC721.sol";

interface IERC721Metadata is IERC721 {
    function name() external view returns (string calldata);

    function symbol() external view returns (string calldata);

    // https:// + tokenId or ipfs:// + tokenId
    function tokenURI(uint tokenId) external view returns (string calldata);
}
