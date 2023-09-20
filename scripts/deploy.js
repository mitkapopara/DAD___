// imports
const { ethers, run, network, provider } = require("hardhat")


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// async function
async function main() {
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract...")
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.waitForDeployment()
  const contractAddress = await simpleStorage.getAddress()
  console.log(`Deployed contract to: ${contractAddress}`)

  if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for a few seconds to ensure contract bytecode propagation...");
    await sleep(60000); // Wait for 60 seconds
    await verify(contractAddress, constructorArgs =[])
  }

  const currentValue = await simpleStorage.retrieve()
  console.log(`Current Value is : ${currentValue}`)

  // update the current value
  const transactionResponse = await simpleStorage.store(7)
  await transactionResponse.wait(1)
  const updatedValue = await simpleStorage.retrieve()
  console.log(`Updated value is: ${updatedValue}`)
}


// async function to verify contract
async function verify(contractAddress, []) {
    console.log("Verifying contract...");
    try {
      await run("verify:verify", {
        address: contractAddress,
        constructorArguments: [],
      });
    } catch (e) {
      if (e.message.toLowerCase().includes("already verified")) {
        console.log("Already verified");
      } else {
        console.log(e);
      }
    }
  }


// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });