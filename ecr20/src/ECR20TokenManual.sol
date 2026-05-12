// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

contract ECR20TokenManual {
    string private constant TOKEN_NAME = "Sword of Damocles Token";
    string private constant TOKEN_SYMBOL = "SoD";
    uint8 private constant TOKEN_DECIMALS = 18;
    uint256 private constant TOKEN_TOTAL_SUPPLY = 100 ether; // 100*10**18 =  10e20

    mapping (address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return TOKEN_NAME;
    }

    function symbol() public pure returns (string memory) {
        return TOKEN_SYMBOL;
    }

    function decimals() public pure returns (uint8) {
        return TOKEN_DECIMALS;
    }

    function totalSupply() public pure returns (uint256) {
        return TOKEN_TOTAL_SUPPLY;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }
    
    function transfer(address _to, uint256 _amount) public returns (bool success) {
        address _from = msg.sender;
        uint256 previousBalances = balanceOf(_from) + balanceOf(_to);
        s_balances[_from] -= _amount;
        s_balances[_to] += _amount;

        require(balanceOf(_from) + balanceOf(_to) == previousBalances);
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
    function approve(address _spender, uint256 _value) public returns (bool success) {}
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}

}