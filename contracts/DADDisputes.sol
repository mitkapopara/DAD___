// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract DADDisputes {
    enum DisputeStatus {
        NotRaised,
        Raised,
        Resolved
    }

    struct Dispute {
        uint256 requestId;
        address raiser;
        string reason;
        DisputeStatus status;
    }

    mapping(uint256 => Dispute) public disputes;

    event DisputeRaised(uint256 disputeId, uint256 requestId, string reason);
    event DisputeResolved(uint256 disputeId, bool inFavorOfRequester);

    function raiseDispute(
        uint256 requestId,
        string memory reason
    ) external returns (uint256) {
        require(bytes(reason).length > 0, "Reason cannot be empty");

        uint256 disputeId = uint256(
            keccak256(abi.encodePacked(requestId, msg.sender, block.timestamp))
        );

        Dispute memory newDispute = Dispute({
            requestId: requestId,
            raiser: msg.sender,
            reason: reason,
            status: DisputeStatus.Raised
        });

        disputes[disputeId] = newDispute;

        emit DisputeRaised(disputeId, requestId, reason);

        return disputeId;
    }

    function resolveDispute(
        uint256 disputeId,
        bool inFavorOfRequester
    ) external {
        require(
            disputes[disputeId].status == DisputeStatus.Raised,
            "Dispute not found or already resolved"
        );

        disputes[disputeId].status = DisputeStatus.Resolved;

        emit DisputeResolved(disputeId, inFavorOfRequester);
    }
}
