// SPDX-License-Identifier: MIT
pragma solidity  0.8.18; // stating version of solodity to be used
// (^0.8.18 means that everything above this version woukld also work)
// (>=0.8.19 <0.9.0 means that everything between those versions will work)

contract SimpleStorage {
    uint256 internal myFavNum; // gets initilized with 0 when no value set
    
    // uint256[] internal favNumList;
    struct Person {
        uint256 favNum;
        string name;
    }

    // dynamic array
    Person[] public peopleList; // []

    mapping(string => uint256) public nameToFavNum;


    // static array
    // Person[3] public peopleList; // []

    // Person public pat = Person({favNum:7, name: "Pat"});

    function store(uint256 _favNum) public {
        myFavNum = _favNum;
    }

    // view, pure
    function retrieve() public view returns(uint256) {
        return myFavNum;
    }

    //(calldata, memory -> temporal signle call), storage
    function addPerson(string memory _name, uint256 _favNum) public {
        peopleList.push(Person(_favNum, _name));
        nameToFavNum[_name] = _favNum;
    }
}
