// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";



//Note: this contract is to facilitate swapping between addresses since Aave testnet addresses are 
//unique. In production, uniswap will be used to faciliate swapping 

contract FakeUniswap {

 address private immutable wethAddress =
        0x2e3A2fb8473316A02b8A297B982498E661E1f6f5;  

  address private immutable wbtcAddress =
        0x8869DFd060c682675c2A8aE5B21F2cF738A0E3CE;

   address private immutable linkAddress =
        0x07C725d58437504CA5f814AE406e70E21C5e8e9e; 

        IERC20 public weth;
        IERC20 public wbtc;
        IERC20 public link;


      


function SwapLINKforWETH (uint amount) external {

    link.transfer(address(this), amount);
    weth.transfer(msg.sender, amount);

}

function SwapLINKforWBTC (uint amount) external {
    link.transfer(address(this), amount);
    wbtc.transfer(msg.sender, amount);

}

function SwapWETHforLINK (uint amount) external  {
    weth.transfer(address(this), amount);
    link.transfer(msg.sender, amount);
}


function SwapWBTCforLINK (uint amount) external {
    wbtc.transfer(address(this), amount);
    link.transfer(msg.sender, amount);
}







}
