// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// pragma abicoder v2;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract REMYToken is ERC20 {
    string public _tokenName = "Remy";
    string public _tokenSymbol = "RMT";

    constructor() ERC20(_tokenName, _tokenSymbol) {
        _mint(msg.sender, 1000 * 10 * 18);
    }
}
