// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {AtomicBridgeInitiator} from "../src/AtomicBridgeInitator.sol";
import {WETH10} from "../src/WETH/WETH10.sol"; 

contract AtomicBridgeInitiatorTest is Test {
    AtomicBridgeInitiator public atomicBridgeInitiator;
    WETH10 public weth;

    address public originator = address(1);
    address public recipient = address(2);
    bytes32 public hashLock = keccak256(abi.encodePacked("secret"));
    uint public amount = 1 ether;
    uint public timeLock = 100;

    function setUp() public {
        // Deploy the WETH contract
        weth = new WETH10();
        // Deploy the AtomicBridgeInitiator contract with the WETH address
        atomicBridgeInitiator = new AtomicBridgeInitiator(address(weth));
    }

    function testInitiateBridgeTransfer() public {
        vm.deal(originator, 1 ether);
        vm.startPrank(originator);

        bytes32 bridgeTransferId = atomicBridgeInitiator.initiateBridgeTransfer{value: amount}(
            0, // _wethAmount
            originator,
            recipient,
            hashLock,
            timeLock
        );

        (
            bool exists, 
            uint transferAmount,  
            address transferOriginator, 
            address transferRecipient,
            bytes32 transferHashLock,
            uint transferTimeLock 
        ) = atomicBridgeInitiator.getBridgeTransferDetail(bridgeTransferId);

        assertTrue(exists);
        assertEq(transferAmount, amount);
        assertEq(transferOriginator, originator);
        assertEq(transferRecipient, recipient);
        assertEq(transferHashLock, hashLock);
        assertGt(transferTimeLock, block.timestamp);

        vm.stopPrank();
    }

    function testCompleteBridgeTransfer() public {
        bytes32 secret = "secret";
        bytes32 testHashLock = keccak256(abi.encodePacked(secret));

        vm.deal(originator, 1 ether);
        vm.startPrank(originator);

        bytes32 bridgeTransferId = atomicBridgeInitiator.initiateBridgeTransfer{value: amount}(
            0, // _wethAmount
            originator, 
            recipient, 
            testHashLock, 
            timeLock
        );

        vm.stopPrank();

        vm.startPrank(recipient);
        atomicBridgeInitiator.completeBridgeTransfer(bridgeTransferId, secret);

        (bool exists,,,,,) = atomicBridgeInitiator.getBridgeTransferDetail(bridgeTransferId);
        assertFalse(exists);

        (
            bool completedExists, 
            uint completedAmount, 
            address completedOriginator, 
            address completedRecipient, 
            bytes32 completedHashLock, 
            uint completedTimeLock 
        ) = atomicBridgeInitiator.getCompletedBridgeTransferDetail(bridgeTransferId);
        assertTrue(completedExists);
        assertEq(completedAmount, amount);
        assertEq(completedOriginator, originator);
        assertEq(completedRecipient, recipient);
        assertEq(completedHashLock, testHashLock);
        assertGt(completedTimeLock, block.timestamp);

        vm.stopPrank();
    }

    function testRefundBridgeTransfer() public {
        vm.deal(originator, 1 ether);
        vm.startPrank(originator);

        bytes32 bridgeTransferId = atomicBridgeInitiator.initiateBridgeTransfer{value: amount}(
            0, // _wethAmount
            originator, 
            recipient, 
            hashLock, 
            timeLock
        );

        vm.stopPrank();

        vm.warp(block.timestamp + timeLock + 1);
        vm.startPrank(originator);
        atomicBridgeInitiator.refundBridgeTransfer(bridgeTransferId);

        (bool exists,,,,,) = atomicBridgeInitiator.getBridgeTransferDetail(bridgeTransferId);
        assertFalse(exists);

        vm.stopPrank();
    }
}

