//
//  AliDownloaderProxy.h
//  flutter_aliplayer
//
//  Created by lileilei on 2020/11/29.
//

#import <Foundation/Foundation.h>
#import <AliyunMediaDownloader/AliyunMediaDownloader.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliDownloaderProxy : NSObject<AMDDelegate>

@property(nonatomic,strong) FlutterResult result;
@property (nonatomic, weak) FlutterEventSink eventSink;
@property(nonatomic,strong) NSMutableDictionary *argMap;

@end

NS_ASSUME_NONNULL_END
