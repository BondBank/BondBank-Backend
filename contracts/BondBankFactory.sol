// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

import "./BondERC1155.sol";
import "hardhat/console.sol";
//import "./bondAssetsAddr.sol";
contract BondBankFactory {

    uint256 nextBondId;
    uint256 previousBondId;
    uint256[] createdBondIds;
    mapping(uint256 => bondInfo) bondDetails;

   // bondAssetsAddr [] totalAssets;
    constructor(){
        
        nextBondId=1;
    }
    event bondCreated(address, uint16, string, string);

    struct bondInfo{
        uint256 bondId;
        string defiProtocolName;
        string bondDescription;
        bondParameter bondParams;

    }
    struct bondParameter {

         uint256 bondCreationDate ;
        uint256 bondStartDate;
        uint256 bondMaturityDate;     
        uint256 bondInterestRate;  
        uint256 bondMaxUnits;  
       // bondsAssets []bondAssetsAddr;

    }
    

    function createBond(bondInfo memory _bondInfo) public returns (uint256){
        //logic for bond creation;
       
        
        previousBondId = nextBondId;
        bondDetails[nextBondId] = 
        bondInfo(_bondInfo.bondId,
        _bondInfo.defiProtocolName,
        _bondInfo.bondDescription,
        _bondInfo.bondParams);
        createdBondIds.push(nextBondId);
        nextBondId = previousBondId+1;
        
        return previousBondId;
    }

    // function getBondDetails(uint256 bondId) external returns (bondParameter memory){
    //     return bondParams[bondId];
    // }
    function getAllBonds() public view {
        for(int i=0;i<createdBondIds.length;i++)
        {
            console.log(i);
            console.log('.');
            printBondDetails(createdBondIds[i]);
            console.log(' ');
        }
    }
    function printBondDetails(uint256 bondId) public view returns (uint256 ) {
        console.log(bondId);
        return bondId;
    }
    function getBondDescription(uint256 bondId) public view returns (string memory){
        return bondDetails[bondId].bondDescription;
    }
    function  initBonds()  external payable {
        
        createBond(bondInfo(0,"uniswap","testbond1", bondParameter(block.timestamp,
         block.timestamp+ 1 days, block.timestamp + 5 days, 9)));
        createBond(bondInfo(0,"uniswap","testbond2", bondParameter(block.timestamp,
         block.timestamp+ 2 days, block.timestamp + 15 days, 15)));
        createBond(bondInfo(0,"uniswap","testbond3", bondParameter(block.timestamp,
         block.timestamp, block.timestamp + 30 days, 20)));
        createBond(bondInfo(0,"uniswap","testbond4", bondParameter(block.timestamp,
         block.timestamp+ 5 days, block.timestamp + 90 days, 25)));
       

    }
    //[0,"uniswap","testbond2",[6,7,8,9]]
    //[0,"uniswap","testbond2",[6,7,8,9]]
    //[0,"uniswap","testbond2",[6,7,8,9]]

    
    
}

