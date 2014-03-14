//
//  main.m
//  objcSpider
//
//  Created by jason on 8/8/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "WEBSpider.h"
#import "RegExpreUtil.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSDate* startData = [NSDate date];

        WEBSpider* spider = [[WEBSpider alloc] init];
        [spider startSpiderWithUrl:@"http://bootstrapmaster.com/live/simpliq2/index.html" andFilePath:@"/Users/Jason/Documents"];
//        [spider analysisCSS:@"http://tzd-themes.com/hagal_admin/css/brown.css"];
        double costTime = [[NSDate date] timeIntervalSinceDate:startData];

        NSLog(@"time cost：%lfs",costTime);
//        NSString* path = @"/Users/Jason/Documents.html";
//        NSLog(@"%d",[path hasPrefix:@"/Users/"]);

//        NSURL *url = [NSURL URLWithString:@"http://tzd-themes.com/hagal_admin/form_elements.html"];
//        NSMutableURLRequest * request =[[NSMutableURLRequest alloc]
//                                        initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        [request setHTTPMethod:@"POST"];
//        NSString *requestParam = @"type=focus-c";
//        NSData *data = [requestParam dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *str = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
//
//        NSLog(@"%@",str);
//
//        RegExpreUtil *regUtil = [RegExpreUtil initRegExpreUtil];
//        
//        NSRegularExpression *BaseUrl = [NSRegularExpression regularExpressionWithPattern:@"http://(?i).*?/" options:NSRegularExpressionCaseInsensitive error:nil];
//
//
//        
//        
//        NSArray *matchs = [BaseUrl matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
//        
//        
//        NSArray *matchString = [regUtil matches:str withRegExpre:@"url\\((?i).*?\\)"];
//        NSArray *matches = [regUtil matches:str withRegExpre:@"src=\"h"];
//
//        for (NSString *match in matches) {
//
//
////            NSString* subString = [match substringWithRange:NSMakeRange(4,[match length]-5)];
//            NSLog(@"n---->匹配到字符串：%@",match);
//            
//        }
        
        
    }
    return 0;
}

