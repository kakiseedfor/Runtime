//
//  LGPerson.h
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject
@property (nonatomic, copy) NSString *lgName;
@property (nonatomic, strong) NSString *nickName;

- (void)sayNB;
- (void)sayMaster;
- (void)say666;
- (void)sayHello;

@end

NS_ASSUME_NONNULL_END
