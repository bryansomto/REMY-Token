const REMYToken = artifacts.require("REMYToken");
const Vendor = artifacts.require("Vendor");

module.exports = function (deployer) {
  deployer.deploy(REMYToken).then(function() {
    return deployer.deploy(Vendor, REMYToken.address);
  });
};
