//
//  XYDynamicInfo.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicInfo.h"

@implementation XYDynamicInfo

//static id _instance = nil;
//+ (instancetype)shareInstance {
//    static dispatch_once_t onceToken ;
//    dispatch_once(&onceToken, ^{
//        _instance = [[super allocWithZone:NULL] init] ;
//    }) ;
//    return _instance ;
//}

//+ (id)allocWithZone:(struct _NSZone *)zone {
//    return [XYDynamicInfo shareInstance] ;
//}
//
//- (id)copyWithZone:(struct _NSZone *)zone {
//    return [XYDynamicInfo shareInstance] ;
//}
//
//
- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
      
        self.basePath = dict[@"basePath"];
        self.code = [dict[@"code"] integerValue];
        self.codeMsg = dict[@"codeMsg"];
        self.idstamp = [dict[@"idstamp"] integerValue];
        
    }
    
    return self;
}
+ (instancetype)dynamicInfoWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
