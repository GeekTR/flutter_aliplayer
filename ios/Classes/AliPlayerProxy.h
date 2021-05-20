//
//  AliPlayerProxy.h
//  flutter_aliplayer
//
//  Created by aliyun on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import <AliyunPlayer/AliyunPlayer.h>
#import <Flutter/Flutter.h>

#define kAliPlayerMethod    @"method"
#define kAliPlayerId        @"playerId"

NS_ASSUME_NONNULL_BEGIN

@interface AliPlayerProxy : NSObject<AVPDelegate>

//@property(nonatomic,strong) FlutterResult result;
@property (nonatomic, copy) FlutterEventSink eventSink;

@property(nonatomic,strong) NSString *mSnapshotPath;

@property(nonatomic,strong,nullable)AliPlayer *player;

@property(nonatomic,strong) NSString *playId;

@end

NS_ASSUME_NONNULL_END
