// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AgentraRegistry.sol";
import "../src/Agentra.sol";

contract DeployAgentra is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // The wallet running the script becomes the fee collector and Admin
        address feeCollector = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy the Immutable Registry
        AgentraRegistry registry = new AgentraRegistry();

        // 2. Deploy Agentra (V1) pointing to the Registry
        Agentra agentra = new Agentra(feeCollector, address(registry));

        // 3. Authorize Agentra V1 to write to the Registry
        registry.authorizeContract(address(agentra));

        vm.stopBroadcast();

        // 4. Output both addresses to temp_addresses.json for the frontend
        string memory json = string.concat(
            "{",
            "\"Agentra\": \"", vm.toString(address(agentra)), "\",",
            "\"AgentraRegistry\": \"", vm.toString(address(registry)), "\"",
            "}"
        );
        vm.writeFile("./temp_addresses.json", json);

        console.log("=================================================");
        console.log("Arbitrum Deployment Successful!");
        console.log("Registry Address: ", address(registry));
        console.log("Agentra V1 Address: ", address(agentra));
        console.log("=================================================");
    }
}