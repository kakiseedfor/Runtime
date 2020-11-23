//
//  main.m
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import "Rvalue.hpp"
#import "LGPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
//        LGPerson *person = [LGPerson alloc];
//        [person sayHello];
//        [person say666];
        char value[] = "Hello, World!";
        Rvalue rvalue;
        rvalue = value;
    }
    return 0;
}
