var BioToken = artifacts.require('BioToken.sol');
var BioMinter = artifacts.require('BioMinter.sol');
var NonFungibleBIO = artifacts.require('NonFungibleBIO.sol');
var financeAddr = '';
var paymentTokenAddr = '';

module.exports = function (deployer) {
  deployer.then(async () => {

    await deployer.deploy(BioToken);
    const instanceBioToken = await BioToken.deployed();

    await deployer.deploy(NonFungibleBIO);
    const instanceNonFungibleBIO = await NonFungibleBIO.deployed();

    await deployer.deploy(BioMinter, instanceBioToken.address, instanceNonFungibleBIO.address, paymentTokenAddr, financeAddr);
    const instanceBioMinter = await BioMinter.deployed();

    await instanceBioToken.transferOwnership(instanceBioMinter.address);
    await instanceNonFungibleBIO.transferOwnership(instanceBioMinter.address);

  })
}
