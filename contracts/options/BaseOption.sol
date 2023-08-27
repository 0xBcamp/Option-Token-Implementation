pragma solidity ^0.8.13;

import "./interfaces/IOption.sol";

abstract contract BaseOption is IOption {
    address oToken;

    constructor(address _oToken) {
        oToken = _oToken;
    }

    modifier onlyOToken() {
        require(msg.sender == oToken, "Only oToken can call this function");
        _;
    }

    function _exercise(uint256 amount, address to) external virtual onlyOToken {}
}
