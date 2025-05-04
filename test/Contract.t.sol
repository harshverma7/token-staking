// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Contract.sol";

contract TestContract is Test {
    StakingContract c;

    function setUp() public {
        c = new StakingContract();
    }

    fallback() external payable {}

    receive() external payable {}


    function testStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStake() == value);
    }

    function testUnstake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
         assert(c.totalStake() == value);
        c.unstake(value);
        assert(c.totalStake() == 0);

    }

     function test_RevertWhen_StakeFails() public {
        uint value = 10 ether;
        vm.expectRevert();

        c.stake(value);
    }

    function test_RevertWhen_UnstakeFails() public{
        uint value = 10 ether;
         c.stake{value: value}(value);
         vm.expectRevert();
         c.unstake(value*2);     
    }


}
