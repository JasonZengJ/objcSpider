//
//  WEBSpider.m
//  objcSpider
//
//  Created by jason on 8/8/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import "WEBSpider.h"

@implementation WEBSpider

/**
 *	@brief	WEBSpider initialize
 *
 *  @param  url       the website to  crawl
 *	@param 	filePath  path to save file
 */

-(void) startSpiderWithUrl:(NSString*) url andFilePath:(NSString*)_filePath{
    
    regUtil     = [RegExpreUtil initRegExpreUtil];
    baseUrl     = [regUtil matcheOneString:url withRegExpre:@"http://(?i).*?/"];
    filePath    = _filePath;
    fileManager = [NSFileManager defaultManager];
    hrefRex     = @"href=\"[a-z0-9_/\\.-]+\"";
    srcRex      = @"src=\"[a-z0-9_/\\.-\?=]+\"";
    
    [self analysisHtml:url];
    
}
/**
 *	@brief analysis html data and create html file
 *
 *  @param  htmlurl
 */

-(void) analysisHtml:(NSString*) htmlUrl{
    
    if (![htmlUrl hasPrefix:baseUrl]) {
        return;
    }
    
    NSArray* pathArray        = [[htmlUrl stringByReplacingOccurrencesOfString:baseUrl withString:@""] componentsSeparatedByString:@"/"];
    NSString* suffix = [pathArray objectAtIndex:[pathArray count]-1];
    NSString* urlPath = [htmlUrl stringByReplacingOccurrencesOfString:suffix withString:@""];
    NSString* _filePath = filePath;
    
    for (int i=0; i < [pathArray count]; i++) {// 判断网页文件是否存在若不存在，则发出Post请求获取页面数据，并创建相应的文件
        _filePath = [_filePath stringByAppendingPathComponent:[pathArray objectAtIndex:i]];
        if(i != [pathArray count] - 1 ){
            [self makeDir:_filePath];
        }else{
            if ([fileManager fileExistsAtPath:_filePath]) {
                return;
            }
        }
    }
    NSLog(@"html:%@ begin to analysis...",htmlUrl);
    NSData *received = [self getPostRequestString:htmlUrl];
    NSString *receivedString    = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:_filePath contents:received attributes:nil];
    NSLog(@"file:%@ created",_filePath);
    
    NSArray* srcUrlArr  = [regUtil matches:receivedString withRegExpre:srcRex];
    for (NSString* match in srcUrlArr) {
        NSArray* subMatch = [regUtil matches:match withRegExpre:@"[a-z0-9_/-]+[\\.]+[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*"];
        for (NSString* subMatches in subMatch) {

            [self saveUrlData:[urlPath stringByAppendingString:subMatches]];
        }
    }
    
    NSArray* hrefUrlArr = [regUtil matches:receivedString withRegExpre:hrefRex];
    for (NSString* match in hrefUrlArr) {
        NSArray* subMatch = [regUtil matches:match withRegExpre:@"[a-z0-9_/-]+[\\.]+[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*[\\.]*[a-z0-9_/-]*"];
        for (NSString* subMatches in subMatch) {
            if([subMatches hasSuffix:@".html"]){
                
                NSString *_htmlUrl = [urlPath stringByAppendingString:subMatches];
                [self analysisHtml:_htmlUrl];
                
            }else if([subMatches hasSuffix:@".css"]){
                
                NSString* CSSUrl = [urlPath stringByAppendingString:subMatches];
                [self analysisCSS:CSSUrl];
                
            }else{
                
                [self saveUrlData:[urlPath stringByAppendingString:subMatches]];
                
            }
        }
    }
    

}
// 解析css文件，分析出其中的图片地址并在本地相应目录生成图片文件
-(void) analysisCSS:(NSString *)CSSUrl{

    NSArray* pathArray       = [[CSSUrl stringByReplacingOccurrencesOfString:baseUrl withString:@""] componentsSeparatedByString:@"/"];
    NSString* suffix         = [pathArray objectAtIndex:[pathArray count]-1];
    NSString* urlPath        = [CSSUrl stringByReplacingOccurrencesOfString:suffix withString:@""];
    NSString* superiorSuffix = [[pathArray objectAtIndex:[pathArray count]-2] stringByAppendingString:@"/"];
    NSString* superiorPath   = [urlPath stringByReplacingOccurrencesOfString:superiorSuffix withString:@""];
    
    NSString* _filePath = filePath;
    
    for (int i=0; i < [pathArray count]; i++) {
        _filePath = [_filePath stringByAppendingPathComponent:[pathArray objectAtIndex:i]];
        
        if(i != [pathArray count] - 1 ){
            [self makeDir:_filePath];
        }else{
            if ([fileManager fileExistsAtPath:_filePath]) {
                return;
            }
        }
        
    }
    NSLog(@"CSS:%@ begin to analysis...",CSSUrl);
    NSData *received = [self getPostRequestString:CSSUrl];
    NSString *receivedString    = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:_filePath contents:received attributes:nil];
    NSLog(@"file:%@ created",_filePath);

    NSArray *matchString = [regUtil matches:receivedString withRegExpre:@"url\\((?i).*?\\)"];
    for (NSString *match in matchString) {
        
         NSString* subString= NULL;
         NSArray*  arr = [regUtil matches:match withRegExpre:@"[\"|\']+"];
        if ([arr count] > 0) {
            subString = [match substringWithRange:NSMakeRange(5,[match length]-7)];
        }else{
            subString = [match substringWithRange:NSMakeRange(4,[match length]-5)];
        }
        if([subString hasPrefix:@"../"]){
            NSString* imageUrl  = [subString substringWithRange:NSMakeRange(3,[subString length]-3)];
            NSString* imagePath = [superiorPath stringByAppendingString:imageUrl];
            [self saveUrlData:imagePath];
        }else{
            NSString* imagePath = [urlPath stringByAppendingString:subString];
            [self saveUrlData:imagePath];
        }
        
    }
}
// 发送Post请求，并返回请求返回的数据。
-(NSData*) getPostRequestString:(NSString*) _url{
    
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc]
                                    initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *requestParam = @"type=focus-c";
    NSData *data = [requestParam dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return received;
}
// 根据url判断文件是否已经在相应目录中创建，若未创建，则发送Post请求获取数据，然后创建文件。
-(void) saveUrlData:(NSString*) url{
    
    NSArray* pathArray        = [[url stringByReplacingOccurrencesOfString:baseUrl withString:@""] componentsSeparatedByString:@"/"];
    NSString* _filePath = filePath;
    
    for (int i=0; i < [pathArray count]; i++) {
        _filePath = [_filePath stringByAppendingPathComponent:[pathArray objectAtIndex:i]];
        
        if(i != [pathArray count] - 1 ){
            [self makeDir:_filePath];
        }else{
            if ([fileManager fileExistsAtPath:_filePath]) {
                return;
            }
        }
        
    }
    NSData *received = [self getPostRequestString:url];
    [fileManager createFileAtPath:_filePath contents:received attributes:nil];
    NSLog(@"file:%@ created",_filePath);

}

-(void) makefile:(NSString*)_filePath withContents:(NSData*)received{
    
    if (![fileManager fileExistsAtPath:_filePath]) {
        [fileManager createFileAtPath:_filePath contents:received attributes:nil];
    }
    
}
// 创建目录
-(void) makeDir:(NSString*)dirPath{
    
    if (![fileManager fileExistsAtPath:dirPath]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:false attributes:nil error:nil];
    }

}
@end
