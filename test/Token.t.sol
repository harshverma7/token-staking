// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Token.sol";

contract TestTokenContract is Test {
     Token c;

     function setUp() public {
        c = new Token(address(this));
     }

     function testMint() public {
        uint value = 10;
        c.mint(address(this), value);
        assert(c.balanceOf(address(this)) == value);
     }

     function test_RevertWhen_MintFails() public {
        uint value = 10;
        address random = vm.addr(1);
        vm.prank(random);
        vm.expectRevert();
        c.mint(random, value);
     }






     
}