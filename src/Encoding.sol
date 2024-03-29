// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//Contract to help learn about advanced EVM features, such as encoding, opcodes, and more
//https://docs.soliditylang.org/en/latest/cheatsheet.html

contract Encoding {
    function combineStrings() public pure returns (string memory) {
        //Here we are encoding the string into bytecode, then decoding them back into human readable formatting - a string!
        return string(abi.encodePacked("Hello! ", "World!")); //"0": "string: Hello! World!"
    }

    //We can just about encode anything we want to the bytecode/binary fromat thats discussed in the lesson notes
    function encodeNumber() public pure returns (bytes memory) {
        //Encode the number into bytecode/binary format - which is of course bytes!
        //Essentially saying hey, take this thing and convert into the language that the contract can understand to be able to interact with it

        bytes memory number = abi.encode(1); //0: bytes: 0x0000000000000000000000000000000000000000000000000000000000000001

        return number;
    }

    function encodeString() public pure returns (bytes memory) {
        //Encode a string into the bytecode/binary format that the EVM understands
        bytes memory myString = abi.encode(
            "Hey mum, i'm learning solidity and the EVM!"
        );
        //0: bytes: 0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000002b486579206d756d2c2069276d206c6561726e696e6720736f6c696469747920616e64207468652045564d21000000000000000000000000000000000000000000
        // We can see that it has encoded it into a large binary format that the EVm and our contract can understand!
        // Notice how the
        return myString;
    }

    function encodeStringPacked() public pure returns (bytes memory) {
        //encode the same string we did before but using the non standard packing encoding function - refer to lesson notes for more info
        bytes memory myStringPacked = abi.encodePacked(
            "Hey mum, i'm learning solidity and the EVM!"
        );
        //The returned imprefect binary/bytecode value is much more compact!
        //0: bytes: 0x486579206d756d2c2069276d206c6561726e696e6720736f6c696469747920616e64207468652045564d21

        return myStringPacked;
    }

    function typeCastString() public pure returns (bytes memory) {
        //Type casting is very similar to encodePacked

        bytes memory myStringBytes = bytes(
            "Hey mum, i'm learning solidity and the EVM!"
        );
        //0: bytes: 0x486579206d756d2c2069276d206c6561726e696e6720736f6c696469747920616e64207468652045564d21

        return myStringBytes;
    }

    function decodeMyEncoded() public pure returns (string memory) {
        //We can encode things, but we can also decode things form binary/bytecode format back into human readable!

        //The decode function takes two input params - first is the encoded data, second is the type of data to decode it into -> it doesn't know what to decode it into, so we have to tell it
        string memory someDecodedString = abi.decode(encodeString(), (string));
        //0: string: Hey mum, i'm learning solidity and the EVM!

        return someDecodedString;
    }

    //We can actually conduct multi encoding of things together, as well as multi decoding

    function multiEncode() public pure returns (bytes memory) {
        //Pass in 2 separate strings to encode together
        bytes memory myMultiEncodedString = abi.encode(
            "I'm string 1",
            "I am string number 2"
        );
        //0: bytes: 0x00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000c49276d20737472696e672031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000144920616d20737472696e67206e756d6265722032000000000000000000000000

        return myMultiEncodedString;
    }

    function multiDecode() public pure returns (string memory, string memory) {
        //We need to still specifiy what to decode too, and because we are decoding back into two separate strings we can provide that info
        (
            string memory firstDecodedString,
            string memory secondDecodedString
        ) = abi.decode(multiEncode(), (string, string));
        //0: string: I'm string 1
        //1: string: I am string number 2

        return (firstDecodedString, secondDecodedString);
    }

    //The normal decode function does not work with packed values because it is not the standard. But we can leverage type casting for decoding

    function multiEncodePacked() public pure returns (bytes memory) {
        //multi encode using packed function
        bytes memory multiEncodedPackedStrings = abi.encodePacked(
            "string 1",
            "this is string 2"
        );
        //0: bytes: 0x737472696e6720317468697320697320737472696e672032
        return multiEncodedPackedStrings;
    }

    function multiCastDecodePacked() public pure returns (string memory) {
        string memory castedString = string(multiEncodePacked());
        //0: string: string 1this is string 2
        //NOTE: since our strings to be encoded together did not have a space, we see no space in type casting decoding
        return castedString;
    }
}
