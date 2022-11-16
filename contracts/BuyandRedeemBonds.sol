// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";
import "./CreateBondandAdminRole.sol";
import "./WETHgateway.sol";
import "./Vault.sol";

contract BuyandRedeemBonds is
    Vault,
    CreateBondandAdminRole,
   WETHgateway,
    AutomationCompatibleInterface
{
    //these addresses contain both principal and the profit for each pool
    address private constant aWETHtokenaddress =
        0x27B4692C93959048833f40702b22FE3578E77759;

   
  
    mapping(address => uint[]) internal bondsByBuyersAddr;

    event BondBought(
        uint256 indexed bondId,
        string indexed bondName,
        uint256 indexed bondAmount,
        uint256 bondBuyTime
    );

    event BondRedeemed(
        uint256 indexed bondId,
        string indexed bondName,
        uint256 indexed bondAmount,
        uint256 bondRedeemTime
    );

    address public Pooladdress = 0x368EedF3f56ad10b9bC57eed4Dac65B26Bb667f6;
    mapping(address => bool) public OnlyoneBond;

    uint public immutable interval = 15 * 60 * 60; // 15 mins, in seconds
    uint public lastTimeStamp;

    constructor() CreateBondandAdminRole("") {
        lastTimeStamp = block.timestamp;
    }

    //returns bonds bought by a user
    function getbondsByBuyersAddr(
        address addr
    ) external view returns (uint[] memory) {
        return bondsByBuyersAddr[addr];
    }

    function buybond(uint id) external payable {
        require(msg.value == .001 ether, "Incorrect amount for this bond");
        require(
            OnlyoneBond[msg.sender] == false,
            "You can only purchase one bond"
        );

        BondsinExistence[id].buyers.push(payable(msg.sender));
        bondInfo[id].buyers.push(payable(msg.sender));

        depositETH();
        payable(bondInfo[id].BondManager).transfer(.0001 ether);

        //this line will transfer the bonds to the user
        _safeTransferFrom(address(this), msg.sender, id, 1, " ");

        //this line will initate the deposit 
        deposit();

        //mapping to make sure that the msg.sender has one bond
        OnlyoneBond[msg.sender] = true;

        //added to track bonds by buyers, donot remove
        bondsByBuyersAddr[msg.sender].push(id);
        emit BondBought(id, "bondName", 1, block.timestamp);
    }


    //function for automation
     function collectfunds() public {

          for (uint id = 0; id <= 20; id++) {
            if (block.timestamp > bondInfo[id].bondMaturityDate){
                    WithdrawETH(type(uint256).max);
                    break;

            }
    }
     }
    
         

    

   
      function Bondredemption(uint id) external {
        uint256 totAmount = 0;
        require( OnlyoneBond[msg.sender]  == true, " you do not have any bonds");
       require (block.timestamp > bondInfo[id].bondMaturityDate, "this bond has not matured yet");

            //function to withdraw funds
              withdraw();

            //function to burn bonds
                _burn(
                    msg.sender,
                    id,
                    1
                );

                adminrole[bondInfo[id].BondManager] = false;
                OnlyoneBond[msg.sender]  == false;
            
        
        
        totAmount = address(this).balance;
        DoesAdminExist = false;
       OneBondinCirculation = false;
        
        

        emit BondBought(id, bondInfo[id].bondName, totAmount, block.timestamp);
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        if ((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
           collectfunds();
        }
    }

    function returnbuyers(
        uint id
    ) external view returns (address payable[] memory) {
        return BondsinExistence[id].buyers;
    }

        //function to calculate shares
        function deposit() public virtual payable override  {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint shares;
        if (totalSupply == 0) {
            shares = 1;
              mintshares(msg.sender, shares);
        } else {
            shares = (1 * totalSupply) / address(this).balance;
              mintshares(msg.sender, shares);
        }

      
      
    }

    //function to calculate how much to withdraw
     function withdraw() public override  {
        /*
        a = amount
        B = balance of token before withdraw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = sB / T
        */

        uint amount = (1 * address(this).balance) / totalSupply;
        burnshares(msg.sender, 1);
        payable(msg.sender).transfer( amount);
    }


    //function to see balance and see if automation is working 
    function returnbalance () external view returns (uint){

        return IERC20(aWETH).balanceOf(address(this));

    }





}