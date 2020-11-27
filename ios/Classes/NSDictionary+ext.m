//
//  NSDictionary+ext.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/11/27.
//

#import "NSDictionary+ext.h"

@implementation NSDictionary (ext)

-(NSDictionary*)removeNull{
    NSArray *keyArr = [self allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [self getStrByKey:keyArr[i]];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

-(NSString*)getStrByKey:(NSString*)key{
    NSString *val = [self objectForKey:key];
    if([val isKindOfClass:[NSNull class]]){
        val = @"";
    }
    return val;
}

@end
