//
//  Rvalue.cpp
//  Debug
//
//  Created by kakiYen on 2019/11/29.
//

/*
 左值：不是一个表达式，是确实存在内存地址的一个实体变量，具有变量名。
 右值：是一个表达式，是临时为了计算被寄存在内存中的，计算完后会被立即丢弃，没有变量名。
 右值引用是用来支持转移语义的。转移语义可以将资源 ( 堆，系统对象等 ) 从一个对象转移到另一个对象，这样能够减少不必要的临时对象的创建、拷贝以及销毁，能够大幅度提高 C++ 应用程序的性能。临时对象的维护 ( 创建和销毁 ) 对性能有严重影响。
 */

#include "Rvalue.hpp"

Rvalue::Rvalue(){
    
}

Rvalue::~Rvalue(){
    
}

Rvalue::Rvalue(const Rvalue &rvalue){
    
}

Rvalue & Rvalue::operator=(const Rvalue &rvalue){
    return *this;
}

Rvalue * Rvalue::operator&(){
    return this;
}

const Rvalue * Rvalue::operator&()const{
    return this;
}

Rvalue::Rvalue(Rvalue &&rvalue){
    
}

Rvalue & Rvalue::operator=(const Rvalue &&rvalue){
    return *this;
}

Rvalue::Rvalue(char *value, int index) : index(index), value(value){
    printf("value = %s, index = %d\n", this->value, this->index);
}
