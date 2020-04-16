//
//  SMsgObject.m
//  Debug
//
//  Created by kakiYen on 2019/12/2.
//

#import "SMsgObject.h"

static void ResolveMethod(id object, SEL sel){
    NSLog(@"%s : %s",object_getClassName(object),sel_getName(sel));
}

/**
 NSArray：
    1、存储空间连续[即非链表结构]
    2、存储位置连续[即元素的位置是按照插入的顺序存储]
 
 NSMutableArray[继承NSArray特性]：
    大致数据结构：
        struct {
            _used   //已使用的内存空间计数
            _list   //内存空间首地址指针
            _size   //内存空间大小
            _offset //第一个元素索引偏移量 _list[_offset]
        }
    环形缓冲区：
        获取规则：
            index(想要获取的元素下标).
            fetchOffset = _offset + index
            if fetchOffset > _size
                fetchOffset = fetchOffset % _size;
            item = _list[fetchOffset]
 
        头部插入：
            _offset = _offset - 1
            if _offset < 0
                insetOffset = _size + _offset
                _offset = insetOffset
            else
                insetOffset = _offset
        头部删除：
            _offset = _offset + 1
            if _offset > _size
                _offset = _offset % _size
 
        尾部插入：
            insetOffset = _offset + index
            if insetOffset > _size
                insetOffset = insetOffset % _size
        尾部删除：
            通过 获取规则 拿到对应的fetchOffset
 
        中部插入或删除：
            1、线判断 index 是否已有值，有进入2.
            2、index - 1是否已有值，无先将index移动到index - 1，再将值插入index；否则进入3.
            3、index + 1是否已有值，无先将index移动到index + 1，再将值插入index；否则进入4.
            4、从index往头部和尾部查找，找到没有存储值的下标即停，分别获得headerIndex和tailIndex，若headerIndex > tailIndex 则移动尾部的元素；否则移动头部的元素。
 
    NSDictionary：
        1、存储空间连续[即非链表结构]
        2、存储位置不连续[内部使用Hash映射完成]
 
    NSMutableDictionary[继承NSDictionary特性]：
        大致数据结构：
            struce{
                CFIndex _count;
                CFIndex _capacity;
                uintptr_t _marker;  //删除标记，如：_keys[Hash(key)] == _marker，即_keys[Hash(key)]是空值或已移除
                const void **_keys; //存储key值的数组
                const void **_values;   //存储value值的数组
            }
        Hash化是获取变量特征的一个过程；这个过程可能是一个计算过程，也可能是个变量的某个特征
 
        存储过程：
            1、首先判断是否需要扩容，_count ≥ _capacity，则扩容。进入2
            2、根据Key值计算HashCode即CFHashCode keyHash = (CFHashCode)key。
            3、_keys[keyHash]空值，则直接_keys[keyHash] = key；_values[keyHash] = value，否则进入4。
            4、_keys[keyHash]有值，开发地址法后，向下个下标 keyHash+1 查看，进入3.
 
        删除过程：
            删除某个Key-Value，根据Key值计算HashCode即CFHashCode keyHash = (CFHashCode)key。
            _keys[keyHash] = _marker标记为可覆盖
 
    NSSet：
        1、存储空间连续[即非链表结构]
        2、存储位置不连续[内部使用Hash映射完成]
 
    拉链法优缺点：
        碰撞冲突解决简单，只需在对应的链表添加节点；但因碰撞冲突导致链表过长时，其查询效率低下。
        一般用于内存释放时机要求不高的情况
 
    开放地址法优缺点：
        容器存储空间不足时需要扩容，导致需要重新开辟更大的连续的存储空间，还须对已存的内容重新进行Hash映射。
        一般用于内存释放时机要求高的情况，所以一般不会定义在全局中。
 
    struct{
        int age;
        int list[0];
    }
    结构体最后一个成员变量定义类似为 ：
        1、malloc(sizeof(struct) + extraLength)，则 list[0] 指向extraLength这段长度的内存空间
        2、释放时，只需释放 struct。
 */
@interface SMsgObject ()
@property (strong, nonatomic) NSArray *superArray;
@property (strong, nonatomic) NSSet *subSet;

@end

@implementation SMsgObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            /*
             __bridge: 适用于OC与C变量、OC对象与Core Foundation对象相互之间的转换，但内存的本身拥有关系不变。
             __bridge_retained: 适用于OC->C变量、OC对象->Core Foundation对象的转换，内存的本身拥有关系变为后者。
             __bridge_transfer: 适用于C变量->OC、Core Foundation对象->OC对象的转换，内存的本身拥有关系变为后者，移除前着的指针。
             */
            
            NSString *charArray[] = {@"Fuck", @"Down"};
            CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault, (void *)charArray, (CFIndex)2, NULL);
            _superArray = CFBridgingRelease(arrayRef);  //_superArray = (__bridge_transfer NSArray *)arrayRef
            _subSet = [NSSet setWithObjects:@"Holy", @"Shit", nil];
        }
        NSLog(@"%@",_superArray.description);
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    BOOL should = NO;
    if (strcmp(sel_getName(sel), "instanceResolveMethod") == 0) {
        should = class_addMethod(self, sel, (IMP)ResolveMethod, "v@:");
    }else{
        should = [super resolveInstanceMethod:sel];
    }
    return should;
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    BOOL should = NO;
    if (strcmp(sel_getName(sel), "classResolveMethod") == 0) {
        should = class_addMethod(object_getClass(self.class), sel, (IMP)ResolveMethod, "v@:");
    }else{
        should = [super resolveClassMethod:sel];
    }
    return should;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    if (strcmp(sel_getName(invocation.selector), "instanceInvocationMethod") == 0) {
        invocation.selector = @selector(invocationMethod);
        [invocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:invocation];
    }
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

+ (void)forwardInvocation:(NSInvocation *)invocation{
    if (strcmp(sel_getName(invocation.selector), "classInvocationMethod") == 0){
        invocation.selector = @selector(classMethod);
        [invocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:invocation];
    }
}

- (void)invocationMethod{
    NSLog(@"%@ : %s",self.className,__FUNCTION__);
}

+ (void)classMethod{
    NSLog(@"%@ : %s",self.className,__FUNCTION__);
}

@end
