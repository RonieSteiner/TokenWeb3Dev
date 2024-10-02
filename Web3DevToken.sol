// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3DevToken2 is ERC20, Ownable {
    uint256 inviteAmount = 1 * 10 ** decimals();
    uint256 constant invitesPerAccount = 4;
    
    struct Member {
        address whoInvited;
        bool isMember;
        uint invites;
        bool isBanned;
        uint lastInvite;
        uint memberSince;
    }

    mapping(address => Member) public members;

    constructor() ERC20("Web3DevToken2", "W3DT") {
        _mint(msg.sender, invitesPerAccount);
        members[msg.sender] = Member(msg.sender, true, invitesPerAccount, false,0,block.timestamp);
    }

    function invite(address account) public {
        require(members[msg.sender].isMember, "Only members can invite!");
        require(members[msg.sender].isBanned == false, "Banned members cannot invite!");
        require(balanceOf(msg.sender) > 1, "You run out of invites!");
        require(account != msg.sender, "You can't invite yourself!");
        require(members[account].isMember == false , "The account that you are trying to invite is already a member.");
        require(block.timestamp >= members[msg.sender].lastInvite + 1 days);

        _burn(msg.sender, 1);
        members[msg.sender].invites - 1;
        _mint(account, invitesPerAccount);
        members[account] = Member(msg.sender, true, invitesPerAccount, false,0,block.timestamp);
        members[msg.sender].lastInvite = block.timestamp
    }

    function checkMember(address account) public view returns (bool) {
        require(members[account].isActive, "This address is not a member");
        require(members[account].isBanned == false, "This address is banned from the community");
        return true
    }

    function transfer(address, uint256) public pure override returns (bool) {
        revert("Transfers are disable!");
    }

    function banAccount(address account) public onlyOwner {
        require(members[account].isActive, "This address is not an member");
        members[account].isBanned = true; 
    }

    function unBanAccount(address account) public onlyOwner {
        require(members[account].isActive, "This address is not an member");
        members[account].isBanned = false; 
    }
}
