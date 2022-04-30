// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";
import "./REMYToken.sol";

contract Vendor is Ownable {
    // Token Contract
    REMYToken Remy;

    // token price for ETH
    uint256 public tokensPerEth = 100;

    // Event to log buy operation
    event BuyTokens(address buyer, uint256 amoutOfEth, uint256 amountOfTokens);

    constructor(address tokenAddress) {
        Remy = REMYToken(tokenAddress);
    }

    /**
     * @notice Allow users to buy token for ETH
     */
    function buyTokens() public payable returns (uint256 tokenAmount) {
        require(msg.value > 0, "Send ETH to buy some tokens");

        uint256 amountToBuy = msg.value * tokensPerEth;

        // check if the Vendor Contract has enough amount of tokens for the transaction
        uint256 vendorBalance = Remy.balanceOf(address(this));
        require(
            vendorBalance >= amountToBuy,
            "Vendor contract does not have enough tokens for this transaction"
        );

        // Transfer token(s) to the msg.sender
        bool sent = Remy.transfer(msg.sender, amountToBuy);
        require(sent, "Failed to transfer token to user");

        //emit the event
        emit BuyTokens(msg.sender, msg.value, amountToBuy);

        return amountToBuy;
    }

    /**
     * @notice Allow users to buy token for ETH
     */
    function sellTokens(uint256 tokenAmountToSell) public {
        // check that the requested amount of tokens to sell is more than 0
        require(
            tokenAmountToSell > 0,
            "Specify an amount of token greater than zero"
        );

        // check that the user's token balance is enough to do the swap
        uint256 userBalance = Remy.balanceOf(msg.sender);
        require(
            userBalance >= tokenAmountToSell,
            "Your balance is lower than the amount of tokens you want to sell"
        );

        // check that the vendor's balance is enough to do the swap
        uint256 amountOfETHToTransfer = tokenAmountToSell / tokensPerEth;
        uint256 ownerETHBalance = address(this).balance;
        require(
            ownerETHBalance >= amountOfETHToTransfer,
            "Vendor does not have enough funds to accept the sell request"
        );

        bool sent = Remy.transferFrom(
            msg.sender,
            address(this),
            tokenAmountToSell
        );
        require(sent, "Failed to transfer tokens from user to vendor");

        (sent, ) = msg.sender.call{value: amountOfETHToTransfer}("");
        require(sent, "Failed to send ETH to the user");
    }

    /**
     * @notice Allow contract owner to withdraw ETH
     */
    function withdraw() public onlyOwner {
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner has no balance to withdraw");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send user balance back to the owner");
    }
}
