const hre = require("hardhat")
const ethers = hre.ethers

async function main() {
  const [deployer] = await ethers.getSigners()

  console.log("Deploying contracts with the account:", deployer.address)
  console.log(
    "Account balance:",
    (await ethers.provider.getBalance(deployer.address)).toString(),
  )

  // Deploy DADRoles
  const DADRoles = await ethers.getContractFactory("DADRoles")
  const dadRoles = await DADRoles.deploy()
  await dadRoles.waitForDeployment()
  console.log("DADRoles deployed to:", dadRoles.address)

  // Deploy DADRequests
  const DADRequests = await ethers.getContractFactory("DADRequests")
  const dadRequests = await DADRequests.deploy()
  await dadRequests.waitForDeployment()
  console.log("DADRequests deployed to:", dadRequests.address)

  // Deploy DADPayments
  const initialFee = ethers.parseEther("0.01") // Example fee of 0.01 ether
  const DADPayments = await ethers.getContractFactory("DADPayments")
  const dadPayments = await DADPayments.deploy(initialFee)
  await dadPayments.waitForDeployment()
  console.log("DADPayments deployed to:", dadPayments.address)

  // Deploy DADDisputes
  const DADDisputes = await ethers.getContractFactory("DADDisputes")
  const dadDisputes = await DADDisputes.deploy()
  await dadDisputes.waitForDeployment()
  console.log("DADDisputes deployed to:", dadDisputes.address)

  // Deploy DADSystem
  const DADSystem = await ethers.getContractFactory("DADSystem")
  const dadSystem = await DADSystem.deploy(
    dadRequests.address,
    dadDisputes.address,
    dadPayments.address,
  )
  await dadSystem.waitForDeployment()
  console.log("DADSystem deployed to:", dadSystem.address)

  console.log(`
        DADRoles Address: ${dadRoles.address}
        DADRequests Address: ${dadRequests.address}
        DADPayments Address: ${dadPayments.address}
        DADDisputes Address: ${dadDisputes.address}
        DADSystem Address: ${dadSystem.address}
    `)

  return {
    dadRoles: dadRoles.address,
    dadRequests: dadRequests.address,
    dadPayments: dadPayments.address,
    dadDisputes: dadDisputes.address,
    dadSystem: dadSystem.address,
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
