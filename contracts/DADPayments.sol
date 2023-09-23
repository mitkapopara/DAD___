// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DADPayments is Ownable {
    using SafeMath for uint256;

    uint256 public fee;
    mapping(address => uint256) public balances;

    event PaymentReceived(address indexed payer, uint256 amount);
    event Withdrawn(address indexed beneficiary, uint256 amount);

    constructor(uint256 _fee) {
        fee = _fee;
    }

    function setFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    // Typically, this would be called in conjunction with request creation or dispute raising.
    function pay() external payable {
        require(msg.value > fee, "Payment not covering the fees.");

        uint256 amountToStore = msg.value.sub(fee);
        balances[msg.sender] = balances[msg.sender].add(amountToStore);

        emit PaymentReceived(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance.");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    function adminWithdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner()).transfer(contractBalance);
    }
}
