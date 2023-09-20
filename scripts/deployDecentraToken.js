const { ethers } = require("hardhat")

async function main() {
  const [deployer, recipient] = await ethers.getSigners()

  console.log("Deploying contracts with the account:", deployer.address)

  // Get contract factory
  const AdvancedTokenFactory = await ethers.getContractFactory("AdvancedToken")

  // Assuming the constructor expects an initial supply of 10000 tokens
  const initialSupply = ethers.parseUnits("10000", "wei")

  let advancedToken
  try {
    // Deploy the contract
    advancedToken = await AdvancedTokenFactory.deploy(initialSupply)
    if (
      !advancedToken.deployTransaction ||
      !advancedToken.deployTransaction.hash
    ) {
      console.error("Failed to deploy the AdvancedToken contract.")
      return
    }

    console.log(
      "Deployment transaction hash:",
      advancedToken.deployTransaction.hash,
    )

    await advancedToken.waitForDeployment()
    console.log("AdvancedToken deployed to:", advancedToken.address)

    // Transfer 100 tokens to the recipient
    const amountToSend = ethers.parseUnits("100", "wei")
    const transferTx = await advancedToken.transfer(
      recipient.address,
      amountToSend,
    )
    await transferTx.wait()
    console.log(`Successfully transferred 100 tokens to ${recipient.address}`)
  } catch (error) {
    console.error("Deployment Error:", error.message)
    return
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error.message)
    process.exit(1)
  })
