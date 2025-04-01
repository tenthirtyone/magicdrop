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

    /*
These bits belong in other unit tests but were part of the original Hardhat tests

  describe('Cosign', () => {
    it('can deploy with 0x0 cosign', async () => {
      

      // readonly contract can't set cosigner
      await expect(
        readonlyContract.setCosigner(cosigner.address),
      ).to.be.revertedWith('Unauthorized');
    });

    
  });
*/

    function testDeployment() public {
        assertEq(erc721m.getCosigner(), address(this));

        erc721m.getCosignDigest(owner, 1, false, 0, 0);
    }

    function testDeployment0x0Cosigner() public {
        address zeroAddress = address(0);
        address cosigner = address(1);

        ERC721M erc721mTest = new ERC721M(
            "Test",
            "TEST",
            "test/",
            1000,
            10,
            zeroAddress,
            300,
            zeroAddress,
            fundReceiver,
            0
        );

        vm.expectRevert();
        erc721mTest.getCosignDigest(owner, 1, false, 0, 0);

        erc721mTest.setCosigner(cosigner);
    }
}
