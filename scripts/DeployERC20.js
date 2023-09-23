const hre = require("hardhat")

async function main() {
  const [deployer] = await hre.ethers.getSigners()

  console.log("Deploying contracts with the account:", deployer.address)

  const BasicERC20 = await hre.ethers.getContractFactory("BasicERC20")
  const basicToken = await BasicERC20.deploy("1000000") // Deploying with 1 million tokens

  await basicToken.waitForDeployment()

  console.log("Basic Token deployed to:", basicToken.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
