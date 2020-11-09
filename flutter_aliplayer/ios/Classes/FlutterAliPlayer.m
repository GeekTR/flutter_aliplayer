//
//  FlutterAliPlayer.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/9/24.
//
#import "FlutterAliPlayer.h"
#import <AliyunPlayer/AliyunPlayer.h>

@interface FlutterAliPlayer ()<AVPDelegate>

@property(nonatomic,strong)AliPlayer *aliPlayer;

@end

@implementation FlutterAliPlayer{
    UIView * _videoView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
}

#pragma mark - life cycle

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        _videoView = [UIView new];
        NSDictionary *dic = args;
        CGFloat x = [dic[@"x"] floatValue];
        CGFloat y = [dic[@"y"] floatValue];
        CGFloat width = [dic[@"width"] floatValue];
        CGFloat height = [dic[@"height"] floatValue];
        _videoView.frame = CGRectMake(x, y, width, height);
        NSString* channelName = [NSString stringWithFormat:@"flutter_aliplayer_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

- (nonnull UIView *)view {
    return _videoView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"setUrl"]) {
        [self setUrl:call result:result];
    } else if ([[call method] isEqualToString:@"prepare"]) {
        [self prepare:call result:result];
    }else if ([[call method] isEqualToString:@"play"]) {
        [self play:call result:result];
    }else if ([[call method] isEqualToString:@"pause"]) {
        [self pause:call result:result];
    }else if ([[call method] isEqualToString:@"stop"]) {
        [self stop:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)setUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* url = [call arguments];
    [self setUrl:url];
}

- (void)prepare:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self.aliPlayer prepare];
}

- (void)play:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self.aliPlayer start];
}

- (void)pause:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self.aliPlayer pause];
}

- (void)stop:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self.aliPlayer stop];
}

- (void)setUrl:(NSString*)url {
    AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:url];
    [self.aliPlayer setUrlSource:source];
    [self.aliPlayer prepare];
    
}

#pragma --mark getters
- (AliPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliPlayer alloc] init];
        _aliPlayer.scalingMode =  AVP_SCALINGMODE_SCALEASPECTFIT;
        _aliPlayer.rate = 1;
        _aliPlayer.delegate = self;
        _aliPlayer.playerView = _videoView;
//        _aliPlayer.autoPlay = YES;
    }
    return _aliPlayer;
}

@end
