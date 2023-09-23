const readline = require("readline")

class DADSystem {
  constructor() {
    this.requests = []
    this.disputes = []
    this.payments = {}
  }

  createRequest(user, description, reward, expiryTime) {
    const requestId = this.requests.length + 1
    const request = {
      id: requestId,
      user: user,
      description: description,
      reward: reward,
      expiryTime: expiryTime,
      status: "OPEN",
    }
    this.requests.push(request)
    this.payments[requestId] = 0
    return `Request created by ${user}: ${description}`
  }

  fulfillRequest(requestId, fulfiller) {
    const request = this.requests.find((r) => r.id === requestId)
    if (request && request.status === "OPEN") {
      request.status = "FULFILLED"
      request.fulfiller = fulfiller
      return `Request ${requestId} fulfilled by ${fulfiller}`
    } else {
      return `Unable to fulfill request ${requestId}`
    }
  }

  raiseDispute(requestId, reason) {
    const disputeId = this.disputes.length + 1
    const dispute = {
      id: disputeId,
      requestId: requestId,
      reason: reason,
      status: "RAISED",
    }
    this.disputes.push(dispute)
    return `Dispute raised for request ${requestId}: ${reason}`
  }

  resolveDispute(disputeId, decision) {
    const dispute = this.disputes.find((d) => d.id === disputeId)
    if (dispute && dispute.status === "RAISED") {
      dispute.status = "RESOLVED"
      dispute.decision = decision
      return `Dispute ${disputeId} resolved: ${decision}`
    } else {
      return `Unable to resolve dispute ${disputeId}`
    }
  }

  pay(requestId, amount) {
    this.payments[requestId] = this.payments[requestId] + amount
    return `Payment of ${amount} made for request ${requestId}`
  }
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
})

const system = new DADSystem()

function prompt() {
  rl.question(
    "\nChoose an action: (create/fulfill/raise/resolve/pay/exit) > ",
    (action) => {
      switch (action) {
        case "create":
          rl.question(
            "Enter user, description, reward, expiryTime: ",
            (input) => {
              const [user, description, reward, expiryTime] = input.split(",")
              console.log(
                system.createRequest(
                  user,
                  description,
                  parseFloat(reward),
                  expiryTime,
                ),
              )
              prompt()
            },
          )
          break
        case "fulfill":
          rl.question("Enter requestId, fulfiller: ", (input) => {
            const [requestId, fulfiller] = input.split(",")
            console.log(system.fulfillRequest(parseInt(requestId), fulfiller))
            prompt()
          })
          break
        case "raise":
          rl.question("Enter requestId, reason: ", (input) => {
            const [requestId, reason] = input.split(",")
            console.log(system.raiseDispute(parseInt(requestId), reason))
            prompt()
          })
          break
        case "resolve":
          rl.question("Enter disputeId, decision: ", (input) => {
            const [disputeId, decision] = input.split(",")
            console.log(system.resolveDispute(parseInt(disputeId), decision))
            prompt()
          })
          break
        case "pay":
          rl.question("Enter requestId, amount: ", (input) => {
            const [requestId, amount] = input.split(",")
            console.log(system.pay(parseInt(requestId), parseFloat(amount)))
            prompt()
          })
          break
        case "exit":
          rl.close()
          break
        default:
          console.log("Unknown action. Please choose again.")
          prompt()
      }
    },
  )
}

console.log("Welcome to DADSystem mockup!")
prompt()
