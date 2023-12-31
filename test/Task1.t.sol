// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

/*==================== Original Contract Code ====================*/
contract Storage {
    uint64 public constant SCALE = 1e18;

    function scale(uint64 a) external pure returns (uint256 result) {
        result = SCALE * a;
    }
}

contract StorageUint256 {
    uint256 public constant SCALE = 1e18;

    function scale(uint256 a) external pure returns (uint256 result) {
        result = SCALE * a;
    }
}

/*========================= Test Code =========================*/
import {Test, console} from "forge-std/Test.sol";

contract Task1Test is Test {
    Storage storage_;
    StorageUint256 storageUint256_;

    function setUp() public {
        storage_ = new Storage();
        storageUint256_ = new StorageUint256();
    }

    function testMaxValToNotOverflow() public {
        uint64 scale = 1e18;
        uint64 a = 18;

        // The maximum value of a that does not revert is 18
        console.log("a: ", a);
        uint256 result = storage_.scale(a);
        assertEq(result, scale * a, "scale is not correct");
    }

    function testMinValToOverflow() public {
        uint64 a = 19;

        // The minimum value of "a" that reverts by overflow is 19
        console.log("a: ", a);
        vm.expectRevert();
        storage_.scale(a);
    }

    function testStorageUint256() public {
        console.log("type(uint256).max: ", type(uint256).max);
        console.log("\t\t = 1.15792... * 10^77");
        console.log("\n");

        uint256 maxA = type(uint256).max / storageUint256_.SCALE();
        console.log("maximum value of A that does not overflow: ", maxA);
        console.log("\t\t = 1.15792... * 10^(77-18)");
        console.log("\n");

        uint256 result = storageUint256_.scale(maxA);
        console.log("type(uint256).max : ", type(uint256).max);
        console.log("result (a * SCALE): ", result);

        vm.expectRevert();
        storageUint256_.scale(maxA + 1);
    }
}
