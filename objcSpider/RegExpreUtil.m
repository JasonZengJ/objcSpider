//
//  RegUtil.m
//  objcSpider
//
//  Created by jason on 8/10/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "RegExpreUtil.h"

@implementation RegExpreUtil
+(id) initRegExpreUtil{
    
    return [[RegExpreUtil alloc] init];
}
// gain a NSString Array
-(NSArray*) matches:(NSString*)string withRegExpre:(NSString*)regExpre{
    
    NSRegularExpression *regularExpre = [NSRegularExpression regularExpressionWithPattern:regExpre options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matchsRange = [regularExpre matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length])];
    
    NSMutableArray *matchs = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matchsRange) {
        
        NSRange matchRange = [match range];
        
        [matchs addObject:[string substringWithRange:matchRange]];
        
    }
    
    return matchs;
}
// gain the first matched NSString
-(NSString*) matcheOneString:(NSString*)string withRegExpre:(NSString*)regExpre{
    
    NSArray* stringArr = [self matches:string withRegExpre:regExpre];
    
    if ([stringArr count] > 0) {
        return [stringArr objectAtIndex:0];
    }else{
        return nil;
    }
    
    
}
@end
