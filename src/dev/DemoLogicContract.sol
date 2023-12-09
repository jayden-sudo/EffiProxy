// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DemoLogicContract {
    mapping(uint256 => bytes32) public data;

    function getData(uint256 key) external view returns (bytes32) {
        return data[key];
    }

    function setData(uint256 key, bytes32 value) external {
        require(key != 0, "key cannot be 0");
        data[key] = value;
    }
}
