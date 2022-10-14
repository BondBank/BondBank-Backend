const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BondERC1155", function () {
  async function initializeContract() {
    const BondERC1155 = await ethers.getContractFactory("BondERC1155");
    const bondERC1155 = await BondERC1155.deploy("bondbank");

    return { bondERC1155 };
  }

  describe("Testout", function () {
    it("Testing...", async function () {
      const { bondERC1155 } = await loadFixture(initializeContract);

      await bondERC1155.initializeBond(0, "Bond Class A", 12);

      const bal = await bondERC1155.balanceOf(
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
        1
      );
      console.log(bal);
      expect(bal).to.equal(0);
    });
  });
});
