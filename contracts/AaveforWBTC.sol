// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract AaveforWBTC {

    //In the hackathon, only the Main Bank contract should be able to interact with this contract 
    address public MainBankContract;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    address public aWBTC = 0xc0ac343EA11A8D05AAC3c5186850A659dD40B81B;

    address private immutable wbtcAddress =
        0x8869DFd060c682675c2A8aE5B21F2cF738A0E3CE;
    IERC20 private wbtc;

    constructor(address _addressProvider) payable {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
        wbtc = IERC20(wbtcAddress);
        MainBankContract = msg.sender;
        approveWBTC();
    }

    function supplyLiquidity() external {
        address asset = wbtcAddress;
        uint256 amount = wbtc.balanceOf(address(this));
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

       

        POOL.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdrawlLiquidity()
        external
        returns (uint256)
    {
        address asset = wbtcAddress;
        uint256 amount = IERC20(aWBTC).balanceOf(address(this));
        address to = address(this);

        return POOL.withdraw(asset, amount, to);
    }


    //changed pool contract address to address(pool)
    function approveWBTC()
        internal
        returns (bool)
    {
        return wbtc.approve(address(POOL), 115792089237316195423570985008687907853269984665640564039457584007913129);
    }

    function allowanceWBTC(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return wbtc.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function getBalanceandProfitWBTC () external view returns (uint256){
        return IERC20(aWBTC).balanceOf(address(this));
    }

    //this function will have access control
    function withdraw(address _tokenAddress) external {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }


    //this function will be used during production 
    modifier OnlyMainBank () {
        require (msg.sender == MainBankContract, "Only the Main Bank Contract is authorized");
        _;
    }

   

    receive() external payable {}
}
