pragma solidity ^0.4.23;

import "./Contest.sol";

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract ContestManager {
    address admin;
    string public name;
    string public symbol;
    mapping(address => bool) public contests;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    using SafeMath for uint;

    modifier onlyAdmin()
    { 
        require(msg.sender == admin); 
        _; 
    }
   
    constructor() public
    {
        admin = msg.sender;
        name = "TicketToken";
        symbol = "TT";
    }

    function addTokens(uint tokens,address to) onlyAdmin public returns (bool success)
    {
        balances[to] = balances[to].add(tokens);
        emit Transfer(admin, to, tokens);
        return true;
    }

    function newContest(uint registerFinalDate, uint contestDate, string description, uint totalTickets, uint tokensPerTicket)
        onlyAdmin 
        public 
        returns (address contest)
    {
        require(registerFinalDate < contestDate);
        address c = new Contest(registerFinalDate, contestDate, description, totalTickets, address(this)  , tokensPerTicket);
        contests[c] = true;
        emit CreatedContest(c);
        return c;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance)
    {
        return balances[tokenOwner];
    }

    function spendTokens(address claimer, uint tokensToSpend) public returns (bool success)
    {
        require(contests[msg.sender] == true);
        // maybe require(tx.origin == claimer) ?
        balances[claimer] = balances[claimer].sub(tokensToSpend);
        return true;
    }
    
    function recoverTokens(address claimer, uint tokensToRecover) public returns (bool success)
    {
        require(contests[msg.sender] == true);
        // maybe require(tx.origin == claimer) ?
        balances[claimer] = balances[claimer].add(tokensToRecover);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event CreatedContest(address contest);
}
