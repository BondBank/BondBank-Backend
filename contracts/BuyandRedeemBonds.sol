// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;
pragma abicoder v2;

import "./CreateBondandAdminRole.sol";
import "https://github.com/aave/aave-v3-periphery/blob/7a9542963b8030885443800179c57ff8ffdac29c/contracts/misc/interfaces/IWETHGateway.sol";
import "./SimpleSwap.sol";
import "./WETHgateway.sol";

contract BuyandRedeemBonds is CreateBondandAdminRole, WETHgateway {
    //these addresses contain both principal and the profit for each pool 
    address private constant aWETHtokenaddress = 0x27B4692C93959048833f40702b22FE3578E77759;

    SimpleSwap public Swap;
    WETHgateway public Gateway;

    mapping (address => address) public WETHgatewayAddr;
    mapping (address => WETHgateway) public WETHgatewaycontract;
    mapping (address => address) public Swapaddress;
    mapping (address => SimpleSwap) public Swapcontract;
    mapping (address => uint[]) internal bondsByBuyersAddr;

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

    constructor() CreateBondandAdminRole("") {}

    //returns bonds bought by a user
    function getbondsByBuyersAddr(address addr) external view returns (uint[] memory){  
        return bondsByBuyersAddr[addr];
    }  

    function buybond (uint id) external payable  {
        require (msg.value == .001 ether, "Incorrect amount for this bond");
        require (OnlyoneBond[msg.sender] == false, "You can only purchase one bond");

        BondsinExistence[id].buyers.push(payable(msg.sender));
        bondInfo[id].buyers.push(payable(msg.sender));
             
        this.depostitETH{value: .0008 ether}();
        payable (bondInfo[id].BondManager).transfer(.0002 ether);

        //this line will transfer the bonds to the user 
        _safeTransferFrom(address(this), msg.sender, id, 1, " ");

        OnlyoneBond[msg.sender] = true;       
           
        //added to track bonds by buyers, donot remove
        bondsByBuyersAddr[msg.sender].push(id);
        emit BondBought(
            id,
            "bondName",
            1,
            block.timestamp
        );
    }

    function Bondredemption () external {
        uint256 totAmount = 0;
        uint id;

        for ( id = 0 ; id <= bondInfo[id].buyers.length; id++){
            if (block.timestamp >= bondInfo[id].bondMaturityDate){
                //logic for redemption
                this.WithdrawETH(type(uint256).max);
                
                payable (bondInfo[id].buyers[id]).transfer(address(this).balance/bondInfo[id].buyers.length);

                _burn(bondInfo[id].buyers[id], id, balanceOf(bondInfo[id].buyers[id], id)); 

                adminrole[bondInfo[id].BondManager] = false;
            }
        }

        totAmount=  address(this).balance;
        DoesAdminExist = false; 
        numberofBondsinCirculation--;
       
        emit BondBought(
            id,
            bondInfo[id].bondName,
             totAmount,
            block.timestamp
        ); 
     }

    //     totAmount = address(this).balance;
    //     DoesAdminExist = false; 
    //     adminrole[bondInfo[id].BondManager] = false;
    //     emit BondBought(
    //         id,
    //         bondInfo[id].bondName,
    //         totAmount,
    //         block.timestamp
    //     ); 
    // }

     function returnbuyers (uint id) external view returns (address payable [] memory){
        return BondsinExistence[id].buyers;
      }
}