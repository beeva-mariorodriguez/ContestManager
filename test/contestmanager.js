const cm = artifacts.require("ContestManager");

contract('ContestManager JS test', async (accounts) => {
    it("blablabla",async() =>{
        let instance = await cm.deployed();
        let balance = await instance.balanceOf.call(0);
        assert.equal(balance.valueOf(), 0);
    });
})

