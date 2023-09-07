// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.13;

import "./interfaces/IOption.sol";
import "./interfaces/IOToken.sol";

abstract contract BaseOption is IOption {
    IOToken internal oToken;

    constructor(IOToken _oToken) {
        oToken = _oToken;
    }

    function burnOToken(address from, uint256 amount) internal {
        oToken.burnFrom(from, amount);
    }
}
