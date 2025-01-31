// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A sample raffle contract
 * @author Kimy
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle is VRFConsumerBaseV2Plus {
    // ERRORS
    error Raffle__SendMoreToEnter();
    error Raffle__NotEnoughTimeHasPassed();
    error Raffle__TransferFailed();

    // STATE VARIABLES
    uint256 private s_lastTimeStamp;
    address payable[] private s_players; // payable address array
    address private s_recentWinner;
    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery (in seconds)
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash; // Gas lane
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint32 constant NUM_WORDS = 1; // No. of random numbers to get
    uint16 constant REQUEST_CONFIRMATIONS = 3; // After how many block confirmations, should we get our random numbers

    // EVENTS
    event RaffleEntered(address indexed player);

    // CONSTRUCTOR
    constructor(
        uint256 entranceFee, 
        uint256 interval, 
        address vrfCoordinator, 
        bytes32 gasLane, 
        uint256 subcriptionId,
        uint32 callbackGasLimit) 
    VRFConsumerBaseV2Plus(vrfCoordinator) { // SEPOLIA VRF COORDINATOR ADDRESS: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B
        s_lastTimeStamp = block.timestamp;
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subcriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    // MAIN FUNCTIONS
    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH!"); // NOT GAS EFFICIENT
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnter();
        }
        s_players.push(payable(msg.sender));
        // Makes migration easier, also makes front end "indexing" easier
        emit RaffleEntered(msg.sender);
    }

    // Requirements:
    // Get a random number,
    // Use it to pick a winner,
    // Also be automatically called
    function pickWinner() external {
        // Check if enough time has passed
        if((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert Raffle__NotEnoughTimeHasPassed();
        }
        // NOT FULLY UNDERSTOOD YET
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false})) // True: Sepolia ETH, False: LINK
            });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    // GETTER/VIEW FUNCTIONS
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }
}