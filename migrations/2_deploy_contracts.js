var ContestManager = artifacts.require("ContestManager");
var Contest = artifacts.require("Contest");
module.exports = function(deployer) {
    deployer.deploy(ContestManager);
    deployer.deploy(Contest);
};
