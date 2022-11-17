// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract AaveforWETH {
    address public MainBankContract;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    address private immutable wethAddress =
        0x2e3A2fb8473316A02b8A297B982498E661E1f6f5;

    address public aWETH = 0x27B4692C93959048833f40702b22FE3578E77759;


    IERC20 private weth;

    constructor(address _addressProvider) payable {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESSES_PROVIDER.getPool());
        MainBankContract = payable(msg.sender);
        weth = IERC20(wethAddress);
        approveWETH();
    }

    function supplyLiquidity() external {
        address asset = wethAddress;
        uint256 amount = weth.balanceOf(address(this));
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        POOL.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdrawlLiquidity()
        external
        returns (uint256)
    {
        address asset = wethAddress;
        uint256 amount = IERC20(aWETH).balanceOf(address(this));
        address to = address(this);

        return POOL.withdraw(asset, amount, to);
    }


   function approveWETH()  internal returns (bool)
    {
        return weth.approve(address(POOL), 115792089237316195423570985008687907853269984665640564039457584007913129);
    }

    function allowanceWETH(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return weth.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function getBalanceandProfitWETH () external view returns (uint256){
        return IERC20(aWETH).balanceOf(address(this));
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
