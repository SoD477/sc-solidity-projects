// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage{
    mapping(address => Person) private addressToPerson;
    
    // overrides
    // virtual or override 
    function store(string calldata _name, uint256 _favNum) public override {
        Person memory newPerson = Person({name: _name, favNum: _favNum + 5});
        addressToPerson[tx.origin] = newPerson;
    }

    function get(address owner) public view override returns(string memory, uint256){
        Person memory p = addressToPerson[owner];
        return (p.name, p.favNum);
    }
}