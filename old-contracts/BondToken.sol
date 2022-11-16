// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)



//contract will be removed soon

pragma solidity ^0.8.1;

pragma abicoder v2;



import "./BondERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AaveforLINK.sol";
import "./AaveforWBTC.sol";
import "./AaveforWETH.sol";


contract BondToken is Ownable, BondERC1155 {

     address public constant Aavepooladdress = 0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D;
     AaveforWBTC public WBTC;
     AaveforWETH public WETH;


    //this address is for AaveLink. Note that this is different from regular Test LINK
     address private immutable linkAddress =
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
    }

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
        uint256 amount,
        uint amounttoputinWBTC,
        uint amounttoputinWETH
        


    ) external onlyOwner {
        require (adminrole[msg.sender] == true, "You must be an admin to do this");
      



        bondInfo[currentBondId].bondName = bondName;
        bondInfo[currentBondId].bondCreationDate = block.timestamp;
        bondInfo[currentBondId].bondStartDate = bondStartDate;
        bondInfo[currentBondId].bondMaturityDate = bondMaturityDate;
        bondInfo[currentBondId].bondUnitPrice = bondUnitPrice;
        bondInfo[currentBondId].bondMaxUnit = bondMaxUnit;
        bondInfo[currentBondId].amounttoputinWBTC = amounttoputinWBTC;
        bondInfo[currentBondId].amounttoputinWETH = amounttoputinWETH;
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

    //suggestion: make a new contract just for get/return functions 
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

    //this function is to initialize the admin role 
    function addADMINrole () external {
        link.transfer(address(this), 100);
        adminrole[msg.sender] = true;    
    }


    function buybond (uint256 _id, uint256 amount, bytes calldata _data) external {

        // refactored code for mainnet fork/production
       // require (msg.value == bondInfo[_id].bondUnitPrice, "Incorrect amount for this bond");

       require(bondInfo[_id].availableUnits > 0, "There are no more bonds of this kind available");

        //this line allows the user to buy the bond with LINK. In production, this will be ETH
        link.transfer(address(this), bondInfo[_id].bondUnitPrice);


        safeTransferFrom(address(this), msg.sender, _id, amount, _data);

        weth.transfer(address(WETH),bondInfo[_id].amounttoputinWETH);
        //this line will generate a profit for the bond manager
        weth.transfer(bondInfo[_id].BondManager,(bondInfo[_id].amounttoputinWETH)/10);

        wbtc.transfer(address(WBTC),bondInfo[_id].amounttoputinWBTC);
        //this line will generate a profit for the bond manager
        wbtc.transfer(bondInfo[_id].BondManager,(bondInfo[_id].amounttoputinWBTC)/10);   

    }

    function redeemBond (uint id, uint amount) external {
     require (bondInfo[id].bondStartDate >= bondInfo[id].bondMaturityDate, "This bond has not yet expired" );
    //code for staking logic and redemption 
    

    }

    






}