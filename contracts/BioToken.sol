pragma solidity ^0.5.0;

import "./openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";


/**
 * @title BIO token contract.
  * @dev ERC20 token contract.
 */
contract BioToken is ERC20Mintable {
    string public constant name = "BrightIdOffering";
    string public constant symbol = "BIO";
    uint32 public constant decimals = 18;
}
