pragma solidity ^0.8.13;

import "./BaseOption.sol";

contract SimpleOption is BaseOption {
    //set oracle function

    //set treasury function

    //exercise function
    function _exercise(uint256 amount, address to) external override {
        //exercise function
        super._exercise(amount, to);
    }
}
