// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

pragma abicoder v2;




//import "./AaveforLINK.sol";
//import "./AaveforWBTC.sol";
//import "./AaveforWETH.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract CreateBondandAdminRole is ERC1155, ERC1155Holder {

     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

   

     /*AaveforLINK public LINK;
     AaveforWBTC public WBTC;
     AaveforWETH public WETH;*/

     address[] public buyers;

    // JSON-like structure containing info on each bond
    struct Info {
        string bondName;
        uint256 bondStartDate;
        uint256 bondMaturityDate;
        //uint256 bondUnitPrice;
        address BondManager;
        address Altcoinswap;
        address[] buyers;

    }

    // mapping of a bond to its information (of type Info above)
    mapping(uint256 => Info) public bondInfo;

    


    //this address is for AaveLink. Note that this is different from regular Test LINK
     address public constant linkAddress =
        0x07C725d58437504CA5f814AE406e70E21C5e8e9e;
    //IERC20 public link;

    //this address is for AaveWETH. Note that this is different from regular Test WETH
     address private immutable wethAddress =
        0x2e3A2fb8473316A02b8A297B982498E661E1f6f5;
     //IERC20 public weth;

     //this address is for AaveWBTC. Note that this is different from regular test WBTC
     address private immutable wbtcAddress =
        0x8869DFd060c682675c2A8aE5B21F2cF738A0E3CE;
   // IERC20 public wbtc;




    uint256 currentBondId;
    address bondBankAddress;

    //this line is to create an array to keep track of the bonds
    Info[] public BondsinExistence;
    
    
    mapping (address => uint[]) public userCreatedBonds;

    //this is to create an ADMIN role 
    mapping (address => bool) public adminrole;

   
    

    event BondCreated(
        uint256 indexed bondId,
        string indexed bondName,
        uint256 bondStartDate,
        uint256 bondMaturityDate
       // uint256 bondUnitPrice
       
    );

    constructor(string memory uri_) ERC1155 ("") {
         // link = IERC20(linkAddress);
         // weth = IERC20(wethAddress);
         // wbtc = IERC20(wbtcAddress);
          uri_ = "";
    }

    //Contract is becoming too big. Should this function be here?
   /* function _beforeTokenTransfer(
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
    }*/

   
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
        uint256 bondMaturityDate,
        //uint256 bondUnitPrice,
        address Altcoin,
      
        //amount is not part of struct, just an input for the amount of bonds to buy
        uint256 amount

       
    ) external  {
        require (adminrole[msg.sender] == true, "You must be an admin to do this");


        bondInfo[currentBondId].bondName = bondName;
        bondInfo[currentBondId].bondStartDate = block.timestamp;
        bondInfo[currentBondId].bondMaturityDate = bondMaturityDate;
       // bondInfo[currentBondId].bondUnitPrice = bondUnitPrice;

        bondInfo[currentBondId].BondManager = msg.sender;

       
       
        _mint(address(this), currentBondId, amount, "0x");
        userCreatedBonds[msg.sender].push(currentBondId);
        
    BondsinExistence.push(Info(bondName,
       block.timestamp,
         bondMaturityDate,
        // bondUnitPrice,  
         msg.sender,
        Altcoin,
         buyers

    
    ));
        

        unchecked {
            currentBondId++;
        }
        emit BondCreated(
            currentBondId - 1,
            bondName,
            block.timestamp,
            bondMaturityDate
           // bondUnitPrice
          
        );
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
    function addADMINrole () external payable  {
       // require (msg.value == 0 ether, " please send .001 ether");     
        adminrole[msg.sender] = true;    
    }

    function getUserCreatedBonds(address addr) external view returns (uint[] memory){
       return userCreatedBonds[addr];
    }
    function getAllBonds() external returns (Info[] memory) {
       return BondsinExistence;
    }



}