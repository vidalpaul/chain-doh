// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract A {
    int public x = 10;
    int y = 20; // internal 
    int internal w = 30;
    int private z = 40;


    function get_y() public view returns (int) {
        return y;
    }  

    function f1() private view returns(int){
        return w;
    }

    function f2() public view returns (int) {
        int a;
        a = f1();
        return a;
    }

    function f3() public view returns (int) {
        return x;
    }

    function f4() external view returns (int){
        // external functions are more efficient than public functions in terms of gas consumption
        return x;
    }

    function f5() public pure returns(int){
        int b;
        // b = f4(); error because f4 is external
        return b;
    }
}

contract B is A {
    int public xx = f3();
    // int public yy = f1(); f1 is private and cannot be called from derived contracts
}

contract C {
    A public contract_a = new A();
    int public xx = contract_a.f4();
    // int public y = contract_a.f1();
    // int public y = contract_a.f1();
}