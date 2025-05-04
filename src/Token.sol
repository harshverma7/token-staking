// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address stakingAddress;

    constructor(address _stakingAddress) ERC20("Token", "TKN"){
         stakingAddress = _stakingAddress;
    }

    modifier onlyOwner {
        require(msg.sender == stakingAddress);
        _;
    }

    function mint(address _to, uint _amount) public onlyOwner{
        _mint(_to,_amount);
    }

    function updateContract(address _newContract) public onlyOwner{
        stakingAddress = _newContract;
    }





}