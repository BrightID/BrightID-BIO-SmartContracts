var BioToken = artifacts.require('BioToken.sol');
var BioMinter = artifacts.require('BioMinter.sol');
var Bios = artifacts.require('Bios.sol');
var financeAddr = '';
var daiAddr = '';

module.exports = function (deployer) {
  deployer.then(async () => {

    await deployer.deploy(Bios);
    const instanceBios = await Bios.deployed();

    await deployer.deploy(BioToken);
    const instanceBioToken = await BioToken.deployed();

    await deployer.deploy(BioMinter, instanceBioToken.address, daiAddr, instanceBios.address, financeAddr);
    const instanceBioMinter = await BioMinter.deployed();

    await instanceBioToken.transferOwnership(instanceBioMinter.address);

    await instanceBios.addBio(instanceBioMinter.address);
  })
}
