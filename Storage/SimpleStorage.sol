// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract SimpleStorage {

    struct Person{
        string name;
        uint256 favNum;
    }

    mapping(address => Person) private addressToPerson;

    // virtaul functions can be override
    function store(string calldata _name, uint256 _favNum) public virtual{
        Person memory newPerson = Person({name: _name, favNum: _favNum});
        addressToPerson[tx.origin] = newPerson; // tx.origin is insecure use explicit allowlists or EIP-1271-style signatures
    }

    function get(address owner) public view virtual returns(string memory, uint256){
        Person memory p = addressToPerson[owner];
        return (p.name, p.favNum);
    }
}