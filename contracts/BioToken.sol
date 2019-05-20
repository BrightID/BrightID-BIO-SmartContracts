pragma solidity ^0.4.24;

import "./openzeppelin/contracts/token/ERC20/MintableToken.sol";


/**
 * @title BIO token contract.
  * @dev ERC20 token contract.
 */
contract BioToken is MintableToken {
    string public constant name = "BrightIdOffering";
    string public constant symbol = "BIO";
    uint32 public constant decimals = 18;
}
