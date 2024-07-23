// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;


interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);

    function mint(address, uint256) external;
    function burn(uint256) external;
    function balanceOf(address) external view returns (uint256);

    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);

    // function approve(address, uint256) external returns (bool);
    function increaseAllowance(address, uint256) external returns(bool);
    function decreaseAllowance(address, uint256) external returns(bool);
    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _spender, uint256 _value);
}
