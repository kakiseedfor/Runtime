//
//  BolckObject.m
//  Debug
//
//  Created by kakiYen on 2019/12/2.
//

#import "BlockObject.h"

@implementation BlockObject

+ (void)shareBlock{
    NSString *name = @"Messi";
    NSString *country = @"Argentina";
    void (^tempBlock)(void) = ^{
        NSLog(@"%@ : %@",name, country);
    };
    tempBlock();
}

@end
