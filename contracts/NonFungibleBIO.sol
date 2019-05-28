pragma solidity ^0.5.0;

import "./openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "./openzeppelin/contracts/ownership/Ownable.sol";

contract NonFungibleBIO is ERC721Full, Ownable {
    uint256 public tokenId = 0;

    string public constant NAME = "NonFungibleBIO";
    string public constant SYMBOL = "NFBIO";

    constructor ()
        public
        ERC721Full(NAME, SYMBOL)
    {
        // no-empty-blocks
    }

    /**
     * @dev Mint non fungible BIO token.
     * @param userAddress The BrightID user address.
     */
    function mint(address userAddress)
        public
        onlyOwner
        returns(bool ret)
    {
        super._mint(userAddress, tokenId);
        ++tokenId;
        return true;
    }
}