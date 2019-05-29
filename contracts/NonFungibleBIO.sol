pragma solidity ^0.5.0;

import "./openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "./openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";


/**
 * @title Non Fungible BIO token contract.
  * @dev ERC721 token contract.
 */
contract NonFungibleBIO is ERC721Full, ERC721Mintable {
    string public constant NAME = "NonFungibleBIO";
    string public constant SYMBOL = "NFBIO";

    constructor ()
        public
        ERC721Full(NAME, SYMBOL)
    {
        // no-empty-blocks
    }
}
