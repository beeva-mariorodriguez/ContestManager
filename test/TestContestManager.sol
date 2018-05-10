pragma solidity ^0.4.18;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ContestManager.sol";
import "../contracts/Contest.sol";

contract TestContestManager 
{
    ContestManager cm = new ContestManager();
    Contest contest;
    function testBalanceOf0() public
    {
        uint b = cm.balanceOf(0);
        Assert.equal(b, 0, "testBalanceOf() failed, balance should be 0");
    }

    function testAddTokens() public
    {
        cm.addTokens(10,0);
        Assert.equal(10, cm.balanceOf(0), "testAddTokens() failed, balance should be 10");
    }
    
    function testNewContest() public
    {
        contest = Contest(cm.newContest(1525937318, 1525937319, "test",100, 2));
        Assert.equal(address(cm), address(contest.cm()), "testNewContest() failed, bad contest->cm");
        Assert.equal(cm.contests(contest), true, "testNewContest() failed, ContestManager->contests[] array not updated");
    }
}
