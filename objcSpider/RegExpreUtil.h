//
//  RegUtil.h
//  objcSpider
//
//  Created by jason on 8/10/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExpreUtil : NSObject
+(id) initRegExpreUtil;
-(NSArray*) matches:(NSString*)string withRegExpre:(NSString*)regExpre;
-(NSString*) matcheOneString:(NSString*)string withRegExpre:(NSString*)regExpre;
@end
