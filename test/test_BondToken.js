const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("test_utils", function () {
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
    
          expect(newBal.sub(bal)).to.equal(10);
        });
      });

      //today: oct/17 start date: oct 20 , 100 units
      // today> oct 19, 30units sold
      //so what happens on oct 20
});