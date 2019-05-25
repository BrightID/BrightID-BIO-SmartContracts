pragma solidity ^0.4.23;

import "./openzeppelin/contracts/token/ERC721/ERC721Token.sol";
import "./openzeppelin/contracts/ownership/Ownable.sol";

contract NonFungibleBIO is ERC721Token, Ownable {
    string public constant NAME = "NonFungibleBIO";
    string public constant SYMBOL = "NFBIO";

    struct TokenDetail {
        address user;
        uint256 timestmap;
    }

    TokenDetail[] public tokenDetails;

    constructor ()
        public
        ERC721Token(NAME, SYMBOL)
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
    {
        uint256 timestamp = uint256(now);
        string timestampString = timestamp2string(timestamp);
        TokenDetail memory _detail = TokenDetail({user: userAddress, timestmap: timestamp });
        uint256 tokenId = tokenDetails.push(_detail) - 1;

        super._mint(userAddress, tokenId);
        super._setTokenURI(tokenId, timestampString);
    }

    /**
     * @dev Get the token details.
     * @param tokenId The token's id.
     */
    function getTokenDetail(uint256 tokenId)
        external
        view
        returns(address user, uint256 timestmap)
    {
        TokenDetail memory _detail = tokenDetails[tokenId];
        user = _detail.user;
        timestmap = _detail.timestmap;
    }
}