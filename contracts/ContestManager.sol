pragma solidity ^0.4.23;

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

contract ERC20Interface {
    function totalSupply() public constant returns (uint);                                   
    function balanceOf(address tokenOwner) public constant returns (uint balance);           
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining); 
    function transfer(address to, uint tokens) public returns (bool success); 
    function approve(address spender, uint tokens) public returns (bool success); 
    function transferFrom(address from, address to, uint tokens) public returns (bool success); 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ContestManager is ERC20Interface {
    address admin;
    string public name;
    string public symbol;
    mapping(address => bool) public contests;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint public _totalSupply;

    using SafeMath for uint;

    modifier onlyAdmin() { 
        require(msg.sender == admin); 
        _; 
    }
   
    constructor() public {
        admin = msg.sender;
        name = "TicketToken";
        symbol = "TT";
        _totalSupply = 100;
        balances[admin] = _totalSupply;
        emit Transfer(address(0), admin, _totalSupply);
    }
    function addTokens(uint tokens) onlyAdmin public returns (bool success) {
        _totalSupply = _totalSupply.add(tokens);
        balances[admin] = balances[admin].add(tokens);
        emit Transfer(address(0), admin, tokens);
        return true;
    }
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    function newContest(uint registerFinalDate, uint contestDate, string description, uint totalTickets) onlyAdmin public returns (address contest) {
        require(registerFinalDate < contestDate);
        address c = new Contest(registerFinalDate, contestDate, description, totalTickets);
        contests[c] = true;
        emit CreatedContest(c);
        return c;
    }
    function totalSupply() public constant returns (uint){
        return _totalSupply  - balances[admin];
    } 
    function balanceOf(address tokenOwner) public constant returns (uint balance){
        return balances[tokenOwner];
    }
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining){
        return allowed[tokenOwner][spender];
    }
    function spendTokens(address claimer, uint tokensToSpend) public returns (bool success) {
        require(contests[msg.sender] == true);
        // maybe require(tx.origin == claimer) ?
        balances[claimer] = balances[claimer].sub(tokensToSpend);
        return true;
    }
    function recoverTokens(address claimer, uint tokensToRecover) public returns (bool success) {
        require(contests[msg.sender] == true);
        // maybe require(tx.origin == claimer) ?
        balances[claimer] = balances[claimer].add(tokensToRecover);
        return true;
    }

    event CreatedContest(address contest);
}

contract Contest {
    uint registerFinalDate;
    uint contestDate;
    string description;
    uint totalTickets;
    uint availableTickets;
    mapping(bytes32 => bool) public claimedTickets;

    constructor( uint _registerFinalDate, uint _contestDate,string _description, uint _totalTickets) public {
        registerFinalDate=_registerFinalDate;
        description=_description;
        contestDate=_contestDate;
        totalTickets=_totalTickets;
    }
    // not working!
    function claimTicket(bytes32 code) public returns(bytes32) {
        require(claimedTickets[code] == false);
        require(availableTickets > 0);
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

