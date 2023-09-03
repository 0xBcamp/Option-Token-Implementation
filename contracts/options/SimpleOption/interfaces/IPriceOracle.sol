pragma solidity ^0.8.13;

interface IPriceOracle {
    function getPrice() external view returns (uint256);
}
