// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DADRoles is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); // Owner has the default admin role, can grant/revoke other roles
    }

    function grantAdmin(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ADMIN_ROLE, account);
    }

    function revokeAdmin(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(ADMIN_ROLE, account);
    }

    function grantModerator(address account) external onlyRole(ADMIN_ROLE) {
        grantRole(MODERATOR_ROLE, account);
    }

    function revokeModerator(address account) external onlyRole(ADMIN_ROLE) {
        revokeRole(MODERATOR_ROLE, account);
    }
}
