// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Use with the Notes I have taken to maximise the understanding here

contract CallAnything {
    //Create some storage variables to use in this lesson
    address public s_someAddress;
    uint256 public s_amount;

    // Simple function to practise encoding data and calling anything
    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount;
    }

    // Function to demostrating one way to get the selector for our simlpe transfer function

    function getSelectorOne() public pure returns (bytes4 selector) {
        // We know from our notes that the function signature is the text string of the name of the function, followed by the param input types
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
        // 0: bytes4: selector 0xa9059cbb
        // The returned result matches the example in the notes!

        return selector;
    }

    // We have a function to give us the function selector from the function signature, but to complete our encoding for 'call' - we still need to encode our param inputs!

    function getDataToCallTransfer(
        address someAddress,
        uint256 amount
    ) public pure returns (bytes memory) {
        // We have only covered a couple of encoding cheatcodes that solidity has, but looking through the options at: https://docs.soliditylang.org/en/latest/cheatsheet.html
        // We can see that there are a lot more options for us to use
        // In fact, we already are able to get the encoded function selector which means we can use some of these other encoding functions to simplify our process - e.g. abi.encodeWithSelector(bytes4 selector, ...) -> returns (bytes memory)
        // This will prepend the 4 bytes function selector to our encoding

        // Pass in function that returns selector, the first param input value, the second parm input value
        //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,1
        return (abi.encodeWithSelector(getSelectorOne(), someAddress, amount));
        // 0: bytes: 0xa9059cbb0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000001
        // WE HAVE NOW GENERATED THE BINARY DATA THAT CAN BE USED TO INTERACT WITH FUNCTIONS OF A CONTRACT USING THE 'call' LOW-LEVEL CHEATCODE FUNCTION!
    }

    //Having now encoded all the pieces reaquired for the data field of a transaction, we can actually use 'call' and our compiled binary to call the transfer function directly using binary format!
    function callTransferFunctionWithBinary(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        //Get function selector by encoding, encode param input values and prepend function selector
        //Use this to populate the data field for 'call' - the ( ) parenthesis

        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
        );

        return (bytes4(returnData), success);

        //Decoded Return Values:
        //{	"0": "bytes4: 0x00000000",	"1": "bool: true" }
        // Bytes4 is all zeros because the transfer function doesnt return anything, bool value indicates the call was successful!
        //s_amount now  = 0: uint256: 70
        //s_someAddress now = 0: address: 0x406AB5033423Dcb6391Ac9eEEad73294FA82Cfbc
    }

    //Passed the following param input values: "transfer(address,uint256)",0xC3Ba5050Ec45990f76474163c5bA673c244aaECA,101

    function callTransferFunctionWithBinaryUsingFunctionSignature(
        string memory functionSignature,
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        //abi.encodeWithSignature(string memory signature, ...) returns (bytes memory): Equivalent to abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)
        //Transfer fucntion signature:"transfer(address,uint256)"
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSignature(functionSignature, someAddress, amount)
        );

        return (bytes4(returnData), success);

        //Decoded Return Values:
        //{	"0": "bytes4: 0x00000000",	"1": "bool: true" }
        // Bytes4 is all zeros because the transfer function doesnt return anything, bool value indicates the call was successful!
        //s_amount now  = 0: uint256: 101
        //s_someAddress now = 0: address: 0xC3Ba5050Ec45990f76474163c5bA673c244aaECA
    }

    //------------------- Bunch of different ways to get signature -----------------

    // We can also get a function selector from data sent into the call
    function getSelectorTwo() public view returns (bytes4 selector) {
        bytes memory functionCallData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            address(this),
            123
        );
        selector = bytes4(
            bytes.concat(
                functionCallData[0],
                functionCallData[1],
                functionCallData[2],
                functionCallData[3]
            )
        );
    }

    // Another way to get data (hard coded)
    function getCallData() public view returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                address(this),
                123
            );
    }

    // Pass this:
    // 0xa9059cbb000000000000000000000000d7acd2a9fd159e69bb102a1ca21c9a3e3a5f771b000000000000000000000000000000000000000000000000000000000000007b
    // This is output of `getCallData()`
    // This is another low level way to get function selector using assembly
    // You can actually write code that resembles the opcodes using the assembly keyword!
    // This in-line assembly is called "Yul"
    // It's a best practice to use it as little as possible - only when you need to do something very VERY specific
    function getSelectorThree(
        bytes calldata functionCallData
    ) public pure returns (bytes4 selector) {
        // offset is a special attribute of calldata
        assembly {
            selector := calldataload(functionCallData.offset)
        }
    }

    // Another way to get your selector with the "this" keyword
    function getSelectorFour() public pure returns (bytes4 selector) {
        return this.transfer.selector;
    }

    // Just a function that gets the signature
    function getSignatureOne() public pure returns (string memory) {
        return "transfer(address,uint256)";
    }
}

// SECOND CONTRACT TO INTERACT WITH OUR FIRST CONTRACT

contract callFunctionWithoutContractData {
    address public s_selectorsAndSignaturesAddress;

    constructor(address selectorsAndSignaturesAddress) {
        s_selectorsAndSignaturesAddress = selectorsAndSignaturesAddress;
    }

    // pass in 0xa9059cbb000000000000000000000000d7acd2a9fd159e69bb102a1ca21c9a3e3a5f771b000000000000000000000000000000000000000000000000000000000000007b
    // you could use this to change state
    function callFunctionDirectly(
        bytes calldata callData
    ) public returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.call(
                abi.encodeWithSignature("getSelectorThree(bytes)", callData)
            );
        return (bytes4(returnData), success);
    }

    // with a staticcall, we can have this be a view function!
    function staticCallFunctionDirectly() public view returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.staticcall(
                abi.encodeWithSignature("getSelectorOne()")
            );
        return (bytes4(returnData), success);
    }

    function callTransferFunctionDirectlyThree(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        (
            bool success,
            bytes memory returnData
        ) = s_selectorsAndSignaturesAddress.call(
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    someAddress,
                    amount
                )
            );
        return (bytes4(returnData), success);
    }
}
