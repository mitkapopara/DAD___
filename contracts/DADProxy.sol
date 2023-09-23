// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract DADInterlinkedNodes {
    struct DataNode {
        uint256 id;
        address owner;
        string data;
        uint256 parentNodeId; // If this is 0, it means this node has no parent.
    }

    uint256 public lastNodeId = 0;
    mapping(uint256 => DataNode) public dataNodes;

    event DataNodeCreated(uint256 nodeId, address owner);
    event DataNodeLinked(uint256 nodeId, uint256 parentNodeId);

    function createDataNode(string memory data) external returns (uint256) {
        lastNodeId++;

        DataNode memory newNode = DataNode({
            id: lastNodeId,
            owner: msg.sender,
            data: data,
            parentNodeId: 0 // Default value, can be changed later.
        });

        dataNodes[lastNodeId] = newNode;
        emit DataNodeCreated(lastNodeId, msg.sender);

        return lastNodeId;
    }

    function linkDataNode(uint256 nodeId, uint256 parentNodeId) external {
        require(
            dataNodes[nodeId].owner == msg.sender,
            "Not the owner of the data node."
        );
        require(dataNodes[parentNodeId].id != 0, "Parent node doesn't exist.");
        require(nodeId != parentNodeId, "Node cannot be linked to itself.");

        dataNodes[nodeId].parentNodeId = parentNodeId;

        emit DataNodeLinked(nodeId, parentNodeId);
    }

    function getNode(uint256 nodeId) external view returns (DataNode memory) {
        return dataNodes[nodeId];
    }
}
