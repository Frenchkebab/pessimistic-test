// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*==================== Original Contract Code ====================*/

contract Wallet {
    mapping(address => uint256) public balances;

    function deposit(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            require(result, "External call returned false");
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

/*==================== Test ====================*/
import {Test, console} from "forge-std/Test.sol";

contract Task2Test is Test {
    Wallet wallet;

    address deployer;
    address user;

    function setUp() public {
        deployer = makeAddr("deployer");
        user = makeAddr("user");

        vm.label(deployer, "deployer");
        vm.label(user, "user");

        vm.prank(deployer);
        wallet = new Wallet();

        vm.deal(deployer, 100 ether);
        vm.deal(user, 100 ether);
    }

    function testFundLocked() public {
        vm.startPrank(user);
        address(wallet).call{value: 1 ether}("");
        vm.stopPrank();

        uint256 userWalletBalance = wallet.balanceOf(user);
        assertEq(userWalletBalance, 0, "user wallet balance should be 0");
    }
}
