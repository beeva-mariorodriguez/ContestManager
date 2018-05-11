pragma solidity ^0.4.18;

import "./ContestManager.sol";

contract Contest
{
    uint public registerFinalDate;
    uint public contestDate;
    ContestManager public cm;
    string public description;
    uint public totalTickets;
    uint public availableTickets;
    uint public tokensPerTicket;
    mapping(address => bool) public claimedTickets;

    using SafeMath for uint;

    constructor
        (uint _registerFinalDate, uint _contestDate,string _description, uint _totalTickets, uint _tokensPerTicket) 
        public 
    {
        registerFinalDate = _registerFinalDate;
        description = _description;
        contestDate = _contestDate;
        totalTickets = _totalTickets;
        tokensPerTicket = _tokensPerTicket;
        availableTickets = totalTickets;
        cm = ContestManager(msg.sender);
    }

    function claimTicket() public returns (bool success)
    {
        require(claimedTickets[msg.sender] == false);
        require(availableTickets >= 1);
        cm.spendTokens(msg.sender, tokensPerTicket);
        availableTickets = availableTickets.sub(1);
        claimedTickets[msg.sender] = true;
        emit TicketClaimed(msg.sender);
        return true;
    }

    function freeTicket() public returns (bool success)
    {
        require(claimedTickets[msg.sender]);
        // user will always recover just 1 token, even if he spent more to claim the ticket
        cm.recoverTokens(msg.sender, 1);
        availableTickets = availableTickets.add(1);
        claimedTickets[msg.sender] = false;
        emit TicketFreed(msg.sender);
        return true;
    }

    event TicketClaimed(address claimer);
    event TicketFreed(address claimer);
}

