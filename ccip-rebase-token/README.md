# Cross-chain Rebase Token

1. A protocol that allows users to deposit into a vault and, in return, receive rebase tokens that represent their underlying balance.
2. Rebase token -> the balanceOf function is dynamic and shows the changing balance over time.
    - Balance increases linearly with time.
    - Mint tokens to users every time they perform an action (minting, burning, transferring, or bridging).
3. Interest rate
    - Set an individual interest rate for each user based on the protocol's global rate at the time the user deposits into the vault.
    - This global interest rate can only decrease to incentivize/reward early adopters.
    - Inrease token adoption