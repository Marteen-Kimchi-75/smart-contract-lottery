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

    uint256 immutable i_entranceFee;

    constructor(uint entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH!"); // NOT GAS EFFICIENT
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnter();
        }
    }

    function pickWinner() public {

    }

    // GETTER FUNCTIONS
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }
}