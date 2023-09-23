// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./DADRequests.sol";
import "./DADDisputes.sol";
import "./DADPayments.sol";

contract DADSystem is Ownable {
    using SafeMath for uint256;

    DADRequests public requestsContract;
    DADDisputes public disputesContract;
    DADPayments public paymentsContract;

    constructor(
        address _requestsAddress,
        address _disputesAddress,
        address _paymentsAddress
    ) {
        requestsContract = DADRequests(_requestsAddress);
        disputesContract = DADDisputes(_disputesAddress);
        paymentsContract = DADPayments(_paymentsAddress);
    }

    function createRequest(
        string memory description,
        uint256 reward,
        uint256 expiryTime
    ) external payable {
        paymentsContract.pay{value: msg.value}();
        requestsContract.createDataRequest(description, reward, expiryTime);
    }

    function fulfillRequest(uint256 requestId) external {
        requestsContract.fulfillDataRequest(requestId);
    }

    function raiseDispute(uint256 requestId, string memory reason) external {
        disputesContract.raiseDispute(requestId, reason);
    }

    function resolveDispute(
        uint256 disputeId,
        bool inFavorOfRequester
    ) external onlyOwner {
        disputesContract.resolveDispute(disputeId, inFavorOfRequester);
    }

    function setPaymentFee(uint256 _fee) external onlyOwner {
        paymentsContract.setFee(_fee);
    }

    function withdrawFromSystem(uint256 amount) external {
        paymentsContract.withdraw(amount);
    }

    function adminWithdrawFromSystem() external onlyOwner {
        paymentsContract.adminWithdraw();
    }
}
