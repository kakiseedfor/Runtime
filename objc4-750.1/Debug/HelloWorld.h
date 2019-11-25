//
//  Helloworld.h
//  Debug
//
//  Created by kakiYen on 2019/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//__attribute__((objc_runtime_name("Holy Shit")))
@interface HelloWorld : NSObject

@end

@interface GoodByeWorld : HelloWorld

- (void)goodByeWorld;

@end

NS_ASSUME_NONNULL_END
