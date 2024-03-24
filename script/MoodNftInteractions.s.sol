// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MoodNft} from "../src/MoodNft.sol";
import {Script} from "forge-std/Script.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintMoodNft is Script {
    MoodNft moodNft;

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );

        //Call our minting interactions function
        mintNftOnContract(mostRecentDeployment);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract MintFlipMoodNft is Script {
    MoodNft moodNft;

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );

        //Cal our mood flipping interactions function
        flipMoodOnContract(mostRecentDeployment);
    }

    //Function to flip the mood of the NFT
    function flipMoodOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        MoodNft(contractAddress).flipMood(0);
        vm.stopBroadcast();
    }
}
