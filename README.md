# Ether Basics: Wei, Gas, and ETH Transfers

This repo contains small Solidity examples for three core Ethereum concepts:

- `EtherUnits.sol`: how Solidity represents ETH values in `wei` and `ether`
- `Gas.sol`: what gas is and why unbounded execution runs out of gas
- `Transfer.sol`: the starting point for sending and receiving ETH in a contract

## Summary

### Wei and Ether

- `wei` is the smallest unit of Ether
- `1 ether = 10^18 wei`
- Solidity supports unit suffixes such as `1 wei` and `1 ether` to make value handling clearer and safer

This matters because all ETH accounting on-chain is ultimately done in `wei`.

### Gas

- Gas is the unit used to measure EVM computation
- Every transaction consumes gas based on the work performed
- Total transaction cost is based on gas used and gas price
- If execution consumes all available gas, the transaction reverts

The `forever()` example demonstrates this: an infinite loop keeps spending gas until the transaction fails.

## ETH Transfer Best Practice

The current best practice is to use low-level `call` carefully and defensively:

```solidity
(bool ok, ) = payable(to).call{value: amount}("");
require(ok, "ETH transfer failed");
```

Why this is preferred:

- it works with modern smart contract wallets and recipients that need more than the old fixed gas stipend
- it makes failure explicit by returning `success`
- it is the recommended replacement for older `transfer` / `send` assumptions

But `call` is only safe when you structure the surrounding logic correctly.

## Vulnerable ETH Transfer With `.call`

A dangerous pattern looks like this:

```solidity
function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "nothing to withdraw");

    (bool ok, ) = payable(msg.sender).call{value: amount}("");
    require(ok, "transfer failed");

    balances[msg.sender] = 0;
}
```

This is vulnerable to reentrancy.

### Why it is vulnerable

When a contract sends ETH using `.call`, control is handed to the recipient. If the recipient is a malicious contract, its `receive()` or `fallback()` function can call back into `withdraw()` before `balances[msg.sender] = 0` executes.

That means:

- the attacker receives ETH
- re-enters `withdraw()`
- still sees the old balance
- withdraws again

This can repeat until the vulnerable contract is drained.

## Safer Pattern

Use the checks-effects-interactions pattern:

```solidity
function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "nothing to withdraw");

    balances[msg.sender] = 0;

    (bool ok, ) = payable(msg.sender).call{value: amount}("");
    require(ok, "transfer failed");
}
```

Why this is safer:

- checks happen first
- state is updated before the external call
- even if the recipient re-enters, the balance is already zero

For stronger protection, combine this with a reentrancy guard when appropriate.
