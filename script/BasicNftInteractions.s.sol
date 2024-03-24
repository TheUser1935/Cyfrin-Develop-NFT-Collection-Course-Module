// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    BasicNft basicNft;
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "BasicNft",
            block.chainid
        );

        //Call our minting interactions function
        mintNftOnContract(mostRecentDeployment, PUG);
    }

    function mintNftOnContract(
        address contractAddress,
        string memory tokenUri
    ) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(tokenUri);
        vm.stopBroadcast();
    }
}
