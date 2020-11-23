//
//  Rvalue.hpp
//  Debug
//
//  Created by kakiYen on 2019/11/29.
//

#ifndef Rvalue_hpp
#define Rvalue_hpp

#include <stdio.h>

/*
 编译器为 C++类 生成的默认函数
 1、默认构造函数
 2、默认析构函数
 3、默认拷贝构造函数[浅拷贝]
 4、默认重载赋值运算符 = 函数
 5、默认重载取址运算符 & 函数
 6、默认重载取址运算符 const & 函数
 7、默认移动构造函数
 8、默认重载赋值移动运算符 = 函数
 
 constexpr：指明变量为常量表达式。
 */

class Rvalue {
    int index;
    char *value;
public:
    Rvalue();    //1
    ~Rvalue();   //2
    Rvalue(const Rvalue &rvalue);  //3
    Rvalue & operator = (const Rvalue &rvalue);    //4
    Rvalue * operator & ();  //5
    const Rvalue * operator & () const;  //6
    Rvalue(Rvalue &&rvalue);   //7
    Rvalue & operator = (const Rvalue &&rvalue);    //8
    
    Rvalue(char *value, int index = 0);
};

#endif /* Rvalue_hpp */
