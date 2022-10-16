// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

import "./BondERC1155.sol";

contract BondBankFactory {

    uint256 nextBondId;
    uint256 previousBondId;
    mapping(uint256 => bondInfo) bondParams;
    bondsAssets [] totalAssets;
    constructor(){
        previousBondId =0;
        nextBondId=0;
    }

    struct bondInfo{
        uint256 bondId;
        string defiProtocolName;
        string bondDescription;
        bondParameter bondParams;

    }
    struct bondParameter{

        uint256 bondCreationDate;
        uint256 bondStartDate;
        uint256 bondMaturityDate;     
        uint256 bondInterestRate;  
       // bondsAssets []bondAssetsAddr;

    }
    struct bondsAssets {
        uint256 addrBTC;
        uint256 addrETH;
        uint256 addrATOM;
        uint256 addrAVAX;


    }

    function createBond(bondInfo _bondInfo) external returns (uint256 memory){
        //logic for bond creation;


        previousBondId = nextBondId;
        nextBondId = previousBondId+1;

        return previousBondId;
    }

    // function getBondDetails(uint256 bondId) external returns (bondParameter memory){
    //     return bondParams[bondId];
    // }

     function getAssets() external returns (bondsAssets[] memory){
        return totalAssets;
    }
    
}

