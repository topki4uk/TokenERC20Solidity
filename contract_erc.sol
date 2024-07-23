// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./erc_interface.sol";

contract ERC20 is IERC20 {
    address owner;
    uint8 tokenDecimals;
    uint256 tokenTotalSupply;

    string tokenName;
    string tokenSymbol;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    constructor(string memory _name, string memory _symbol, uint256 _ammount, uint8 _decimals) {
        owner = msg.sender;
        tokenName = _name;
        tokenSymbol = _symbol;
        tokenDecimals = _decimals;
        tokenTotalSupply = _ammount;

        balances[owner] = _ammount;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    modifier isEnough(uint256 _value) {
        require(balanceOf(msg.sender) >= _value, "Not enough tokens!");
        _;
    }

    modifier isAllowed(address _from, uint256 _value) {
        require(allowance(_from, msg.sender) >= _value, "Not enough tokens!");
        _;
    }

    function name() public view returns (string memory) {return tokenName;}
    function symbol() public view returns (string memory) {return tokenSymbol;}
    function decimals() public view returns (uint8) {return tokenDecimals;}
    function totalSupply() public view returns (uint256) {return tokenTotalSupply;}
    function balanceOf(address _owner) public view returns (uint256 balance) {return balances[_owner];}

    function mint(address _to, uint256 _value) public isOwner() {
        balances[_to] += _value;
        tokenTotalSupply += _value;

        emit Transfer(address(0), _to, _value);
    }

    function burn(uint256 _value) public isEnough(_value) {
        address _from = msg.sender;

        balances[_from] -= _value;
        balances[address(0)] += _value;

        emit Transfer(_from, address(0), _value);
    }

    function transfer(address _to, uint256 _value) public isEnough(_value) returns (bool success) {
        address _from = msg.sender;
        
        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public isAllowed(_from, _value) returns (bool success) {
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _value) public isEnough(_value) returns(bool) {
        address _from = msg.sender;
        uint256 approved = allowed[_from][_spender] + _value;

        allowed[_from][_spender] = approved;

        emit Approval(_from, _spender, approved);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _value) public returns(bool) {
        address _from = msg.sender;
        uint256 allowedBalance = allowance(_from, _spender);
        uint256 approved = 0;

        if (allowedBalance >= _value) 
            approved = allowedBalance - _value;
           
        allowed[_from][_spender] = approved;
        emit Approval(_from, _spender, approved);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}