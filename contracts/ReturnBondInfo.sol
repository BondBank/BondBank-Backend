// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

pragma abicoder v2;



import "./BondERC1155.sol";
import "./CreateBondandAdminRole.sol";
import "./AaveforLINK.sol";
import "./AaveforWBTC.sol";
import "./AaveforWETH.sol";
import "./BuyandRedeemBonds.sol";



contract ReturnBondInfo is BuyandRedeemBonds {



    //this function can be a candidate for Chainlink automation 
    function SeeProfit () public view returns (uint) {

        return (aWETH.balanceOf(WETHbalance[msg.sender]) + 
        aWBTC.balanceOf(WETHbalance[msg.sender]));
    }

    function getBond(uint256 bondId)
        external
        view
        returns (
            string memory bondName,
            uint256 bondCreationDate,
            uint256 bondStartDate,
            uint256 bondMaturityDate,
            uint256 bondUnitPrice,
            uint256 bondMaxUnit,
            uint256 availableUnits
        )
    {
        bondName = bondInfo[bondId].bondName;
        bondCreationDate = bondInfo[bondId].bondCreationDate;
        bondStartDate = bondInfo[bondId].bondStartDate;
        bondMaturityDate = bondInfo[bondId].bondMaturityDate;
        bondUnitPrice = bondInfo[bondId].bondUnitPrice;
        bondMaxUnit = bondInfo[bondId].bondMaxUnit;
        availableUnits = bondInfo[bondId].availableUnits;
    }


    function timeleftuntilredemption (uint id) external view returns (uint) {
        return bondInfo[id].bondMaturityDate - bondInfo[id].bondStartDate;

    }

    







}
