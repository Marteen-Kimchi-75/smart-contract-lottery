// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployRaffle is Script {
    uint256 constant ENTRANCE_FEE = 1e13; // 0.00001 ETH
    uint256 constant TIME_INTERVAL = 60; // 60 seconds = 1 minute

    function run() external {}

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval, 
            config.vrfCoordinator, 
            config.gasLane,
            config.subcriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfig);
    }
}