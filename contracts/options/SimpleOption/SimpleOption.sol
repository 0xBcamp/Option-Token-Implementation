// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.13;

import "../BaseOption.sol";
import "../interfaces/IOToken.sol";
import "./interfaces/IPriceOracle.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {FixedPointMathLib} from "@rari-capital/solmate/src/utils/FixedPointMathLib.sol";

contract SimpleOption is BaseOption, Ownable {
    using FixedPointMathLib for uint256;

    IPriceOracle public oracle;
    IERC20 public paymentToken;
    address public treasury;
    //should be 1100000000000000000 for a 110% dis
    uint256 public discount;

    error SlippageExceeded();

    constructor(IOToken _oToken, IPriceOracle _oracle, IERC20 paymentToken, uint256 _discount) BaseOption(_oToken) {
        oracle = _oracle;
        discount = _discount;
    }

    //set oracle function
    function setOracle(IPriceOracle _oracle) external onlyOwner {
        oracle = _oracle;
    }

    //set treasury function
    function setTreasury(address _treasury) external onlyOwner {
        treasury = _treasury;
    }

    //exercise function
    function exercise(uint256 amount, uint256 maxPaymentAmount, address to) external {
        _exercise(amount, maxPaymentAmount, to);
    }

    //exercise function
    function _exercise(uint256 amount, uint256 maxPaymentAmount, address to) internal {
        burnOToken(msg.sender, amount);

        uint256 paymentAmount = amount.mulWadUp(oracle.getPrice(), discount);
        if (paymentAmount > maxPaymentAmount) {
            revert SlippageExceeded();
        }

        paymentToken.transferFrom(msg.sender, treasury, paymentAmount);
    }
}
