// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;



import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./Vault.sol";


contract CreateBondandAdminRole is ERC1155, ERC1155Holder, Vault {

     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

   

    
      bool DoesAdminExist;

     bool OneBondinCirculation;

     address payable[] public buyers;

    // JSON-like structure containing info on each bond
    struct Info {
        string bondName;
        uint256 bondStartDate;
        uint256 bondMaturityDate;
        //uint256 bondUnitPrice;
        address BondManager;
        //address Altcoinswap;
        address payable[] buyers;

    }

    // mapping of a bond to its information (of type Info above)
    mapping(uint256 => Info) public bondInfo;

    


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
          uri_ = "";
    }

  

    function createBond(
        string memory bondName,
        uint256 bondMaturityDate,
      
        //amount is not part of struct, just an input for the amount of bonds to buy
        uint256 amount

       
    ) external  {
        require (adminrole[msg.sender] == true, "You must be an admin to do this");
        require (OneBondinCirculation == false, "There can only be one bond at a time");


        bondInfo[currentBondId].bondName = bondName;
        bondInfo[currentBondId].bondStartDate = block.timestamp;
        bondInfo[currentBondId].bondMaturityDate = block.timestamp + bondMaturityDate;
      

        bondInfo[currentBondId].BondManager = msg.sender;

         OneBondinCirculation = true;      
       
        _mint(address(this), currentBondId, amount, "0x");
        userCreatedBonds[msg.sender].push(currentBondId);
        
    BondsinExistence.push(Info(bondName,
       block.timestamp,
         bondMaturityDate,
        
         msg.sender,
       
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
         
          
        );
    }


   

    //this function is to initialize the admin role. This will provide the devs with funds 
    function addADMINrole () external payable  {
       // require (msg.value == 0 ether, " please send .001 ether"); 
        require (DoesAdminExist == false, "Only one Admin is allowed to issue bonds");
    
        adminrole[msg.sender] = true;  
        DoesAdminExist = true;    
    }
    //returns Bonds created by a single user
    function getUserCreatedBonds(address addr) external view returns (uint[] memory){
       return userCreatedBonds[addr];
    }
    //returns all Bonds in existence
    function getAllBonds() external view returns (Info[] memory) {
       return BondsinExistence;
    }
    // returns true, if admin flag is set to calling address;else false
    function checkIfAddminRoleIsPresent () public view returns (bool) {
        if(adminrole[msg.sender] == true)
        {
            return true;
        }else{
            return false;
        }
        
    }


}