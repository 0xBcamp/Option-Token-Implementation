pragma solidity ^0.8.13;

import "./options/interfaces/IOption.sol";

//bring in proper libraries for inheritance and security

contract otoken is AccessControl, ERC20 {
    //establish proper usages for overflows and what not
    //ERC20 stuff, fixedpoint math stuff
    using SafeERC20 for IERC20;

    //Contract state
    //Options registry
    IOption[] public options;

    //Import custom errors
    //Custom errors save on gas and since we shouldn't have a crazy number of types of errors we can simply write custom errors...
    //instead of using requires which use more gas

    //Setup Events
    //Here we'll set up the proper events that we want to use in the token
    //Looks like an "exericise", "Set Oracle", and "Set Treasury" event so these can be listened to/monitored on chain

    //set up immutables
    //These would include tokenadmin, payment token, and the underlying token
    //As well as the public treasury and other storage variables (oracle)

    //Constructor
    //Setup everything needed
    //Set name of token, etc
    constructor(string name, string symbol) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// Functions
    ///////////////////////////////////////////////////////////////////////////////////////////////

    //mint function
    function mint(address account, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(account, amount);
    }

    //exercise function
    function exercise(uint256 amount, uint256 optionId) external {
        _exercise(amount, optionId);
    }

    //set option function
    function setOption(address option) external onlyRole(DEFAULT_ADMIN_ROLE) {
        options.push(option);
    }

    //set internal exercise function
    function _exercise(uint256 amount, uint256 optionId) external {
        _burn(msg.sender, amount);
        options[optionId]._exercise(amount, msg.sender);
    }

    //override approve to skip option contracts
}
