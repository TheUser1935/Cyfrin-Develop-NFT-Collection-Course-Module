// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployBasicNft;
    BasicNft public basicNft;
    address public USER = makeAddr("USER");
    string public constant URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        /*
        Strings are arrays of bites and we can't use == operator to compare arrays, we can only compare primative types (uint256, bool, bytes32, etc)
        Since they are arrays, we could loop through each character of the string and compare them one by one OR
        We could hash both strings and compare the hashes

        Notes.md --- CONTAINS WALKTHROUGH OF HASHING STRINGS FOR COMPARISON USING CHISEL and abi encoding, keccak256 ---

        want to log hash values simply for own interest. Will comment out later.
        
        console2.log(
            "Expected Name Hash value: ",
            keccak256(abi.encodePacked(expectedName))
        );
        console2.log(
            "Actual Name Hash value: ",
            keccak256(abi.encodePacked(actualName))
        );
        */
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);

        basicNft.mintNft(URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(URI))
        );
    }
}
