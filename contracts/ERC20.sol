// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// import "hardhat/console.sol";

contract ERC20 {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        _mint(msg.sender, 100e18);
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function transfer(address to, uint256 value)
        external
        returns (bool success)
    {
        return _transfer(msg.sender, to, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success) {
        require(
            allowance[from][msg.sender] >= value,
            "ERC20: transfer amount exceeds allowance"
        );

        allowance[from][msg.sender] -= value;

        emit Approval(from, msg.sender, allowance[from][msg.sender]); 

        return _transfer(from, to, value);
    }

    function approve(address spender, uint256 value)
        external
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function _transfer(
        address sender,
        address to,
        uint256 value
    ) private returns (bool success) {
        require(to != address(0), "ERC20: transfer to the zero address");

        require(
            balanceOf[sender] >= value,
            "ERC20: transfer amount exceeds balance"
        );

        balanceOf[sender] -= value;
        balanceOf[to] += value;

        emit Transfer(sender, to, value);

        return true;
    }

    function _mint(address to, uint256 value) internal {
        require(to != address(0), "ERC20: mint to the zero address");

        totalSupply += value;
        balanceOf[to] += value;

        emit Transfer(address(0), to, value);
    }
}
