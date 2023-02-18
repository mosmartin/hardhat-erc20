// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// import "hardhat/console.sol";

contract ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function transfer(address _to, uint256 _value)
        external
        returns (bool success)
    {
        require(_to != address(0), "ERC20: transfer to the zero address");

        require(balanceOf[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        return true;
    }
}
