import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";

import { ERC20 } from "../typechain-types";

describe("My ERC20 Contract", () => {
  let contract: ERC20;
  let randomAddressOne: SignerWithAddress;
  let randomAddressTwo: SignerWithAddress;

  // deploy the contract before each test
  beforeEach(async () => {
    const contractFactory = await ethers.getContractFactory("ERC20");
    contract = await contractFactory.deploy("Hello", "MOS");

    await contract.deployed();

    // [randomAddress] = await ethers.getSigners();
    randomAddressOne = (await ethers.getSigners())[1];
    randomAddressTwo = (await ethers.getSigners())[2];
  });

  describe("When I have 10 tokens", () => {
    beforeEach(async () => {
      await contract.transfer(randomAddressOne.address, 10);
    });

    it("should have 10 tokens", async () => {
      expect(await contract.balanceOf(randomAddressOne.address)).to.equal(10);
    });

    describe("When I transfer 10 tokens to another address", () => {
      it("should transfer tokens correctly", async () => {
        await contract
          .connect(randomAddressOne)
          .transfer(randomAddressTwo.address, 10);

        expect(await contract.balanceOf(randomAddressOne.address)).to.equal(0);
        expect(await contract.balanceOf(randomAddressTwo.address)).to.equal(10);
      });
    });

    describe("When I transfer 11 tokens to another address", () => {
      it("should throw an error", async () => {
        await expect(
          contract
            .connect(randomAddressOne)
            .transfer(randomAddressTwo.address, 11)
        ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
      });

      it("should not transfer tokens", async () => {
        try {
          await contract
            .connect(randomAddressOne)
            .transfer(randomAddressTwo.address, 11);
        } catch (e) {
          expect(await contract.balanceOf(randomAddressOne.address)).to.equal(
            10
          );
          expect(await contract.balanceOf(randomAddressTwo.address)).to.equal(
            0
          );
        }
      });

      it("should revert the transaction", async () => {
        await expect(
          contract
            .connect(randomAddressOne)
            .transfer(randomAddressTwo.address, 11)
        ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
      });
    });
  });
});
