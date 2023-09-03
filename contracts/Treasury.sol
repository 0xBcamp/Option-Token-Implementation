pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasury is Ownable {
    address public oToken;

    constructor(address _oToken) {
        oToken = _oToken;
    }

    function whitelist(address addr) external {}
}
