// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    //Use this to keep track of how many tokens/NFTs have been minted
    uint256 private s_tokenCounter;

    //mapping of tokenId to tokenURI
    mapping(uint256 => string) private s_tokenIdToUri;

    //When we launch this ERC721 contract with the values supplied in the constructor, we are actually representing a whole collection of 'dogie's and each 'dogie' in this NFT collection will get its own unique tokenId
    constructor() ERC721("Dogie", "DOG") {
        //Set the token counter to 0
        s_tokenCounter = 0;
    }

    //Mint a new NFT
    //Doing a little different and allowing people to pass in the URI of the image for the NFT
    function mintNft(string memory tokenUri) public {
        //Pass the mapping of the uri to the tokenId
        s_tokenIdToUri[s_tokenCounter] = tokenUri;

        /*
         * @dev Mints `tokenId`, transfers it to `to` and checks for `to` acceptance.
         *
         * Requirements:
         *
         * - `tokenId` must not exist.
         * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
         *
         * Emits a {Transfer} event.
         *
         * Makes the balance +1 for `to`, utilises token counter value
         */
        _safeMint(msg.sender, s_tokenCounter);

        //Increment the token counter
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
