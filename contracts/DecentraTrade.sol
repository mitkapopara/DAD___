// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./DecentraToken.sol";

contract DecentraTrade {
    uint256 public itemCount = 0;
    AdvancedToken public token;

    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool forSale;
    }

    mapping(uint256 => Item) public items;

    event ItemListed(uint256 id, string name, uint256 price);
    event ItemPurchased(uint256 id, address newOwner);
    event ItemTransferred(uint256 id, address newOwner);

    constructor(address _tokenAddress) {
        token = AdvancedToken(_tokenAddress);
    }

    function listItem(string memory _name, uint256 _price) public {
        itemCount++;
        items[itemCount] = Item(
            itemCount,
            _name,
            _price,
            payable(msg.sender),
            true
        );
        emit ItemListed(itemCount, _name, _price);
    }

    function purchaseItem(uint256 _id) public {
        Item memory item = items[_id];
        require(item.forSale, "Item is not for sale");
        require(
            token.balanceOf(msg.sender) >= item.price,
            "Insufficient balance"
        );

        // Transfer tokens from buyer to seller
        token.transferFrom(msg.sender, item.owner, item.price);

        // Update item owner and forSale status
        items[_id].owner = payable(msg.sender);
        items[_id].forSale = false;

        emit ItemPurchased(_id, msg.sender);
    }

    function transferItem(uint256 _id, address _newOwner) public {
        Item memory item = items[_id];
        require(msg.sender == item.owner, "Only the owner can transfer");

        // Update item owner
        items[_id].owner = payable(_newOwner);

        emit ItemTransferred(_id, _newOwner);
    }
}
