pragma solidity ^0.4.18;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ContestManager.sol";

contract TestContestManager {
    ContestManager cm = ContestManager(DeployedAddresses.ContestManager());
    function testBalanceOf0() public {
        uint b = cm.balanceOf(0);
        Assert.equal(b, 0, "testBalanceOf() failed, balance should be 0");
    }
}
