require("@nomiclabs/hardhat-waffle")
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");




// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts


module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.10",
        settings: {
          evmVersion: "istanbul",
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
  },
  networks: {
    goerli: {
     
        url: "https://eth-goerli.g.alchemy.com/v2/96b-b2u2vjIAiGGs4wX7n8Ac395pwsr4",
      
    }
    },

  etherscan: {
    apiKey: "G2NTBE18UF2M446DS5VV9AEFFSCXIKNV65",
  },
};
  // mocha: {
  //   timeout: 100000000,
  // },
