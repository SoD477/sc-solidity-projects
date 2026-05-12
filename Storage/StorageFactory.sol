// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory{

    SimpleStorage[] public simpleStorageList;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        simpleStorageList.push(newSimpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, string calldata _name, uint256 _favNum) public {
        SimpleStorage mySimpleStorage = simpleStorageList[_simpleStorageIndex];
        mySimpleStorage.store(_name, _favNum);
    }

    function sfGet(uint256 _simpleStorageIndex, address owner) public view returns(string memory name, uint256 favNum){
        SimpleStorage mySimpleStorage = simpleStorageList[_simpleStorageIndex];
        (name, favNum) = mySimpleStorage.get(owner);
    }
}