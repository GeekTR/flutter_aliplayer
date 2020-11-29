//
//  AliDownloaderProxy.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/11/29.
//

#import "AliDownloaderProxy.h"
#import "NSObject+Json.h"

@implementation AliDownloaderProxy


#pragma --mark AMDDelegate
-(void)onPrepared:(AliMediaDownloader*)downloader mediaInfo:(AVPMediaInfo*)info{
 NSLog(@"=========aaaa");
    //    self.result([info JSONString]);
}

- (void)onError:(AliMediaDownloader*)downloader errorModel:(AVPErrorModel *)errorModel{
    NSLog(@"=========ddddd");
}

- (void)onDownloadingProgress:(AliMediaDownloader*)downloader percentage:(int)percent{
    
}

- (void)onProcessingProgress:(AliMediaDownloader*)downloader percentage:(int)percent{
    
}

- (void)onCompletion:(AliMediaDownloader*)downloader{
    
}

@end
