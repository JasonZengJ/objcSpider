objcSpider 
===========
###A web crawlers developed with objective-c
-----
###1. How to use it
    
    ＃import "WEBSpider.h"
	＃import "RegExpreUtil.h"
	int main(int argc, const char * argv[]){
	  @autoreleasepool {
	    WEBSpider* spider   = [[WEBSpider alloc] init];
	    NSString*  filePath = "/Users";
	    NSString*  url      = "http://bootstrapmaster.com/live/simpliq2/index.html";
        [spider startSpiderWithUrl:url andFilePath:filePath];
	  }
	}
    