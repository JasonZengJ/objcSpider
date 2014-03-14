//
//  WEBSpider.h
//  objcSpider
//
//  Created by jason on 8/8/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegExpreUtil.h"

@interface WEBSpider : NSObject{
    @private
        NSString      * baseUrl;
        RegExpreUtil  * regUtil;
        NSString      * filePath;
        NSFileManager * fileManager;
        NSString      * srcRex;
        NSString      * hrefRex;
    
}
/**
 *	@brief	WEBSpider initialize
 *
 *  @param  url       the website to  crawl
 *	@param 	filePath  path to save file
 */
-(void) startSpiderWithUrl:(NSString*) url andFilePath:(NSString*)_filePath;

/**
 *	@brief	analysis html data
 *
 *  @param  htmlurl
 */
-(void) analysisHtml:(NSString*) htmlUrl;

/**
 *	@brief	analysis css for getting the url of icon or image from css file
 *
 *  @param  CSSUrl
 */
-(void) analysisCSS:(NSString *)CSSUrl;

/**
 *	@brief	Sending a Post Request to the url and get the data from the request;
 *
 *  @param  url    
 *
 *	@return	data string from request
 */
-(NSData*) getPostRequestString:(NSString*) _url;
/**
 *	@brief	save url file
 *
 *  @param  urlArray
 *	@param 	path
 */
-(void) saveUrlData:(NSString*) url;
/**
 *	@brief	create file at filePath
 *
 *	@param 	filePath 	the file path;
 *  @param  recieved    the data of response;
 */
-(void) makeFile:(NSString*)_filePath withContents:(NSData*)recieved;

/**
 *	@brief	create a directory at dirPath
 *
 *	@param 	dirPath 	the directory path;
 */
-(void) makeDir:(NSString*)dirPath;


@end
