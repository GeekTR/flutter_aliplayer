//
//  VideoViewFactory.h
//  flutter_aliplayer
//
//  Created by lileilei on 2020/10/9.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <AliyunPlayer/AliyunPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliPlayerFactory : NSObject<FlutterPlatformViewFactory,AVPDelegate,FlutterStreamHandler>

@property(nonatomic,strong,nullable)AliPlayer *aliPlayer;
@property(nonatomic,strong,nullable)AliListPlayer *aliListPlayer;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
