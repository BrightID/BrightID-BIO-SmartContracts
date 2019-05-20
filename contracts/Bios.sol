pragma solidity ^0.4.24;
import "./openzeppelin/contracts/ownership/Ownable.sol";


contract Bios is Ownable {

    mapping(address => bool) public recivedBio;
    mapping(address => bool) public bioTokens;
    mapping(address => bool) public nodes;

    string private constant BIOS_CONTRACT_ONLY = "BIOS_CONTRACT_ONLY";
    string private constant INVALID_ADDRESS = "INVALID_ADDRESS";

    /// Events
    event LogRecivedBio(address userAddress, bytes32 token);
    event LogRemoveNode(address bioAddress);
    event LogRemoveBio(address bioAddress);
    event LogAddNode(address bioAddress );
    event LogAddBio(address bioAddress );

    /**
     * @notice Set userAddress received BIO token.
     * @param userAddress The user's address.
     */
    function setReceivedBio(address userAddress)
        external
        onlyBioTokens
        returns(bool ret)
    {
        recivedBio[userAddress] = true;
	    emit LogRecivedBio(userAddress, 'BIO');
        return true;
    }

    /**
     * @notice Check whether userAddress received his BIO token.
     * @param userAddress The user's address.
     */
    function isReceivedBIO(address userAddress)
        external
        view
        returns(bool ret)
    {
        return recivedBio[userAddress];
    }

    /**
     * @notice Add a approved node.
     * @param nodeAddress The node's address.
     */
    function addNode(address nodeAddress)
        external
        onlyOwner
    {
        require(nodeAddress != address(0), INVALID_ADDRESS);
        nodes[nodeAddress] = true;
        emit LogAddNode(nodeAddress);
    }

    /**
     * @notice Remove the node.
     * @param nodeAddress The node's address.
     */
    function removeNode(address nodeAddress)
        external
        onlyOwner
    {
        nodes[nodeAddress] = false;
        emit LogRemoveNode(nodeAddress);
    }

    /**
     * @notice Check whether `nodeAddress` is an acceptable node.
     * @param nodeAddress The node's address.
     */
    function isNode(address nodeAddress)
        public
        view
        returns(bool ret)
    {
        return nodes[nodeAddress];
    }

    /**
     * @notice Add a BIO token address.
     * @param bioAddress The BIO's address.
     */
    function addBio(address bioAddress)
        external
        onlyOwner
    {
        require(bioAddress != address(0), INVALID_ADDRESS);
        bioTokens[bioAddress] = true;
        emit LogAddBio(bioAddress);
    }

    /**
     * @notice Remove the BIO token address.
     * @param bioAddress The BIO's address.
     */
    function removeBio(address bioAddress)
        external
        onlyOwner
    {
        bioTokens[bioAddress] = false;
        emit LogRemoveBio(bioAddress);
    }

    /**
     * @dev Throws if called by any account other than the BIOs' smart contract.
     */
    modifier onlyBioTokens() {
        require(bioTokens[msg.sender], BIOS_CONTRACT_ONLY);
        _;
    }
}
