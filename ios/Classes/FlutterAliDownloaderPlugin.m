//
//  FlutterAliDownloaderPlugin.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/11/29.
//

#import "FlutterAliDownloaderPlugin.h"
#import <AliyunMediaDownloader/AliyunMediaDownloader.h>
#import "NSDictionary+ext.h"
#import "AliDownloaderProxy.h"

@interface FlutterAliDownloaderPlugin ()<AMDDelegate>{
    FlutterMethodChannel* _channel;
    FlutterEventSink eventSink;
    NSString *mSavePath;
    AliMediaDownloader *downloader;
}

@property(strong,nonatomic) NSMutableDictionary * mAliMediaDownloadMap;

@end

@implementation FlutterAliDownloaderPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.flutter_alidownload"
            binaryMessenger:[registrar messenger]];
  FlutterAliDownloaderPlugin* instance = [[FlutterAliDownloaderPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = [call method];
    SEL methodSel=NSSelectorFromString([NSString stringWithFormat:@"%@:",method]);
    NSArray *arr = @[call,result];
    if([self respondsToSelector:methodSel]){
        IMP imp = [self methodForSelector:methodSel];
        CGRect (*func)(id, SEL, NSArray*) = (void *)imp;
        func(self, methodSel, arr);
    }else{
        result(FlutterMethodNotImplemented);
    }
}

//- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
//    return nil;
//}
//
//- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
//    eventSink = events;
//    return nil;
//}

-(void)setSaveDir:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    NSLog(@"savePath==%@",call.arguments);
    mSavePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (void)prepare:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    FlutterResult result = arr[1];
    NSDictionary *dic = [call.arguments removeNull];
    NSNumber *idxNum = dic[@"index"];
    NSString *type = dic[@"type"];
    NSString *vid = dic[@"vid"];
    if(type.length>0){
        if([type isEqualToString:@"download_sts"]){
            AVPVidStsSource *source = [[AVPVidStsSource alloc] init];
            [source setVid:vid];
            [source setAccessKeyId:dic[@"accessKeyId"]];
            [source setAccessKeySecret:dic[@"accessKeySecret"]];
            [source setSecurityToken:dic[@"securityToken"]];
            [source setRegion:@"cn-shanghai"];
            [self prepareVidSts:source result:result];
        }else if([type isEqualToString:@"download_auth"]){
            
        }
    }
}

- (void)prepareVidSts:(AVPVidStsSource*)vidSts result:(FlutterResult)result{
    downloader = [self.mAliMediaDownloadMap objectForKey:vidSts.vid];
    if(!downloader){
        downloader = [[AliMediaDownloader alloc] init];
        [self.mAliMediaDownloadMap setObject:downloader forKey:vidSts.vid];
    }
    
    AliDownloaderProxy *proxy = [[AliDownloaderProxy alloc] init];
//    [proxy setResult:result];
//    [downloader setSaveDirectory:mSavePath];
    [downloader setDelegate:proxy];
    [downloader prepareWithVid:vidSts];
}

- (void)start:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    NSDictionary *dic = [call.arguments removeNull];
    NSString *vid = dic[@"vid"];
    NSString *index = dic[@"index"];
    AliMediaDownloader *downloader = [self.mAliMediaDownloadMap objectForKey:[NSString stringWithFormat:@"%@_%@",vid,index]];
    if (!downloader) {
        [downloader setSaveDirectory:mSavePath];
        [downloader start];
    }
}


#pragma --mark AMDDelegate
-(void)onPrepared:(AliMediaDownloader*)downloader mediaInfo:(AVPMediaInfo*)info{
    NSLog(@"aaaaaaa");
}

- (void)onError:(AliMediaDownloader*)downloader errorModel:(AVPErrorModel *)errorModel{
//    eventSink.
    NSLog(@"bbbbb");
}

- (void)onDownloadingProgress:(AliMediaDownloader*)downloader percentage:(int)percent{
    
}

- (void)onProcessingProgress:(AliMediaDownloader*)downloader percentage:(int)percent{
    
}

- (void)onCompletion:(AliMediaDownloader*)downloader{
    
}
    
@end
