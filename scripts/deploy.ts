import { ethers } from "hardhat";

async function main() {

  const NFTMarketplace = await ethers.deployContract("NFTMarketplace");

  await NFTMarketplace.waitForDeployment();

  console.log(
    `NFTMarketplace deployed to ${NFTMarketplace.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
