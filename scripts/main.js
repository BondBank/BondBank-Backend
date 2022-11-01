// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { network, run } = require("hardhat")

const { deployERC20 } = require("./deployERC20")
const { deployBondBankFactory } = require("./deployBondBankFactory")
const { deployBondERC1155 } = require("./deployBondERC1155")
const { deployBondToken } = require("./deployBondToken")


async function main() {
    await run("compile")
    const chainId = network.config.chainId

    await deployERC20(chainId)
    await deployBondBankFactory(chainId)
    await deployBondERC1155(chainId)
    await deployBondToken(chainId)
   
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
