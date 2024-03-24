// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//Import the utils to convert bytes32 to base64 from open zeppelin
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    //Errors
    error MoodNft_CantFlipMoodIfNotOwner();

    //Use this to keep track of how many tokens/NFTs have been minted
    uint256 private s_tokenCounter;
    //
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    //Enumerated type
    enum Mood {
        HAPPY,
        SAD
    }

    //mapping of tokenId to tokenURI
    mapping(uint256 => string) private s_tokenIdToUri;

    //Mapping of tokenId to mood
    mapping(uint256 => Mood) private s_tokenIdToMood;

    //Could pass in the text for the SVGs, and look to handle encoding and stuff on chain for image URIs - Or, since already have the ability to encode it and generate a browser URI - we can just do that, saving a step and some gas --> so the input becomes the data:image/svg+xml;base64,XXXX URI that is mentioned in Notes.md
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MOODY") {
        //Set the token counter to 0
        s_tokenCounter = 0;
        //Set the sad and happy SVGs
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    //Function to mint of these dynamic NFTs
    function mintNft() public {
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
        //Set the mood
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        //Increment the token counter
        s_tokenCounter++;
    }

    //Base URI for JSON metadata
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        //Get correct image uri based upon mood state
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        }

        /* string.concat() allows us to concatenate strings together but still leaves us with a string and not bytes32 which is required for base64 encoding
        string memory tokenMetadata = string.concat(
            '{"name": "',
            name(),
            '"description": "A Moody little NFT","attributes": [{"trait_type": "Feeling", "value": 100}],"image": ',
            imageURI,
            '"}"'
        );
        */

        string memory tokenMetadata = string( //Use string constructor to tranform data from bytes to allow concatination
            //Join base URI with rest of metadata by using abi.encodePacked() and _baseUri function
            abi.encodePacked(
                _baseURI(),
                //We can use the Open Zeppelin Base64 library to convert our bytes32 to base64
                Base64.encode(
                    // Use abi encoding inside of bytes transfomer
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "A Moody little NFT", "attributes": [{"trait_type": "Feeling", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );

        return tokenMetadata;
    }

    function flipMood(uint256 tokenId) public {
        /*Only want the NFT owner to change the mood
        Course said that OpenZeppelin has a function called _isApprovedOrOwner which allows us to check if the msg.sender is the owner or approved address of the NFT, but I did not see it in the contracts - did find the ownerOf function 
        */

        if (msg.sender != ownerOf(tokenId)) {
            revert MoodNft_CantFlipMoodIfNotOwner();
        }

        //Flip the mood to the opposite of what it currently is
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    //My getter function to get the mood of the NFT
    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
