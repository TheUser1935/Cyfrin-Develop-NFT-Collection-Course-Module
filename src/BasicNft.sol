// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    //Use this to keep track of how many tokens/NFTs have been minted
    uint256 private s_tokenCounter;

    //When we launch this ERC721 contract with the values supplied in the constructor, we are actually representing a whole collection of 'dogie's and each 'dogie' in this NFT collection will get its own unique tokenId
    constructor() ERC721("Dogie", "DOG") {
        //Set the token counter to 0
        s_tokenCounter = 0;
    }

    //Mint a new NFT
    function mintNft() public {}

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {}
}
