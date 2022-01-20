// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.7.0;
pragma experimental ABIEncoderV2;

contract Grading {
    // Direccion del profesor
    address public teacher;
    // Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping(address => uint) public Grades;
    // Array de los alumnos que pidan revisiones de examen
    address[] public revisions;

    // Eventos
    event gradedStudent(address, uint); 
    event revisionAsked(address);

    constructor() public {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    function evaluate(address _studentAddress, uint _grade) public onlyTeacher {
        // hash de la identificaion del alumno
        require(_grade >= 0, "Nota no puede ser negativa");
        require(_grade <= 10, "Nota no puede ser mayor que 10");
        Grades[_studentAddress] = _grade;
        emit gradedStudent(_studentAddress, _grade);
    }

    function getGrade(address _studentAddress) public view returns(uint) {
        return Grades[_studentAddress];
    }

    function askForRevision() public {
        revisions.push(msg.sender);
        emit revisionAsked(msg.sender);
    }

    function getRevisionRequests() public view onlyTeacher returns (address[] memory) {
        return revisions;
    }

    function revision(address _studentAddress, uint _grade) public {
        evaluate(_studentAddress, _grade);
    }

}