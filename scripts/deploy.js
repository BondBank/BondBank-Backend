async function main() {
  //const [deployer] = await ethers.getSigners();

//  console.log("Deploying contracts with the account:", deployer.address);

 // console.log("Account balance:", (await deployer.getBalance()).toString());

  const BuyandRedeemBonds = await ethers.getContractFactory("BuyandRedeemBonds");
  const buyandredeemBonds = await BuyandRedeemBonds.deploy();

  console.log("Uniswap address:", BuyandRedeemBonds.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
