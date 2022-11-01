const { ethers, network, run } = require("hardhat")
const {
    VERIFICATION_BLOCK_CONFIRMATIONS,
    networkConfig,
    developmentChains,
} = require("../../helper-hardhat-config")

const LINK_TOKEN_ABI = require("@chainlink/contracts/abi/v0.4/LinkToken.json")

async function deployBondToken(chainId) {
    ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.ERROR)
    const accounts = await ethers.getSigners()
    const deployer = accounts[0]

    let linkToken
    let mockOracle
    let linkTokenAddress
    let oracleAddress

    if (chainId == 31337) {
        const linkTokenFactory = await ethers.getContractFactory("BondToken")
        linkToken = await linkTokenFactory.connect(deployer).deploy()
        linkTokenAddress = linkToken.address

        // const mockOracleFactory = await ethers.getContractFactory("MockOracle")
        // mockOracle = await mockOracleFactory.connect(deployer).deploy(linkToken.address)
        //oracleAddress = mockOracle.address
        
        
    } else {
        oracleAddress = networkConfig[chainId]["oracle"]
        linkTokenAddress = networkConfig[chainId]["linkToken"]
        linkToken = new ethers.Contract(linkTokenAddress, LINK_TOKEN_ABI, deployer)
    }



}

module.exports = {
    deployBondToken,
}
