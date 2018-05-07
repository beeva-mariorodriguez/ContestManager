pragma solidity ^0.4.18;

import "./ContestManager.sol";

contract Contest {
    uint registerFinalDate;
    uint contestDate;
    ContestManager cm;
    string description;
    uint totalTickets;
    uint availableTickets;
    uint tokensPerTicket;
    mapping(bytes32 => bool) public claimedTickets;

    constructor( uint _registerFinalDate, uint _contestDate,string _description, uint _totalTickets, address _contestManagerAddr, uint _tokensPerTicket) public {
        registerFinalDate=_registerFinalDate;
        description=_description;
        contestDate=_contestDate;
        totalTickets=_totalTickets;
        tokensPerTicket=_tokensPerTicket;
        cm= ContestManager(_contestManagerAddr);

    }
    // not working!
    function claimTicket(bytes32 code) public returns(bytes32) {
        require(claimedTickets[code] == false);
        require(availableTickets > 0);
        cm.spendTokens(msg.sender,tokensPerTicket);
        availableTickets--;
        if(availableTickets == 0){
            emit NoMoreTickets();
        }
        claimedTickets[code] = true;
        emit TicketClaimed(code);
        return code;
    }

    function checkTicket(bytes32 code) public view returns (bool) {
        return claimedTickets[code];
    }

    function freeTicket(bytes32 code) public returns (bytes32) {
        require(claimedTickets[code] == true);
        cm.recoverTokens(msg.sender,tokensPerTicket);
        claimedTickets[code] = false;
        emit TicketFreed(code);
        availableTickets++;
        claimedTickets[code] = false;
        return code;
    }
    event TicketClaimed(bytes32 code);
    event TicketFreed(bytes32 code);
    event NoMoreTickets();
}

