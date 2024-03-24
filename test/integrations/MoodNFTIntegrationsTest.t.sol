// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "lib/forge-std/src/console.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftIntegrationsTest is Test {
    MoodNft public moodNft;
    DeployMoodNft public deployMoodNft;

    address public USER = makeAddr("USER");

    function setUp() public {
        deployMoodNft = new DeployMoodNft();

        moodNft = deployMoodNft.run();
    }

    function testTokenUriIsCorrectIntegrations() public {
        vm.prank(USER);
        moodNft.mintNft();

        console.log("Token URI: ", moodNft.tokenURI(0));
    }

    function testMoodFlips() public {
        vm.prank(USER);

        moodNft.mintNft();
        uint256 startingMood = uint256(moodNft.getMood(0));

        /**
        @dev WHY THE HELL DO THESE CONSOLE.LOG LINES NOT WORK?

        KEPT ON HAVING COMPILATION PROBLEMS WITH THE ERROR OF 'Error (9582): Member "log" not found or not visible after argument-dependent lookup in type(library console).'

        have no problem with the 'testTokeUriIsCorrect' function?!?!?!?!

        even when changing named import from Test.sol to actual console.sol it still doesn't work for this function test
        
        */

        //console.log("Start Mood: ", moodNft.getMood(0));

        vm.prank(USER);
        moodNft.flipMood(0);
        uint256 endingMood = uint256(moodNft.getMood(0));

        //console.log("End Mood: ", moodNft.getMood(0));

        assert(endingMood != startingMood);
    }

    function testCantFlipMoodIfNotOwner() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.expectRevert();
        moodNft.flipMood(0);
    }
}
