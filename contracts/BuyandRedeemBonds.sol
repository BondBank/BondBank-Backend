// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

pragma abicoder v2;



import "./CreateBondandAdminRole.sol";
import "https://github.com/aave/aave-v3-periphery/blob/7a9542963b8030885443800179c57ff8ffdac29c/contracts/misc/interfaces/IWETHGateway.sol";
// import IPool from "@aave/core-v3/contracts/interfaces/IPool.sol";
// import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "./SimpleSwap.sol";
import "./WETHgateway.sol";




contract BuyandRedeemBonds is CreateBondandAdminRole {


//these addresses contain both principal and the profit for each pool 
address private constant aWETHtokenaddress = 0x27B4692C93959048833f40702b22FE3578E77759;


SimpleSwap public Swap;
WETHgateway public Gateway;




mapping (address => address) public WETHgatewayAddr;
mapping (address => WETHgateway) public WETHgatewaycontract;

mapping (address => address) public Swapaddress;
mapping (address => SimpleSwap) public Swapcontract;


mapping (address => uint[]) internal bondsByBuyersAddr;


address public Pooladdress = 0x368EedF3f56ad10b9bC57eed4Dac65B26Bb667f6;



constructor() CreateBondandAdminRole("") {
 
    
}
//returns bonds bought by a user
function getbondsByBuyersAddr(address addr) external view returns (uint[] memory){
        
  return bondsByBuyersAddr[addr];

}  

 function buybond (uint id) external payable  {
        
    // require (msg.value == 0.001 ether, "Incorrect amount for this bond");

  

    //  Swap = new SimpleSwap();
    //  Gateway = new WETHgateway();



    //      WETHgatewayAddr[msg.sender] = address(Gateway);
    //      Swapaddress[msg.sender] = address(Swap);
    //      WETHgatewaycontract[msg.sender] = Gateway;
    //      Swapcontract[msg.sender] = Swap;
    

       
    //     //mapping for chainlink automation
    //     bondInfo[id].buyers.push(msg.sender);

        
       
    //   Gateway.depostitETH{value: .5 ether}(type(uint256).max);
   

      //Swapcontract[msg.sender].SwapforWETH (type(uint256).max);
      //Swapcontract[msg.sender].swapWETHForALTcoin(type(uint256).max, bondInfo[id].Altcoinswap);


        //this line will transfer the bonds to the user 
       _safeTransferFrom(address(this), msg.sender, id, 1, " ");
//added to track bonds by buyers, donot remove
           bondsByBuyersAddr[msg.sender].push(id);
    }

    function Bondredemption (uint id) external {

     require (bondInfo[id].bondStartDate >= bondInfo[id].bondMaturityDate,"This bond has not yet expired");
     require (balanceOf(msg.sender,id) > 0 , " You do not have any bonds of this kind");

     for (id = 0 ; id <= BondsinExistence.length; id++){

         for (id = 0 ; id <= bondInfo[id].buyers.length; id++){
             if (block.timestamp >= bondInfo[id].bondMaturityDate){
               //logic for redemption
               _burn( msg.sender,  id, balanceOf(msg.sender, id) ); 
                
             }

         }
              
     }
    }

}
















