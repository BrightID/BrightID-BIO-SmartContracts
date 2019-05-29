var BioToken = artifacts.require('BioToken.sol');
var BioMinter = artifacts.require('BioMinter.sol');
var NFbioToken = artifacts.require('NonFungibleBIO.sol');
var financeAddr = '';
var paymentTokenAddr = '';

module.exports = function (deployer) {
  deployer.then(async () => {

    await deployer.deploy(BioToken);
    const instanceBioToken = await BioToken.deployed();

    await deployer.deploy(NFbioToken);
    const instanceNFbioToken = await NFbioToken.deployed();

    await deployer.deploy(BioMinter, instanceBioToken.address, instanceNFbioToken.address, paymentTokenAddr, financeAddr);
    const instanceBioMinter = await BioMinter.deployed();

    await instanceBioToken.addMinter(instanceBioMinter.address);

    await instanceNFbioToken.addMinter(instanceBioMinter.address);
  })
}
