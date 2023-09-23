// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract DADRequests {
    struct DataRequest {
        address requester;
        string dataDescription;
        uint256 reward;
        bool fulfilled;
        uint256 expiryTime;
    }

    mapping(uint256 => DataRequest) public requests;
    mapping(address => uint256[]) public userRequests;

    event DataRequestCreated(uint256 requestId);
    event DataRequestFulfilled(uint256 requestId);

    function createDataRequest(
        string memory description,
        uint256 reward,
        uint256 expiryTime
    ) external returns (uint256) {
        DataRequest memory newRequest = DataRequest({
            requester: msg.sender,
            dataDescription: description,
            reward: reward,
            fulfilled: false,
            expiryTime: expiryTime
        });

        uint256 requestId = uint256(
            keccak256(
                abi.encodePacked(msg.sender, description, block.timestamp)
            )
        );
        requests[requestId] = newRequest;
        userRequests[msg.sender].push(requestId);

        emit DataRequestCreated(requestId);

        return requestId;
    }

    function fulfillDataRequest(uint256 requestId) external {
        require(!requests[requestId].fulfilled, "Request already fulfilled");

        requests[requestId].fulfilled = true;

        emit DataRequestFulfilled(requestId);
    }

    function extendRequest(uint256 requestId, uint256 additionalTime) external {
        require(
            msg.sender == requests[requestId].requester,
            "Only the requester can extend the request"
        );
        require(
            block.timestamp <= requests[requestId].expiryTime,
            "Request has expired"
        );

        requests[requestId].expiryTime =
            requests[requestId].expiryTime +
            additionalTime;
    }

    function getRequest(
        uint256 requestId
    ) external view returns (DataRequest memory) {
        return requests[requestId];
    }
}
