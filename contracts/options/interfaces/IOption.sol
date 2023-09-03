pragma solidity ^0.8.13;

interface IOption {
    function exercise(uint256 amount, address to) external;
}
