// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MoodNft} from "../src/MoodNft.sol";
import {Script, console} from "forge-std/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    MoodNft public moodNft;

    function run() external returns (MoodNft) {
        string memory sadSVG = vm.readFile("img/DynamicNFT/Sad.svg");
        string memory happySVG = vm.readFile("img/DynamicNFT/Happy.svg");
        //Quick test to ensure working
        //console.log(sadSVG);
        //console.log(happySVG);

        vm.startBroadcast();
        //Deploy the contract
        //Note that we use the svgToImageUri function to convert the SVGs to image URIs that are required for constructor
        moodNft = new MoodNft(svgToImageUri(sadSVG), svgToImageUri(happySVG));
        vm.stopBroadcast();

        return moodNft;
    }

    /** @notice Converts an SVG string to an image URI */
    /*@note we already know the base URI to use, and therefore we just need to get the SVG and encode it before joining it with our base URI */
    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        // We always have the same base URL
        string memory baseUri = "data:image/svg+xml;base64,";

        // Encode SVG to base64 using the imported Base64 contract from OpenZeppelin
        string memory svgBase64EncodedSvg = Base64.encode(
            bytes(abi.encodePacked(svg))
        );
        return string.concat(baseUri, svgBase64EncodedSvg);
    }
}
