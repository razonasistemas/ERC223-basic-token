# ERC223 token standard implementation.

ERC223 is a modification of the ERC20 token standard. It is backwards compatible with ERC20 tokens. This means that ERC223 supports every ERC20 functional and contracts or services working with ERC20 tokens will work with ERC223 tokens correctly.

Please read the definition of the standard here : https://github.com/Dexaran/ERC223-token-standard. Also watch this explicative video : https://www.youtube.com/watch?v=GS62VNyPVHs

### The main goal of developing ERC223 token standard is:
   Accidentally lost tokens inside contracts: there are two different ways to transfer ERC20 tokens depending on: 1) is the receiver address a contract, or 2) a wallet address. You should call `transfer` to send tokens to a wallet address or call `approve` on token contract then `transferFrom` on receiver contract to send tokens to contract. Accidentally, a call of `transfer` function to a contract address will cause a loss of tokens inside receiver contract where tokens will never be accessibe.

  This is not a minor issue because af you could see in the following links, some ICOs has lost tokens for thousands of USD. There are no way to recover that funds.

  GNT in Golem contract ~ $86,016:
  https://etherscan.io/token/Golem?a=0xa74476443119a942de498590fe1f2454d7d4ac0d

  DGD in Digix DAO contract ~ $60,334:
  https://etherscan.io/token/0xe0b7927c4af23765cb51314a0e0521a9645f0e2a?a=0xe0b7927c4af23765cb51314a0e0521a9645f0e2a

### ERC223 advantages.
  1. Provides the possibility of avoiding accidentally lost tokens inside contracts that are not designed to work with sent tokens.
  2. Allows users to send their tokens anywhere with one function `transfer`. There is no difference between whether the receiver is a contract or not. There's no need to learn how a token contract is working for a regular user to send tokens.
  3. Allows contract developers to handle incoming token transactions.
  4. ERC223 `transfer` to contract consumes 2 times less gas than ERC20 `approve` and `transferFrom` at receiver contract.
  5. Allows to deposit tokens intor contract with a single transaction. Prevents extra blockchain bloating.
  6. Makes token transactions similar to Ether transactions.
