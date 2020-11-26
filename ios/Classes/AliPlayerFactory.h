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

@interface AliPlayerFactory : NSObject<FlutterPlatformViewFactory,AVPDelegate>

@property(nonatomic,strong)AliPlayer *aliPlayer;
@property(nonatomic,strong)AliListPlayer *aliListPlayer;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END