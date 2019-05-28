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
    }

    /**
     * @dev Convert timestamp to string.
     * @param timestamp The timestamp.
     */
    function timestamp2string(uint256 timestamp)
        internal
        pure
        returns (string memory timestampString)
    {
        uint256 tmpTimestamp = timestamp; // To avoid security/no-assign-params error.
        if (tmpTimestamp == 0) {
            return "0";
        }
        uint256 i = tmpTimestamp;
        uint256 len;
        while (i != 0) {
            len++;
            i /= 10;
        }
        bytes memory bytesString = new bytes(len);
        uint256 k = len - 1;
        while (tmpTimestamp != 0) {
            bytesString[k--] = byte(uint8(48 + tmpTimestamp % 10));
            tmpTimestamp /= 10;
        }
        return string(bytesString);
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
        uint256 timestamp = now;
        string memory timestampString = timestamp2string(timestamp);
        super._mint(userAddress, tokenId);
        super._setTokenURI(tokenId, timestampString);
        ++tokenId;
        return true;
    }
}