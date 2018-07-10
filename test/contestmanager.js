const cm = artifacts.require("ContestManager");

contract('ContestManager JS test', async (accounts) => {
    it("deploy contract",async() =>{
        let instance = await cm.deployed();
        let balance = await instance.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
    it("add tokens", async() => {
        let instance = await cm.deployed();
        instance.addTokens.call(10,0);
        let balance = await instance.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
})

