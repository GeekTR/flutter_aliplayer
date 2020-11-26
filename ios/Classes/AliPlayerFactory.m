//
//  VideoViewFactory.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/10/9.
//
#import "AliPlayerFactory.h"
#import "FlutterAliPlayerView.h"

@implementation AliPlayerFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
    FlutterMethodChannel* _channel;
    FlutterMethodChannel* _listPlayerchannel;
    UIView *playerView;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
     _channel = [FlutterMethodChannel methodChannelWithName:@"flutter_aliplayer" binaryMessenger:messenger];
     __weak __typeof__(self) weakSelf = self;
     [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
         [weakSelf onMethodCall:call result:result atObj:weakSelf.aliPlayer];
     }];
     
     _listPlayerchannel = [FlutterMethodChannel methodChannelWithName:@"flutter_alilistplayer" binaryMessenger:messenger];
     [_listPlayerchannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
         [weakSelf onMethodCall:call result:result atObj:weakSelf.aliListPlayer];
     }];
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                            viewIdentifier:(int64_t)viewId
                                                 arguments:(id _Nullable)args {
    FlutterAliPlayerView* player =
      [[FlutterAliPlayerView alloc] initWithWithFrame:frame
                                       viewIdentifier:viewId
                                            arguments:args
                                      binaryMessenger:_messenger];
    playerView = player.view;
    if (_aliPlayer) {
        _aliPlayer.playerView = playerView;
    }
    if (_aliListPlayer) {
        _aliListPlayer.playerView = playerView;
    }
    return player;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result atObj:(NSObject*)player{
    NSString* method = [call method];
    if ([method isEqualToString:@"setUrl"]) {
        [self setUrl:call result:result];
    } else if ([method isEqualToString:@"prepare"]) {
//        [self prepare:call result:result];
        [(AliPlayer*)player prepare];
    }else if ([method isEqualToString:@"play"]) {
//        [self play:call result:result];
        [(AliPlayer*)player start];
    }else if ([method isEqualToString:@"pause"]) {
        [(AliPlayer*)player pause];
    }else if ([method isEqualToString:@"stop"]) {
        [(AliPlayer*)player stop];
    }else if ([method isEqualToString:@"setLoop"]) {
        [self setLoop:call result:result atObj:(AliPlayer*)player];
    }else if ([method isEqualToString:@"isLoop"]) {
        [self isLoop:call result:result];
    }else if ([method isEqualToString:@"setMuted"]) {
        [self setMuted:call result:result];
    }else if ([method isEqualToString:@"isMuted"]) {
        [self isMuted:call result:result];
    }else if ([method isEqualToString:@"setAutoPlay"]) {
        [self setAutoPlay:call result:result atObj:(AliPlayer*)player];
    }else if ([method isEqualToString:@"isAutoPlay"]) {
        [self isAutoPlay:call result:result];
    }else if ([method isEqualToString:@"enableHardwareDecoder"]) {
        [self enableHardwareDecoder:call result:result];
    }else if ([method isEqualToString:@"setEnableHardwareDecoder"]) {
        [self setEnableHardwareDecoder:call result:result];
    }else if ([method isEqualToString:@"getRotateMode"]) {
        [self getRotateMode:call result:result];
    }else if ([method isEqualToString:@"setRotateMode"]) {
        [self setRotateMode:call result:result];
    }else if ([method isEqualToString:@"getMirrorMode"]) {
        [self getMirrorMode:call result:result];
    }else if ([method isEqualToString:@"setMirrorMode"]) {
        [self setMirrorMode:call result:result];
    }else if ([method isEqualToString:@"getScalingMode"]) {
        [self getScalingMode:call result:result];
    }else if ([method isEqualToString:@"setScalingMode"]) {
        [self setScalingMode:call result:result];
    }else if ([method isEqualToString:@"getRate"]) {
        [self getRate:call result:result];
    }else if ([method isEqualToString:@"setRate"]) {
        [self setRate:call result:result];
    }else if ([method isEqualToString:@"setVidSts"]) {
        [self setVidSts:call result:result];
    }else if ([method isEqualToString:@"addVidSource"]) {
        [self addVidSource:call result:result];
    }else if ([method isEqualToString:@"addUrlSource"]) {
        [self addUrlSource:call result:result];
    }else if ([method isEqualToString:@"moveTo"]) {
        [self moveTo:call result:result];
    }else if ([method isEqualToString:@"moveToNext"]) {
        [self moveToNext:call result:result];
    }else {
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

- (void)setLoop:(FlutterMethodCall*)call result:(FlutterResult)result atObj:(AliPlayer*)player{
    NSNumber* isLoop = [call arguments];
    [player setLoop:isLoop.boolValue];
}

- (void)isAutoPlay:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.aliPlayer isAutoPlay]));
}

- (void)setAutoPlay:(FlutterMethodCall*)call result:(FlutterResult)result atObj:(AliPlayer*)player{
    NSNumber* val = [call arguments];
    [player setAutoPlay:val.boolValue];
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

- (void)getRotateMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@(self.aliPlayer.rotateMode));
}

- (void)setRotateMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setRotateMode:val.intValue];
}

- (void)getScalingMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@(self.aliPlayer.scalingMode));
}

- (void)setScalingMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setScalingMode:val.intValue];
}

- (void)getMirrorMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@(self.aliPlayer.mirrorMode));
}

- (void)setMirrorMode:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setMirrorMode:val.intValue];
}

- (void)getRate:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@(self.aliPlayer.rate));
}

- (void)setRate:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber* val = [call arguments];
    [self.aliPlayer setRate:val.floatValue];
}

- (void)setVidSts:(FlutterMethodCall*)call result:(FlutterResult)result {
    AVPVidStsSource *source = [[AVPVidStsSource alloc] init];
    NSDictionary *dic = call.arguments;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if([obj length]>0){
         [source setValue:obj forKey:(NSString *)key];
        }
    }];
    [self.aliPlayer setStsSource:source];
}

- (void)addVidSource:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dic = [call arguments];
    NSLog(@"addVidSource==vid:%@,uid,%@",dic[@"vid"],dic[@"uid"]);
    [self.aliListPlayer addVidSource:dic[@"vid"] uid:dic[@"uid"]];
}

- (void)addUrlSource:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dic = [call arguments];
    [self.aliListPlayer addUrlSource:dic[@"url"] uid:dic[@"uid"]];
}

- (void)moveTo:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dic = [call arguments];
    [self.aliListPlayer moveTo:dic[@"uid"] accId:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
}

- (void)moveToNext:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dic = [call arguments];
    [self.aliListPlayer moveToNext:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
}

#pragma --mark getters
- (AliPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliPlayer alloc] init];
        _aliPlayer.scalingMode =  AVP_SCALINGMODE_SCALEASPECTFIT;
        _aliPlayer.rate = 1;
        _aliPlayer.delegate = self;
        _aliPlayer.playerView = playerView;
    }
    return _aliPlayer;
}

- (AliListPlayer*) aliListPlayer{
    if(!_aliListPlayer){
        _aliListPlayer = [[AliListPlayer alloc] init];
       _aliListPlayer.scalingMode =  AVP_SCALINGMODE_SCALEASPECTFIT;
       _aliListPlayer.rate = 1;
       _aliListPlayer.delegate = self;
       _aliListPlayer.playerView = playerView;
       _aliListPlayer.stsPreloadDefinition = @"FD";
}
    return _aliListPlayer;
}

@end

