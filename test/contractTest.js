const { assert } = require('chai');

const REMYToken = artifacts.require("./contracts/REMYToken.sol");
const Vendor = artifacts.require("./contracts/Vendor.sol");
require('../node_modules/chai')
	.use(require('../node_modules/chai-as-promised'))
	.should()

contract('REMYToken', (accounts) => {
    let remy;

    // deploy Remy contract
    before(async () => {
        remy = await REMYToken.deployed();
    });

    describe('deployment', async () => {

        // successful deployment criteria for Remy token contract
        it('deploys successfully', async () => {
            let address = await remy.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
			assert.notEqual(address, null);
			assert.notEqual(address, undefined);
        });

        // Remy token contract has a name and symbol
        it('has a name and symbol', async () => {
			let name = await remy._tokenName();
			let symbol = await remy._tokenSymbol();
            assert.equal(name, 'Remy');
            assert.equal(symbol, 'RMT');
		});
    });
});

contract('Vendor', ([deployer, seller, buyer]) => {
    let remy, vendor;

    // deploy vendor contract
    before(async () => {
        remy = await REMYToken.deployed();
        vendor = await Vendor.deployed();
    });

    describe('deployment', async () => {

        // successful deployment criteria for vendor contract
        it('deploys successfully', async () => {
            let address = await vendor.address;

            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
			assert.notEqual(address, null);
			assert.notEqual(address, undefined);
        });
    });
    
    describe('functionalities', async () => {

        it('purchases token(s)', async () => {
            let initialBuyerBalance, initialVendorBalance;
            let buyerAddress = buyer;
            let amountOfTokenToBePurchased = 3;

            // track buyer's balance before purchase
            initialBuyerBalance = await web3.eth.getBalance(buyer);
            initialBuyerBalance = new web3.utils.BN(initialBuyerBalance);
            assert.notEqual(initialBuyerBalance, 0);

            // track buyer's balance before purchase
            initialVendorBalance = await web3.eth.getBalance(vendor.address);
            assert.isAtLeast(initialVendorBalance, amountOfTokenToBePurchased);

            // buy n token
            // remy.transfer(buyerAddress, amountOfTokenToBePurchased);
        });
    });
});