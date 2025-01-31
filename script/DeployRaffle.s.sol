// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "src/Raffle.sol";

contract DeployRaffle is Script {
    uint256 constant ENTRANCE_FEE = 1e13; // 0.00001 ETH
    uint256 constant TIME_INTERVAL = 60; // 60 seconds = 1 minute

    function run() external {
        vm.startBroadcast();
        // new Raffle(ENTRANCE_FEE, TIME_INTERVAL);
        vm.stopBroadcast();
    }
}