const contestmanager = artifacts.require("ContestManager");
const contest = artifacts.require("Contest");

web3.eth.defaultAccount = '0x627306090abab3a6e1400e9345bc60c78a8bef57';

contract('ContestManager JS test', async (accounts) => {
    it("deploy contract",async () =>{
        let cm = await contestmanager.deployed();
        let balance = await cm.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
    it("add tokens", async () => {
        let cm = await contestmanager.deployed();
        cm.addTokens.call(10,0);
        let balance = await cm.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
})

contract('Deploy new Contest', async (accounts) => {
    it("deploy contest", async () => {
        let cm = await contestmanager.deployed();
        let event = cm.CreatedContest((error, result) => {
            if (!error)
                console.log(result);
            else
                console.log(error);
            this.CreatedContest.stopWatching();
        });


        let c = await cm.newContest.call(
            Date.now() + 86400000,
            Date.now() + 86401000,
            "testContest",
            100, 2);
    });
})

