const ContestManager = artifacts.require("ContestManager");
const Contest = artifacts.require("Contest");

contract('ContestManager: ', async (accounts) => {
    it("initial balance of 0 should be 0",async () =>{
        let cm = await ContestManager.deployed();
        let balance = await cm.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
    it("should add tokens correctly", async () => {
        let cm = await ContestManager.deployed();
        cm.addTokens.call(10,0);
        let balance = await cm.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
})

contract('Contest: ', async (accounts) => {
    let contest;
    it("ContestManager should correcly deploy Contest", async () => {
        let cm = await ContestManager.deployed();
        let tx = await cm.newContest(
            Date.now() + 86400000,
            Date.now() + 86401000,
            "testContest",
            100, 2);
        // tx.logs[0].args.contest <- get the newly deployed contest address
        // from the event emitted by ContestManager.newContest()
        // contest = Contest.at instantiate contract by address
        contest = Contest.at(tx.logs[0].args.contest);
        // will fail if the child contract was incorrectly instantiated
        assert.equal(await contest.totalTickets(), 100);
        // check if the child contract was correctly added to the mapping 
        // ContestManager.contests[]
        assert.equal(await cm.contests(contest.address), true);
    });
    it("user should be able to claim a ticket", async () => {
        let cm = await ContestManager.deployed();
        cm.addTokens(10,web3.eth.accounts[0]);
        let claimed = await contest.claimTicket.call()
        assert.equal(claimed, true);
    });

})

