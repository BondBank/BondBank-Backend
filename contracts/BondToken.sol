// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

import "./BondERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BondToken is Ownable, BondERC1155 {
    uint256 currentBondId;
    address bondBankAddress;

    event BondCreated(
        uint256 indexed bondId,
        string indexed bondName,
        uint256 bondCreationDate,
        uint256 bondStartDate,
        uint256 bondMaturityDate,
        uint256 bondUnitPrice,
        uint256 bondMaxUnit,
        address UniswapBond;

    );

    constructor(string memory uri_) BondERC1155(uri_) {}

    function _beforeTokenTransfer(
        address,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory
    ) internal virtual override {
        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                require(
                    bondInfo[ids[i]].bondCreationDate > 0,
                    "Bond not created"
                );
                bondInfo[ids[i]].bondMaxUnit += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = bondInfo[id].bondMaxUnit;
                require(
                    supply >= amount,
                    "ERC1155: burn amount exceeds totalSupply"
                );
                unchecked {
                    bondInfo[id].bondMaxUnit = supply - amount;
                }
            }
        }
    }

    //@params id: index of token in the mapping
    //@params amount: amount of tokens to be minted to address
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external onlyOwner {
        _mint(to, id, amount, data);
    }

    //@params account: address of account to burn from
    //@params id: index of token in the mapping
    //@params amount: amount of tokens to be burned from address
    function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external onlyOwner {
        _burn(from, id, amount);
    }

    //@params account: address of account to mint to
    //@params ids: array of indexes of token in the mapping
    //@params amounts: array of amounts of tokens to be minted to address
    // ids and amounts is ran respectively so should be arranged as so
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes calldata data
    ) external onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    //@params account: address of account 'from' burn from
    //@params ids: array of indexes of token in the mapping
    //@params amounts: array of amounts of tokens to be burned from address
    // ids and amounts is ran respectively so should be arranged as so
    function burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external onlyOwner {
        _burnBatch(from, ids, amounts);
    }

    function createBond(
        string memory bondName,
        uint256 bondStartDate,
        uint256 bondMaturityDate,
        uint256 bondUnitPrice,
        uint256 bondMaxUnit,
        uint256 amount
    ) external onlyOwner {
        bondInfo[currentBondId].bondName = bondName;
        bondInfo[currentBondId].bondCreationDate = block.timestamp;
        bondInfo[currentBondId].bondStartDate = bondStartDate;
        bondInfo[currentBondId].bondMaturityDate = bondMaturityDate;
        bondInfo[currentBondId].bondUnitPrice = bondUnitPrice;
        bondInfo[currentBondId].bondMaxUnit = bondMaxUnit;
        _mint(bondBankAddress, currentBondId, amount, "0x");
        unchecked {
            currentBondId++;
        }
        emit BondCreated(
            currentBondId - 1,
            bondName,
            block.timestamp,
            bondStartDate,
            bondMaturityDate,
            bondUnitPrice,
            bondMaxUnit
        );
    }

    function setBondBankAddress(address newBondBankAddress) external onlyOwner {
        bondBankAddress = newBondBankAddress;
    }

    function reduceUnits(uint256 bondId, uint256 reduceBy) external {
        require(msg.sender == bondBankAddress, "Not bond bank address");
        require(
            bondInfo[bondId].availableUnits >= reduceBy,
            "Not enough units to sell"
        );
        unchecked {
            bondInfo[bondId].availableUnits -= reduceBy;
        }
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
}
