// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Web3DevToken2 is ERC20 {
    uint256 inviteAmount = 1 * 10 ** decimals();
    uint256 constant invitesPerAccount = 4;
    mapping(address => bool) members;
    address[] public memberAddresses;


    constructor() ERC20("Web3DevToken2", "W3DT") {
        _mint(msg.sender, invitesPerAccount);
        members[msg.sender] = true;
        memberAddresses.push(msg.sender);
    }

    function invite(address account) public {
        require(balanceOf(msg.sender) > 0, "Only members can invite!");
        require(balanceOf(msg.sender) > 1, "You run out of invites!");
        require(account != msg.sender, "You can't invite yourself!" );
        require(balanceOf(account) == 0, "The account you are trying to invite is already a member.");

        _burn(msg.sender, 1);
        _mint(account, invitesPerAccount);
        members[account] = true;
        memberAddresses.push(account);
    }

    function checkMember(address account) view public returns(bool) {
        return members[account];
    }

    function transfer(address, uint256) public pure override returns(bool) {
        revert("Transfers are disable!");
    }

    function membersQuantity() public view returns (uint256) {
        return memberAddresses.length;
    }

    function membersList(uint256 startIndex, uint256 endIndex) public view returns (address[] memory) {
        require(endIndex > startIndex, "End index must be greater than start index.");
        require(endIndex <= memberAddresses.length, "End index out of bounds. To know the number of indices, use the function membersQuantity.");

        uint256 length = endIndex - startIndex;
        address[] memory partialList = new address;

        for (uint256 i = 0; i < length; i++) {
            partialList[i] = memberAddresses[startIndex + i];
        }

        return partialList;
    }
}
