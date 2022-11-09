// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

pragma abicoder v2;



import "./BondERC1155.sol";
import "./CreateBondandAdminRole.sol";
import "./AaveforLINK.sol";
import "./AaveforWBTC.sol";
import "./AaveforWETH.sol";


interface IFakeUniswap{
function SwapLINKforWETH (uint amount) external;

function SwapLINKforWBTC (uint amount) external;

function SwapWETHforLINK (uint amount) external;

function SwapWBTCforLINK (uint amount) external;


}




contract BuyandRedeemBonds is CreateBondandAdminRole{


//these addresses contain both principal and the profit for each pool 
address private constant aLinktokenAddress = 0x6A639d29454287B3cBB632Aa9f93bfB89E3fd18f;
address private constant aWETHtokenaddress = 0x27B4692C93959048833f40702b22FE3578E77759;
address private constant aWBTCtokenaddress = 0xc0ac343EA11A8D05AAC3c5186850A659dD40B81B;

IERC20 aLink = IERC20(aLinktokenAddress);
IERC20 aWETH = IERC20(aWETHtokenaddress);
IERC20 aWBTC = IERC20(aWBTCtokenaddress);


IFakeUniswap fakeuniswap = IFakeUniswap(0x461aCA84eA7f92532A3708Ce66E6C82e1C905939);

mapping (address => address) public LINKbalance;
mapping (address => address) public WETHbalance;
mapping (address => address) public WBTCbalance;

mapping (address => AaveforWETH) public WETHcontract;
mapping (address => AaveforWBTC) public WBTCcontract;
mapping (address => AaveforLINK) public LINKcontract;


//this line is for chainlink auotmation for redeem bond function. Buy link each bond id with an 
//arrays of addresses, we should be able to redeem all holders when it reaches maturity date 
//note that whenever this bonds is transfered to another user, the array needs to be updated 
mapping (uint => address[]) public bondidaddresses;



address [] public bonduseradddresses;




address public MainBankAddress;


constructor() CreateBondandAdminRole("") {
   
   
}

  



 function buybond (uint256 _id, uint256 amount, bytes calldata _data) external   {

       WBTC = new AaveforWBTC();
       WETH = new AaveforWETH();

        // refactored code for mainnet fork/production
       // require (msg.value == bondInfo[_id].bondUnitPrice* amount, "Incorrect amount for this bond");




       require(bondInfo[_id].availableUnits > 0, "There are no more bonds of this kind available");
 
        //mapping for chainlink automation
        bondidaddresses[_id].push(msg.sender);
     

         link.transfer(address(this), bondInfo[_id].bondUnitPrice *amount);


         WETHbalance[msg.sender] = address(WETH);
         WBTCbalance[msg.sender] = address(WBTC);
         WETHcontract[msg.sender] = WETH;
         WBTCcontract[msg.sender] = WBTC;



        //this line will transfer the funds to the fake uniswap to swap for WETH
        fakeuniswap.SwapLINKforWETH(bondInfo[_id].bondUnitPrice *amount/2);
        fakeuniswap.SwapLINKforWBTC(bondInfo[_id].bondUnitPrice * amount/2);


        //this line will transfer the bonds to the user 
        safeTransferFrom(address(this), msg.sender, _id, amount, _data);

        //this line will transfer the unds to their respective LP
        weth.transfer(WETHbalance[msg.sender],bondInfo[_id].bondUnitPrice/2 * amount);

        wbtc.transfer(WBTCbalance[msg.sender], bondInfo[_id].bondUnitPrice/2 * amount);

         WETHcontract[msg.sender].supplyLiquidity();

         WBTCcontract[msg.sender].supplyLiquidity();
       
        

      
    }


    //this code will have to be refactored if it is to be used for chainlink automation
     function redeemBond (uint id) external {
     require (bondInfo[id].bondStartDate >= bondInfo[id].bondMaturityDate,"This bond has not yet expired");
     require (balanceOf(msg.sender,id) > 0 , " You do not have any bonds of this kind");

     //this line will burn the bonds
     
     _burn(
        msg.sender,
        id,
        balanceOf(msg.sender, id)
    ); 

    //this line will withdraw the funds from the Aave Liquidity pools

    
    WBTCcontract[msg.sender].withdrawlLiquidity();
    WETHcontract[msg.sender].withdrawlLiquidity();

    //this line will complete the transfer to Link. Note in production: This will be the 
    //the native token of the selected network

    fakeuniswap.SwapWETHforLINK(weth.balanceOf(address(WETHbalance[msg.sender])));
    fakeuniswap.SwapWBTCforLINK(wbtc.balanceOf(address(WBTCbalance[msg.sender])));


    //this is how the investor gets paid 
    link.transfer(msg.sender, link.balanceOf((address(WETHbalance[msg.sender])))*90/100);
    link.transfer(msg.sender, link.balanceOf((address(WBTCbalance[msg.sender])))*90/100);

    //this is how the BondManager gets paid
    link.transfer(bondInfo[id].BondManager, link.balanceOf((address(WETHbalance[msg.sender])))*10/100);
    link.transfer(bondInfo[id].BondManager, link.balanceOf((address(WBTCbalance[msg.sender])))*10/100);
    

    }

    

   
}









