// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

import "./BondERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BondToken is Ownable, BondERC1155 {
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
                bondInfo[ids[i]].totalSupply += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = bondInfo[id].totalSupply;
                require(
                    supply >= amount,
                    "ERC1155: burn amount exceeds totalSupply"
                );
                unchecked {
                    bondInfo[id].totalSupply = supply - amount;
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
    //@params ids: arrat of indexes of token in the mapping
    //@params amounts: array of amounts of tokens to be minted to address
    // ids and amounts is ran respectively so should be arranged as so
    function mintBatchAsset(
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
    function burnBatchAsset(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external onlyOwner {
        _burnBatch(from, ids, amounts);
    }
}
