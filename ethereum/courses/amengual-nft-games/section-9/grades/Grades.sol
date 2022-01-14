// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.7.0;
pragma experimental ABIEncoderV2;

contract Grading {
    // Direccion del profesor
    address public teacher;
    // Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping(bytes32 => uint) public Grades;
    // Array de los alumnos que pidan revisiones de examen
    string[] public revisions;

    // Eventos
    event gradedStudent(bytes32, uint); 
    event revisionAsked(string);

    constructor() public {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    function evaluate(string memory _studentId, uint _grade) public onlyTeacher {
        // hash de la identificaion del alumno
        require(_grade >= 0, "Nota no puede ser negativa");
        require(_grade <= 10, "Nota no puede ser mayor que 10");
        bytes32 studentHash = keccak256(abi.encodePacked(_studentId));
        Grades[studentHash] = _grade;
        emit gradedStudent(studentHash, _grade);
    }

    function getGrade(string memory _studentId) public view returns(uint) {
        return Grades[keccak256(abi.encodePacked(_studentId))];
    }

    function askForRevision(string memory _studentId) public {
        revisions.push(_studentId);
        emit revisionAsked(_studentId);
    }

    function getRevisionRequests() public view onlyTeacher returns (string[] memory) {
        return revisions;
    }

    function revision(string memory _studentId, uint _grade) public {
        evaluate(_studentId, _grade);
    }

}