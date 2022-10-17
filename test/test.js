const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { x } = require("../abi.js");

describe("BondERC1155", function () {
  async function initializeContract() {
    const BondToken = await ethers.getContractFactory("BondToken");
    const bondToken = await BondToken.deploy("bondtoken");

    return { bondToken };
  }

  describe("Testout", function () {
    it("Testing...", async function () {
      const { bondToken } = await loadFixture(initializeContract);

      await bondToken.initializeBond(0, "Bond Class A", 12);

      const bal = await bondToken.balanceOf(
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        0
      );
      console.log(bal);

      await bondToken.mint(
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        0,
        10,
        "0x"
      );
      const newBal = await bondToken.balanceOf(
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        0
      );
      console.log(newBal);

      const contractInterface = new ethers.utils.Interface(x);
      let data = contractInterface.encodeFunctionData("inc", [3]);
      console.log(data);

      expect(newBal.sub(bal)).to.equal(10);
    });
  });
});
