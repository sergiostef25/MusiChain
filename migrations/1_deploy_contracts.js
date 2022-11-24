const MusiChain = artifacts.require('MusiChain');

//deployer è un oggetto fornito da truffle
module.exports = function (deployer) {
    deployer.deploy(MusiChain);
}
