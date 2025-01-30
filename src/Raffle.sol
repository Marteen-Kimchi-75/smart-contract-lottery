// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title A sample raffle contract
 * @author Kimy
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    // ERRORS
    error Raffle__SendMoreToEnter();
    error Raffle__NotEnoughTimeHasPassed();

    // STATE VARIABLES
    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery (in seconds)
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    address payable[] private s_players; // payable address array

    // EVENTS
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
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
    }

    // GETTER/VIEW FUNCTIONS
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }
}