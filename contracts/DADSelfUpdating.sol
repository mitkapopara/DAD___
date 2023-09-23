// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./DADInterlinkedNodes.sol";

contract DADSelfUpdating is ChainlinkClient {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    DADInterlinkedNodes public dataNodesContract;

    struct UpdateableNode {
        uint256 nodeId;
        string chainlinkURL; // The Chainlink oracle URL or the endpoint
        uint256 updateInterval; // Time (in seconds) after which this data node should be updated.
        uint256 lastUpdated;
    }

    UpdateableNode[] public updateableNodes;

    event NodeUpdateScheduled(
        uint256 indexed updateableNodeId,
        uint256 nextUpdate
    );
    event NodeUpdated(uint256 indexed updateableNodeId, string newData);

    constructor(
        address _oracle,
        bytes32 _jobId,
        uint256 _fee,
        address _dataNodesContractAddress
    ) {
        setPublicChainlinkToken();
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
        dataNodesContract = DADInterlinkedNodes(_dataNodesContractAddress);
    }

    function scheduleNodeForUpdates(
        uint256 nodeId,
        string memory chainlinkURL,
        uint256 updateInterval
    ) external returns (uint256) {
        UpdateableNode memory newNode = UpdateableNode({
            nodeId: nodeId,
            chainlinkURL: chainlinkURL,
            updateInterval: updateInterval,
            lastUpdated: block.timestamp
        });

        updateableNodes.push(newNode);
        uint256 updateableNodeId = updateableNodes.length - 1;
        emit NodeUpdateScheduled(
            updateableNodeId,
            block.timestamp + updateInterval
        );
        return updateableNodeId;
    }

    function requestNodeUpdate(
        uint256 updateableNodeId
    ) external returns (bytes32 requestId) {
        require(
            block.timestamp >
                updateableNodes[updateableNodeId].lastUpdated +
                    updateableNodes[updateableNodeId].updateInterval,
            "Too early to update"
        );

        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        req.addString("get", updateableNodes[updateableNodeId].chainlinkURL);

        return sendChainlinkRequestTo(oracle, req, fee);
    }

    function fulfill(
        bytes32 _requestId,
        string memory data
    ) public recordChainlinkFulfillment(_requestId) {
        uint256 updateableNodeId = getUpdateableNodeIdByRequestId(_requestId);
        dataNodesContract.updateNodeContent(
            updateableNodes[updateableNodeId].nodeId,
            data
        );
        updateableNodes[updateableNodeId].lastUpdated = block.timestamp;
        emit NodeUpdated(updateableNodeId, data);
    }

    // Helper function to get nodeId by Chainlink requestId.
    function getUpdateableNodeIdByRequestId(
        bytes32 _requestId
    ) internal view returns (uint256) {
        // Logic to map requestId to nodeId.
        // This is a simplification. In production, maintain a mapping of requestIds to nodeIds.
        return 0; // Placeholder
    }
}
