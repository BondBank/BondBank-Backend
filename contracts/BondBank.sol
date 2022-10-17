// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

import "./BondToken.sol";
import "./ERC20.sol";

contract BondBank {
    address bondToken;
    mapping(address => bool) isSupportedToken;

    event BondBought(
        uint256 bondId,
        uint256 amountOfUnits,
        address tokenAddress,
        uint256 amountToPay
    );

    event BondSold(
        uint256 bondId,
        uint256 amountOfUnits,
        address tokenAddress,
        uint256 amountToPay
    );

    // uint256 nextBondId;
    // uint256 previousBondId;

    // mapping(uint256 => bondInfo) bondParams;

    // //bondsAssets[] totalAssets;

    // constructor() {}

    // struct bondInfo {
    //     uint256 bondId;
    //     string defiProtocolName;
    //     string bondDescription;
    //     bondParameter bondParams;
    // }
    // struct bondParameter {
    //     uint256 bondCreationDate;
    //     uint256 bondStartDate;
    //     uint256 bondMaturityDate;
    //     uint256 bondInterestRate;
    //     // bondsAssets []bondAssetsAddr;
    // }

    // mapping(address => bool) isApproved;

    // // function createBond(bondInfo _bondInfo) external returns (uint256  ) {
    // //     require(isApproved[_bondInfo]);
    // //     //logic for bond creation;

    // //     previousBondId = nextBondId;
    // //     nextBondId = previousBondId + 1;

    // //     return previousBondId;
    // // }

    // // function getBondDetails(uint256 bondId) external returns (bondParameter memory){
    // //     return bondParams[bondId];
    // // }

    // // function getAssets() external returns (bondsAssets[] memory) {
    // //     return totalAssets;
    // // }

    function sellBond(
        address tokenAddress,
        uint256 bondId,
        uint256 amountOfUnits
    ) external {
        require(isSupportedToken[tokenAddress], "Unsupported token");
        (, , , uint _maturityDate, uint _bondPrice, , ) = BondToken(bondToken)
            .getBond(bondId);
        require(block.timestamp >= _maturityDate, "not matured");
        uint amountToPay = amountOfUnits * _bondPrice;
        BondToken(bondToken).safeTransferFrom(
            msg.sender,
            address(this),
            bondId,
            amountOfUnits,
            "0x"
        );
        bool success = ERC20(tokenAddress).transfer(msg.sender, amountToPay);
        require(success, "transfer failed");
        emit BondSold(bondId, amountOfUnits, tokenAddress, amountToPay);
    }

    function buyBond(
        address tokenAddress,
        uint256 bondId,
        uint256 amountOfUnits
    ) external {
        require(isSupportedToken[tokenAddress], "Unsupported token");
        BondToken(bondToken).reduceUnits(bondId, amountOfUnits);
        (, , , , uint _bondPrice, , ) = BondToken(bondToken).getBond(bondId);
        uint amountToPay = amountOfUnits * _bondPrice;
        bool success = ERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amountToPay
        );
        require(success, "transfer failed");
        BondToken(bondToken).safeTransferFrom(
            address(this),
            msg.sender,
            bondId,
            amountOfUnits,
            "0x"
        );
        emit BondBought(bondId, amountOfUnits, tokenAddress, amountToPay);
    }
}
