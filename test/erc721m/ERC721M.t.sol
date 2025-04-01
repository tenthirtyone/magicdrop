// test/foundry/erc721m/ERC721M.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import {ERC721M} from "../../../contracts/nft/erc721m/ERC721M.sol";

contract ERC721MTest is Test {
    ERC721M public erc721m;

    address public owner;
    address public fundReceiver;
    uint256 public chainId;

    function setUp() public {
        owner = address(this);
        fundReceiver = makeAddr("fundReceiver");

        chainId = block.chainid;

        erc721m = new ERC721M(
            "Test",
            "TEST",
            "test/",
            1000,
            10,
            address(this),
            300,
            address(0),
            fundReceiver,
            0
        );
    }

    function testInitialState() public {
        assertEq(erc721m.name(), "Test");
        assertEq(erc721m.symbol(), "TEST");
        assertEq(erc721m.getMaxMintableSupply(), 1000);
        assertEq(erc721m.getGlobalWalletLimit(), 10);
        assertEq(erc721m.owner(), owner);
    }

    function testContractCanBePausedUnpaused() public {
        // starts unpaused
        assertTrue(erc721m.getMintable());

        erc721m.setMintable(false);
        assertFalse(erc721m.getMintable());

        erc721m.setMintable(true);
        assertTrue(erc721m.getMintable());
    }

    function testWithdrawByOwner() public {
        // Fund contract
        deal(address(erc721m), 100);

        uint256 fundReceiverBalanceBefore = address(fundReceiver).balance;

        // Owner withdraws
        erc721m.withdraw();

        // Funds should go to fundReceiver
        assertEq(address(erc721m).balance, 0);
        assertEq(
            address(fundReceiver).balance,
            fundReceiverBalanceBefore + 100
        );

        // Non-owner cannot withdraw
        address nonOwner = makeAddr("nonOwner");
        vm.prank(nonOwner);
        vm.expectRevert();
        erc721m.withdraw();
    }
}
