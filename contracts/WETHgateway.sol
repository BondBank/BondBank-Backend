// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@aave/periphery-v3/contracts/misc/interfaces/IWETHGateway.sol";
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





function depositETH () public payable {


WETHgatewayContract.depositETH{value: (.0008 ether)}(pooladdress, address(this), 0);

}





function WithdrawETH (uint256 amount) public  {

    WETHgatewayContract.withdrawETH(pooladdress, amount, address(this));

  
}

 function approveWETH() internal
    {
        IERC20(aWETH).approve(WETHgatewayaddress, 758400791312900000);
   
        IERC20(aWETH).approve(pooladdress, 7584007913129000000);
    }

 

   




}
   
