const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const verify = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const isLocalNetwork = developmentChains.includes(network.name);
    const waitConfirmations = network.config.blockConfirmations || 1;

    log("-----------------------------------------");

    const args = [];
    const buyAndRedeemBonds = await deploy("BuyandRedeemBonds", {
        from: deployer,
        args,
        log: true,
        waitConfirmations
    });

    if (!isLocalNetwork && process.env.ETHERSCAN_API_KEY) {
        await verify(buyAndRedeemBonds.address, args);
    }

    log("-----------------------------------------");
};

// tags can help to deploy specific contract
module.exports.tags = ["all", "buyAndRedeemBonds"];
