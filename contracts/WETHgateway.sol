// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "https://github.com/aave/aave-v3-periphery/blob/7a9542963b8030885443800179c57ff8ffdac29c/contracts/misc/interfaces/IWETHGateway.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";



contract WETHgateway  {


receive() external payable {}

 address public constant WETHgatewayaddress = 0xd5B55D3Ed89FDa19124ceB5baB620328287b915d;

 IWETHGateway public WETHgatewayContract;


IPoolAddressesProvider public ADDRESSES_PROVIDER;
IPool public POOL;

address public pooladdress = 0x368EedF3f56ad10b9bC57eed4Dac65B26Bb667f6;

    //this address is for Goerli
    address public aWETH = 0x27B4692C93959048833f40702b22FE3578E77759;



constructor() {

 WETHgatewayContract = IWETHGateway(WETHgatewayaddress);
 POOL = IPool(0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D);
 approveWETH();

}


// function depostitETH (uint amount) external payable {

// //WETHgatewayContract.depositETH{value: (amount)}(pooladdress, address(this), 0);
// WETHgatewayContract.depositETH{value: (.0005 ether)}(pooladdress, address(this), 0);

// }


function depostitETH () external payable {


WETHgatewayContract.depositETH{value: (.0005 ether)}(pooladdress, address(this), 0);

}


// function WithdrawETH (address investor) external  {

//     WETHgatewayContract.withdrawETH(pooladdress, type(uint256).max, address(this));

//     selfdestruct(payable(investor));
// }


function WithdrawETH (uint256 amount) external  {

    WETHgatewayContract.withdrawETH(pooladdress, amount, address(this));

   // selfdestruct(payable(investor));
}

 function approveWETH() internal
    {
        IERC20(aWETH).approve(WETHgatewayaddress, 115792089237316195423570985008687907853269984665640564039457584007913129);
   
        IERC20(aWETH).approve(pooladdress, 115792089237316195423570985008687907853269984665640564039457584007913129);
    }

 

   




}
   
