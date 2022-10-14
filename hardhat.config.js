require("@nomicfoundation/hardhat-toolbox");
require("solidity-coverage");
require("hardhat-contract-sizer");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-solhint");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000000,
      },
    },
  },
  networks: {
    hardhat: {
      // forking: {
      //   url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_PROVIDER}`, //"https://rpc.ankr.com/polygon"
      // },
      loggingEnabled: false,
    },

    mumbai: {
      url: "https://rpc.ankr.com/polygon_mumbai",
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY1, process.env.PRIVATE_KEY2],
    },
  },

  contractSizer: {
    alphaSort: false,
    disambiguatePaths: false,
    runOnCompile: false,
    strict: true,
  },

  gasReporter: {
    enabled: true,
    currency: "USD",
    coinmarketcap: process.env.COINMARKETCAP_APIKEY,
    token: "MATIC",
    gasPriceApi: `https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice&apiKey=${process.env.POLYGONSCAN_APIKEY}`,
  },
};