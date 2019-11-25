//
//  main.m
//  Debug
//
//  Created by kakiYen on 2019/7/16.
//

#import <Foundation/Foundation.h>
#import "HelloWorld.h"

/*
 左值：不是一个表达式，是确实存在内存地址的一个实体变量，具有变量名。
 右值：是一个表达式，是临时为了计算被寄存在内存中的，计算完后会被立即丢弃，没有变量名。
 右值引用是用来支持转移语义的。转移语义可以将资源 ( 堆，系统对象等 ) 从一个对象转移到另一个对象，这样能够减少不必要的临时对象的创建、拷贝以及销毁，能够大幅度提高 C++ 应用程序的性能。临时对象的维护 ( 创建和销毁 ) 对性能有严重影响。
 */
class Person{
public:
    char name[5] = "";
    Person(){
        strcpy(name, "Fuck");
        NSLog(@"Holy shit");
    }
    Person(int *tempInt){
        NSLog(@"Holy shit : %d",*tempInt);
    }
    Person(Person &person){
    }
    Person(Person && person){
        memcpy(name, person.name, 4);
        NSLog(@"Fuck down : %s",name);
        memset(person.name, 0, 5);
    }
    Person &operator = (Person && person){
        memcpy(name, person.name, 4);
        NSLog(@"Fuck down : %s",name);
        memset(person.name, 0, 5);
        return *this;
    }
};

/*
 由于是右值返回，所以在栈中临时定义或创建的对象，并没有真正拷贝的堆中，在再次访问的时候，该临时定义或创建的对象内存已被覆盖了。
 */
//Person *&& returnPerson(){
//    Person temp = Person();
//    return &temp;
//}
void logPerson(Person && person){
    NSLog(@"%s",person.name);
}

GoodByeWorld *returnValue(){
    /*
     此时的引用计数为1，但实际上isa.extra_rc = 0。
     */
    GoodByeWorld *temp = [[GoodByeWorld alloc] init];
    return temp;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        /*
         此时的引用计数为2，但实际上isa.extra_rc = 1，这符合ARC。
         因为 ARC 模式下，会默认插入一句 retain。
         */
        GoodByeWorld *temp = returnValue();
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 512; i++) {
            [tempArray addObject:temp];
        }
        /*
         等价于 GoodByeWorld *GB = [[GoodByeWorld alloc] init];    //引用计数为1
                GoodByeWorld *temp = GB;    //引用计数为2
                <--[temp retain]-->
         */
        [temp goodByeWorld];
        
        int tempInt = 100;
        logPerson(&tempInt);
        
        Person tempPerson;
        tempPerson = Person();
//        logPerson(Person());
//        Person *t = returnPerson();
//        NSLog(@"%s",t->name);
    }
    return 0;
}
