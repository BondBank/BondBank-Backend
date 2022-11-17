// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract AaveforLINK {
    address public  MainBankContract;

    address public aLink = 0x6A639d29454287B3cBB632Aa9f93bfB89E3fd18f;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    address private immutable linkAddress =
        0x07C725d58437504CA5f814AE406e70E21C5e8e9e;
    IERC20 private link;

    constructor(address _addressProvider) payable {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
        MainBankContract = msg.sender;
        link = IERC20(linkAddress);
        approveLINK(); 
    }

    function supplyLiquidity() external {
        address asset = linkAddress;
        uint256 amount = link.balanceOf(address(this));
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        POOL.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdrawlLiquidity()
        external
        returns (uint256)
    {
        address asset = linkAddress;
        uint256 amount = IERC20(aLink).balanceOf(address(this));
        address to = address(this);

        return POOL.withdraw(asset, amount, to);
    }

   
   function approveLINK()
        internal
        returns (bool)
    {
        return link.approve(address(POOL), 115792089237316195423570985008687907853269984665640564039457584007913129);
    }


    function allowanceLINK(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return link.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function getBalanceandProfitLINK () external view returns (uint256){
        return IERC20(aLink).balanceOf(address(this));
    }


    //this function will have access control
    function withdraw(address _tokenAddress) external {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    //function prepared for production
    modifier OnlyMainBank() {
        require(
            msg.sender == MainBankContract,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
}
