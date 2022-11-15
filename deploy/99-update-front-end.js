const { network, ethers } = require("hardhat");
const fs = require("fs-extra");
const path = require("path");

const frontEndDir = path.resolve(__dirname, "../constants");
const ADDRESSES_FILE = path.resolve(frontEndDir, "contractAddresses.json");
const BUY_AND_REDEEM_BONDS_ABI = path.resolve(
    frontEndDir,
    "buyAndRedeemBondsAbi.json"
);

module.exports = async () => {
    // From @levblanc: settings in .env file
    if (process.env.UPDATE_FRONT_END) {
        console.log(
            ">>>>>> Updating ABI & contract addresses for front end... "
        );

        const buyAndRedeemBonds = await ethers.getContract("BuyandRedeemBonds");

        await updateContractAddresses(buyAndRedeemBonds);
        await updateAbi(buyAndRedeemBonds, BUY_AND_REDEEM_BONDS_ABI);
    }
};

async function updateAbi(contract, abiFile) {
    if (!fs.existsSync(abiFile)) {
        fs.createFileSync(abiFile);
    }

    const contractInterface = contract.interface;
    const abiData = contractInterface.format(ethers.utils.FormatTypes.json);

    try {
        fs.writeFileSync(abiFile, abiData);
        console.log(">>>>>> Front end ABI updated!");
    } catch (error) {
        console.log(">>>>>> Front end ABI update failed!");
        console.error(error);
    }

    console.log("--------------------------------------------------");
}

async function updateContractAddresses(contract) {
    let addressData = JSON.stringify({});

    if (!fs.existsSync(ADDRESSES_FILE)) {
        fs.createFileSync(ADDRESSES_FILE);
    } else {
        addressData = fs.readFileSync(ADDRESSES_FILE, {
            encoding: "utf-8"
        });
    }

    const addressRecords = JSON.parse(addressData);
    const contractAddress = contract.address;
    const chainId = network.config.chainId.toString();

    // the address file will keep a record of all addresses deployed
    // the latest one will be on top of the array
    // so getting the 0 index item from array will give you the latest deployed address
    if (chainId in addressRecords) {
        if (!addressRecords[chainId].includes(contractAddress)) {
            addressRecords[chainId].unshift(contractAddress);
        }
    } else {
        addressRecords[chainId] = [contractAddress];
    }

    try {
        fs.writeFileSync(
            ADDRESSES_FILE,
            JSON.stringify(addressRecords, null, 2)
        );

        console.log(">>>>>> Front end addresses updated!");
    } catch (error) {
        console.log(">>>>>> Front end addresses update failed!");
        console.error(error);
    }

    console.log("--------------------------------------------------");
}

module.exports.tags = ["all", "frontend"];
