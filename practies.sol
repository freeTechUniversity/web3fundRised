// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
contract Parcties{
    //payable in solidity
      enum Day {Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday}

    Day public selectedDay;

    function setDay(Day _day) public {
        selectedDay = _day;
    }

    function getDay() public view returns (Day) {
        return selectedDay;
    }
}