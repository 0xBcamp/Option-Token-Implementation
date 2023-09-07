pragma solidity ^0.8.13;

import "./options/interfaces/IOption.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

//bring in proper libraries for inheritance and security

contract oToken is AccessControl, ERC20Burnable {
    //Contract state
    //Options registry
    mapping(address => bool) public options;
    IERC20 public underlyingToken;

    //Import custom errors
    //Custom errors save on gas and since we shouldn't have a crazy number of types of errors we can simply write custom errors...
    //instead of using requires which use more gas
    error WithdrawNotOption();

    //Setup Events
    //Here we'll set up the proper events that we want to use in the token
    //Looks like an "exericise", "Set Oracle", and "Set Treasury" event so these can be listened to/monitored on chain

    //set up immutables
    //These would include tokenadmin, payment token, and the underlying token
    //As well as the public treasury and other storage variables (oracle)

    //Constructor
    //Setup everything needed
    //Set name of token, etc
    constructor(string memory name, string memory symbol, IERC20 _underlyingToken) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        underlyingToken = _underlyingToken;
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions
    ///////////////////////////////////////////////////////////////////////////////////////////////

    //mint function
    function mint(address account, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(account, amount);
    }

    //called by option contracts to withdraw the underlying token
    function withdrawUnderlying(address to, uint256 amount) external {
        if (!options[msg.sender]) {
            revert WithdrawNotOption();
        }
        underlyingToken.transfer(to, amount);
    }

    //set option function
    function setOption(address addr, bool isOption) external onlyRole(DEFAULT_ADMIN_ROLE) {
        options[addr] = isOption;
        if (isOption) {
            approve(addr, type(uint256).max);
        }
    }

    //override approve/burnFrom to skip option contracts?
}
