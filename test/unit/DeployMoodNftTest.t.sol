// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft deployMoodNft;

    function setUp() public {
        deployMoodNft = new DeployMoodNft();
    }

    function testSvgToUri() public view {
        string
            memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj48dGV4dCBmaWxsPSJibHVldmlvbGV0IiB4PSIwIiB5PSIxMDAiIGZvbnQtc2l6ZT0iMTgiPkhpISBUaGlzIGlzIFNWRyE8L3RleHQ+PC9zdmc+";

        string
            memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text fill="blueviolet" x="0" y="100" font-size="18">Hi! This is SVG!</text></svg>';

        string memory returnedUri = deployMoodNft.svgToImageUri(svg);
        console.log("returned URI", returnedUri);

        assert(
            keccak256(abi.encodePacked(expectedUri)) ==
                keccak256(abi.encodePacked(returnedUri))
        );
    }
}
