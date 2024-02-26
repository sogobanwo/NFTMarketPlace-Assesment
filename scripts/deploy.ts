import { ethers } from "hardhat";

async function main() {

  const contractName = await ethers.deployContract("ContactName", ["contructorValues"]);

  await contractName.waitForDeployment();

  console.log(
    `contractName deployed to ${contractName.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
