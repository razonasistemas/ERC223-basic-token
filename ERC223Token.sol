pragma solidity ^0.4.9;

 /**
 * ERC23 basic token by EthereumToolbox
 * Based in the previous work by Dexaran
 * https://github.com/Dexaran/ERC23-tokens
 */

// Used when the receiver of the funds are a contract
 contract ContractReceiver {
    struct TKN {
        address sender;
        uint value;
        bytes data;
        bytes4 sig;
    }

    function tokenFallback(address _from, uint _value, bytes _data){
      TKN memory tkn;
      tkn.sender = _from;
      tkn.value = _value;
      tkn.data = _data;
      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
      tkn.sig = bytes4(u);

      /* tkn variable is analogue of msg variable of Ether transaction
      *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
      *  tkn.value the number of tokens that were sent   (analogue of msg.value)
      *  tkn.data is data of token transaction   (analogue of msg.data)
      *  tkn.sig is 4 bytes signature of function
      *  if data of token transaction is a function execution
      */
    }
 }

 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
contract SafeMath {
    uint256 constant public MAX_UINT256 =
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
        require (x <= MAX_UINT256 - y);
        return x + y;
    }

    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
        require (x >= y);
        return x - y;
    }

    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
        if (y == 0) return 0;
        require (x <= MAX_UINT256 / y);
        return x * y;
    }
}

// Basic token.
contract ERC223Token is SafeMath {

  mapping(address => uint) balances;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);

  function ERC223Token(uint256 initialSupply)
  {
    totalSupply = initialSupply; // In the file 2_deploy_contracts.js this constructor is called and the initial supply is set
    balances[msg.sender] += initialSupply; // the supply is assigned to the caller.
  }

  // Function that is called when a user or another contract wants to transfer funds.
  // If the _to parameter is a contract the ether sent will be lost forever if not
  // prepared to receive it with a fallback method.
  function transfer(address _to, uint _value, bytes _data) returns (bool success) {
    if(isContract(_to)) {
        return transferToContract(_to, _value, _data);
    }
    else {
        return transferToAddress(_to, _value, _data);
    }
  }

  // Standard function transfer similar to ERC20 transfer with no _data .
  // Added due to backwards compatibility reasons.
  function transfer(address _to, uint _value) returns (bool success) {
    bytes memory empty;
    if(isContract(_to)) {
        return transferToContract(_to, _value, empty);
    }
    else {
        return transferToAddress(_to, _value, empty);
    }
  }

  //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
  function isContract(address _addr) private returns (bool is_contract) {
      uint size;
      assembly {
            //retrieve the size of the code on target address, this needs assembly
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

  //function that is called when transaction target is an address
  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
    require (balanceOf(msg.sender) >= _value);
    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
    balances[_to] = safeAdd(balanceOf(_to), _value);
    Transfer(msg.sender, _to, _value, _data);
    return true;
  }

  //function that is called when transaction target is a contract
  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
    require (balanceOf(msg.sender) >= _value);
    balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
    balances[_to] = safeAdd(balanceOf(_to), _value);
    ContractReceiver receiver = ContractReceiver(_to);
    // The fallback method is called and if the token has not been prepared to receive funds
    // it returns an error and no ether is sent.
    receiver.tokenFallback(msg.sender, _value, _data);
    Transfer(msg.sender, _to, _value, _data);
    return true;
  }

  function balanceOf(address _owner) constant returns (uint balance) {
    return balances[_owner];
  }
} // end of contract
