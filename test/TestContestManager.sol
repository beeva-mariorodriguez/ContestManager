pragma solidity ^0.4.18;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ContestManager.sol";
import "../contracts/Contest.sol";

contract TestContestManager {
    ContestManager cm = ContestManager(DeployedAddresses.ContestManager());
    Contest contest = new Contest(1525937318, 1525937319, "test", 100, address(cm), 2);
    function testBalanceOf0() public {
        uint b = cm.balanceOf(0);
        Assert.equal(b, 0, "testBalanceOf() failed, balance should be 0");
    }
    function testContestDeployment() public {
        Assert.equal(address(cm), address(contest.cm()), "testContestDeployment() failed, contest->cm should be cm");
    }
}
