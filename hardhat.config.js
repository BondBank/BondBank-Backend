require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
// require('@nomiclabs/hardhat-waffle');
require("solidity-coverage");
require("hardhat-contract-sizer");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-solhint");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
// require('@nomiclabs/hardhat-etherscan');

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts

// FROM @levblanc
// All three keys set in .env file, see .env.example
// .env file should be kept in your local and NEVER push to Github
// everyone should have their own .env file
const { ETHERSCAN_API_KEY, GOERLI_RPC_URL, PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        compilers: [
            {
                version: "0.8.10",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 1000000
                    }
                }
            }
        ]
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1
        },
        localhost: {
            chainId: 31337,
            blockConfirmations: 1,
            url: "http://127.0.0.1:8545"
        },
        // mumbai: {
        //     url: "https://rpc.ankr.com/polygon_mumbai",
        //     chainId: 80001,
        //     accounts: [process.env.PRIVATE_KEY1, process.env.PRIVATE_KEY2]
        // },
        goerli: {
            chainId: 5,
            blockConfirmations: 6,
            url: GOERLI_RPC_URL,
            accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : []
            // FROM @levblanc: Put this into .env file, see .env.example
            // url:
            //   'https://eth-goerli.g.alchemy.com/v2/96b-b2u2vjIAiGGs4wX7n8Ac395pwsr4',
        }
    },
    namedAccounts: {
        deployer: {
            default: 0
        }
    },
    etherscan: {
        // FROM @levblanc: Put this into .env file, see .env.example
        // apiKey: 'G2NTBE18UF2M446DS5VV9AEFFSCXIKNV65',
        apiKey: ETHERSCAN_API_KEY,
        // FROM @levblanc: This config is for those who have a hard time on
        // getting thru Etherscan's HTTPS API URL
        customChains: [
            {
                network: "goerli",
                chainId: 5,
                urls: {
                    apiURL: "http://api-goerli.etherscan.io/api",
                    browserURL: "https://goerli.etherscan.io"
                }
            }
        ]
    },
    contractSizer: {
        alphaSort: false,
        disambiguatePaths: false,
        runOnCompile: false,
        strict: true
    },
    gasReporter: {
        enabled: true,
        currency: "USD",
        outputFile: "gas-report.txt",
        coinmarketcap: process.env.COINMARKETCAP_APIKEY,
        token: "MATIC",
        gasPriceApi: `https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice&apiKey=${process.env.POLYGONSCAN_APIKEY}`
    }
    // mocha: {
    //   timeout: 100000000,
    // },
};
