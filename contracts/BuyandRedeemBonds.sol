// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.1;

import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";
import "./CreateBondandAdminRole.sol";
// import "./SimpleSwap.sol";
import "./WETHgateway.sol";

contract BuyandRedeemBonds is
    CreateBondandAdminRole,
    WETHgateway,
    AutomationCompatibleInterface
{
    //these addresses contain both principal and the profit for each pool
    address private constant aWETHtokenaddress =
        0x27B4692C93959048833f40702b22FE3578E77759;

    //SimpleSwap public Swap;
    WETHgateway public Gateway;

    mapping(address => address) public WETHgatewayAddr;
    mapping(address => WETHgateway) public WETHgatewaycontract;
    mapping(address => address) public Swapaddress;
    // mapping(address => SimpleSwap) public Swapcontract;
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

        this.depostitETH{value: .0008 ether}();
        payable(bondInfo[id].BondManager).transfer(.0002 ether);

        //this line will transfer the bonds to the user
        _safeTransferFrom(address(this), msg.sender, id, 1, " ");

        OnlyoneBond[msg.sender] = true;

        //added to track bonds by buyers, donot remove
        bondsByBuyersAddr[msg.sender].push(id);
        emit BondBought(id, "bondName", 1, block.timestamp);
    }

     function collectfunds() public {

         for (uint id = 0; id <= BondsinExistence[id].buyers.length; id++) {
             if (block.timestamp > bondInfo[id].bondMaturityDate) {

                     this.WithdrawETH(type(uint256).max);

             }

         }

    }

   
      function Bondredemption(uint id) external {
        uint256 totAmount = 0;

                payable(msg.sender).transfer(
                    address(this).balance / bondInfo[id].buyers.length
                   
                );

               /* _burn(
                    msg.sender,
                    id,
                    1
                );*/

                adminrole[bondInfo[id].BondManager] = false;
            
        

        totAmount = address(this).balance;
        DoesAdminExist = false;
        

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
}
