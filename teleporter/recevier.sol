// SPDX-License-Identifier: Ecosystem

pragma solidity 0.8.18;

import "https://github.com/ava-labs/teleporter/blob/main/contracts/src/Teleporter/upgrades/TeleporterRegistry.sol";
import "https://github.com/ava-labs/teleporter/blob/main/contracts/src/Teleporter/ITeleporterMessenger.sol";
import "https://github.com/ava-labs/teleporter/blob/main/contracts/src/Teleporter/ITeleporterReceiver.sol";

contract ReceiverOnDispatchWithRegistry is ITeleporterReceiver {

    // The Teleporter registry contract manages different Teleporter contract versions.
    TeleporterRegistry public immutable teleporterRegistry;
    bytes32 public myOriginChainID;
    address public myOriginSenderAddress;

      constructor(address teleporterRegistryAddress) {
        require(
            teleporterRegistryAddress != address(0),
            "SenderOnCChain: zero teleporter registry address"
        );

        teleporterRegistry = TeleporterRegistry(teleporterRegistryAddress);
    }

    string public lastMessage;

    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
        myOriginChainID = originChainID;
        myOriginSenderAddress = originSenderAddress;
        // Only the Teleporter receiver can deliver a message. Function throws an error if
        // msg.sender is not registered
        teleporterRegistry.getVersionFromAddress(msg.sender);

        // Store the message.
        lastMessage = abi.decode(message, (string));
    }

    function getBlockchainId() public view returns (bytes32) {
        return teleporterRegistry.blockchainID();
    }
}