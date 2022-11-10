// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

pragma abicoder v2;



import "./BondERC1155.sol";
import "./AaveforLINK.sol";
import "./AaveforWBTC.sol";
import "./AaveforWETH.sol";


contract CreateBondandAdminRole is BondERC1155 {

   

     AaveforLINK public LINK;
     AaveforWBTC public WBTC;
     AaveforWETH public WETH;

    


    //this address is for AaveLink. Note that this is different from regular Test LINK
     address public immutable linkAddress =
        0x07C725d58437504CA5f814AE406e70E21C5e8e9e;
    IERC20 public link;

    //this address is for AaveWETH. Note that this is different from regular Test WETH
     address private immutable wethAddress =
        0x2e3A2fb8473316A02b8A297B982498E661E1f6f5;
     IERC20 public weth;

     //this address is for AaveWBTC. Note that this is different from regular test WBTC
     address private immutable wbtcAddress =
        0x8869DFd060c682675c2A8aE5B21F2cF738A0E3CE;
    IERC20 public wbtc;




    uint256 currentBondId;
    address bondBankAddress;
    
    

    //this is to create an ADMIN role 
    mapping (address => bool) public adminrole;

   
    

    event BondCreated(
        uint256 indexed bondId,
        string indexed bondName,
        uint256 bondCreationDate,
        uint256 bondStartDate,
        uint256 bondMaturityDate,
        uint256 bondUnitPrice,
        uint256 bondMaxUnit
    );

    constructor(string memory uri_) BondERC1155("") {
          link = IERC20(linkAddress);
          weth = IERC20(wethAddress);
          wbtc = IERC20(wbtcAddress);
          uri_ = "";
    }

    //Contract is becoming too big. Should this function be here?
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

   
    //@params account: address of account to burn from
    //@params id: index of token in the mapping
    //@params amount: amount of tokens to be burned from address
    //Joel: This function already exist in ERC1155 contract
   /* function burn(
        address from,
        uint256 id,
        uint256 amount
    ) external  {
        _burn(from, id, amount);
    }*/

    //@params account: address of account to mint to
    //@params ids: array of indexes of token in the mapping
    //@params amounts: array of amounts of tokens to be minted to address
    // ids and amounts is ran respectively so should be arranged as so
    //this function already exist in ERC1155 contract
    /*function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes calldata data
    ) external  {
        _mintBatch(to, ids, amounts, data);
    }*/

    //@params account: address of account 'from' burn from
    //@params ids: array of indexes of token in the mapping
    //@params amounts: array of amounts of tokens to be burned from address
    // ids and amounts is ran respectively so should be arranged as so
    //this function already exist in ERC1155 contract 
    /*
    function burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) external  {
        _burnBatch(from, ids, amounts);
    } */

    function createBond(
        string memory bondName,
        uint256 bondStartDate,
        uint256 bondMaturityDate,
        uint256 bondUnitPrice,
        uint256 bondMaxUnit,
        uint256 amount

        //these variables should not be needed as the contract will divide the investor funds equally
        //uint amounttoputinWBTC,
        //uint amounttoputinWETH
        //bond unit price should be equal to amounttputinWBTC + amounttoputinWETH
        
        
    ) external  {
        require (adminrole[msg.sender] == true, "You must be an admin to do this");


        bondInfo[currentBondId].bondName = bondName;
        bondInfo[currentBondId].bondCreationDate = block.timestamp;
        bondInfo[currentBondId].bondStartDate = bondStartDate;
        bondInfo[currentBondId].bondMaturityDate = bondMaturityDate;
        bondInfo[currentBondId].bondUnitPrice = bondUnitPrice;
        bondInfo[currentBondId].bondMaxUnit = bondMaxUnit;

    
        //bondInfo[currentBondId].amounttoputinWBTC = amounttoputinWBTC;
        //bondInfo[currentBondId].amounttoputinWETH = amounttoputinWETH;
        
        bondInfo[currentBondId].BondManager = msg.sender;
         
       
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

    function setBondBankAddress(address newBondBankAddress) external  {
        bondBankAddress = newBondBankAddress;
    }


    //Joel: not sure if we need this function
   /* function reduceUnits(uint256 bondId, uint256 reduceBy) external {
        require(msg.sender == bondBankAddress, "Not bond bank address");
        require(
            bondInfo[bondId].availableUnits >= reduceBy,
            "Not enough units to sell"
        );
        unchecked {
            bondInfo[bondId].availableUnits -= reduceBy;
        }
    }*/

   

    //this function is to initialize the admin role. This will provide the devs with funds 
    function addADMINrole () internal  {
        link.transfer(address(this), 0);
        adminrole[msg.sender] = true;    
    }
    // can remove adminrole for an address
    function removeADMINrole () external  {
         
        
        adminrole[msg.sender] = false;    
    }



}
