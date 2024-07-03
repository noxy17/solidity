// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentGrades {
    address public owner;
    
    struct Grade {
        string studentName;
        string subject;
        uint8 grade;
    }

    Grade[] public grades;

    mapping(string => mapping(string => uint8)) studentGrades;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addGrade(string memory _studentName, string memory _subject, uint8 _grade) public onlyOwner {
        require(_grade <= 100, "Grade must be between 0 and 100");
        grades.push(Grade(_studentName, _subject, _grade));
        studentGrades[_studentName][_subject] = _grade;
    }

    function updateGrade(string memory _studentName, string memory _subject, uint8 _newGrade) public onlyOwner {
        require(_newGrade <= 100, "Grade must be between 0 and 100");
        bool gradeFound = false;
        
        for (uint i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].studentName)) == keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                grades[i].grade = _newGrade;
                gradeFound = true;
                break;
            }
        }
        
        require(gradeFound, "Grade entry not found");
        studentGrades[_studentName][_subject] = _newGrade;
    }

    function getGrade(string memory _studentName, string memory _subject) public view returns (uint8) {
        return studentGrades[_studentName][_subject];
    }

    function averageGrade(string memory _subject) public view returns (uint8) {
        uint total = 0;
        uint count = 0;

        for (uint i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                total += grades[i].grade;
                count++;
            }
        }

        require(count > 0, "No grades found for the given subject");
        return uint8(total / count);
    }
}
