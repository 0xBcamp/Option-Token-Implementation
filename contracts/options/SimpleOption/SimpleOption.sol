pragma solidity ^0.8.13;

import "../BaseOption.sol";
import "../interfaces/IOToken.sol";
import "./interfaces/IPriceOracle.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

contract SimpleOption is BaseOption, Ownable {
    using FixedPointMathLib for uint256;

    IPriceOracle public oracle;
    IERC20 public paymentToken;
    address public treasury;

    error SlippageExceeded();

    constructor(IOToken _oToken, IPriceOracle _oracle, IERC20 paymentToken) BaseOption(_oToken) {
        oracle = _oracle;
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

        uint256 paymentAmount = amount.mulWadUp(oracle.getPrice());
        if (paymentAmount > maxPaymentAmount) {
            revert SlippageExceeded();
        }

        paymentToken.transferFrom(msg.sender, treasury, paymentAmount);
    }
}
