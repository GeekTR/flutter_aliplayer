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
    NSString* method = [call method];
    if ([method isEqualToString:@"setUrl"]) {
        [self setUrl:call result:result];
    } else if ([method isEqualToString:@"prepare"]) {
        [self prepare:call result:result];
    }else if ([method isEqualToString:@"play"]) {
        [self play:call result:result];
    }else if ([method isEqualToString:@"pause"]) {
        [self pause:call result:result];
    }else if ([method isEqualToString:@"stop"]) {
        [self stop:call result:result];
    }else if ([method isEqualToString:@"setLoop"]) {
        [self setLoop:call result:result];
    }else if ([method isEqualToString:@"isLoop"]) {
        [self isLoop:call result:result];
    }else if ([method isEqualToString:@"setMuted"]) {
        [self setMuted:call result:result];
    }else if ([method isEqualToString:@"isMuted"]) {
        [self isMuted:call result:result];
    }else if ([method isEqualToString:@"setAutoPlay"]) {
        [self setAutoPlay:call result:result];
    }else if ([method isEqualToString:@"isAutoPlay"]) {
        [self isAutoPlay:call result:result];
    }else if ([method isEqualToString:@"enableHardwareDecoder"]) {
        [self enableHardwareDecoder:call result:result];
    }else if ([method isEqualToString:@"setEnableHardwareDecoder"]) {
        [self setEnableHardwareDecoder:call result:result];
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

- (void)isLoop:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.aliPlayer isLoop]));
}

- (void)setLoop:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* isLoop = [call arguments];
    [self.aliPlayer setLoop:isLoop.boolValue];
}

- (void)isAutoPlay:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.aliPlayer isAutoPlay]));
}

- (void)setAutoPlay:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setAutoPlay:val.boolValue];
}

- (void)isMuted:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.aliPlayer isMuted]));
}

- (void)setMuted:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setMuted:val.boolValue];
}

- (void)enableHardwareDecoder:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.aliPlayer enableHardwareDecoder]));
}

- (void)setEnableHardwareDecoder:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setEnableHardwareDecoder:val.boolValue];
}

#pragma --mark getters
- (AliPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliPlayer alloc] init];
        _aliPlayer.scalingMode =  AVP_SCALINGMODE_SCALEASPECTFIT;
        _aliPlayer.rate = 1;
        _aliPlayer.delegate = self;
        _aliPlayer.playerView = _videoView;
    }
    return _aliPlayer;
}

@end
