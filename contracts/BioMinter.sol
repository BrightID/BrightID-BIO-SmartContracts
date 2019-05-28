pragma solidity ^0.5.0;

import "./openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./openzeppelin/contracts/ownership/Ownable.sol";
import "./BioToken.sol";
import "./Finance.sol";
import "./NonFungibleBIO.sol";


/**
 * @title BIO token minter contract.
 */
contract BioMinter is Ownable {

    BioToken internal bioToken;
    ERC20 internal paymentToken;
    Finance internal finance;
    NonFungibleBIO internal nonFungibleBioToken;

    uint256 constant public PRICE = 10**18;
    uint256 constant public UNIT = 10**18;
    address constant public NODE = 0x0;
    string constant public TOKEN_SYMBOL = "BIO";

    string private constant INSUFFICIENT_PAYMENT = "INSUFFICIENT_PAYMENT";
    string private constant RECIVED_BIO_BEFORE = "RECIVED_BIO_BEFORE";
    string private constant INCOMPATIBLE_NODE = "INCOMPATIBLE_NODE";
    string private constant BAD_SIGNATURE = "BAD_SIGNATURE";
    string private constant APPROVE_ERROR = "APPROVE_ERROR";
    string private constant MINT_ERROR = "MINT_ERROR";
    string private constant USER_NA = "USER_N/A";

    mapping(address => bool) public recivedBio;

    event Buy(address buyer, uint256 price);

    constructor(address bioTokenAddress, address nonFungibleBioAdrr, address paymentTokenAddr, address financeAddress)
        public
    {
        bioToken = BioToken(bioTokenAddress);
        finance = Finance(financeAddress);
        paymentToken = ERC20(paymentTokenAddr);
        nonFungibleBioToken = NonFungibleBIO(nonFungibleBioAdrr);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferTokenOwnership(address newOwner)
        external
        onlyOwner
    {
        bioToken.transferOwnership(newOwner);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferNonFungibleOwnership(address newOwner)
        external
        onlyOwner
    {
        nonFungibleBioToken.transferOwnership(newOwner);
    }

    /**
     * @notice Set DAO finance.
     * @param financeAddr The DAO finance's address.
     */
    function setFinance(address financeAddr) external onlyOwner {
        finance = Finance(financeAddr);
    }

    /**
     * @notice Buy BIO token.
     * @param r signature's r.
     * @param s signature's s.
     * @param v signature's v.
     */
    function buy(
        bytes32 r,
        bytes32 s,
        uint8 v)
        external
    {
        require(!recivedBio[msg.sender], RECIVED_BIO_BEFORE);

        uint256 allowance = paymentToken.allowance(msg.sender, address(this));
        require(allowance <= PRICE, INSUFFICIENT_PAYMENT);

        address signerAddress = signer(r, s, v, msg.sender);
        require(signerAddress != address(0), BAD_SIGNATURE);
        require(signerAddress == NODE, INCOMPATIBLE_NODE);

        if (paymentToken.transferFrom(msg.sender, address(this), PRICE)) {
            require(paymentToken.approve(address(finance), PRICE), APPROVE_ERROR);
            finance.deposit(address(paymentToken), PRICE, "Sell BIO Revenue");
            emit Buy(msg.sender, PRICE);
            recivedBio[msg.sender] = true;
            require(bioToken.mint(msg.sender, UNIT), MINT_ERROR);
            require(nonFungibleBioToken.mint(msg.sender), MINT_ERROR);
        }
    }

    /**
     * @dev Find the signer of a signature.
     * @param r signature's r.
     * @param s signature's s.
     * @param v signature's v.
     * @param userAddress The user address.
     */
    function signer(
        bytes32 r,
        bytes32 s,
        uint8 v,
        address userAddress)
        internal
        pure
        returns(address addr)
    {
        bytes32 message = keccak256(abi.encode(userAddress, TOKEN_SYMBOL));
        return ecrecover(message, v, r, s);
    }
}
