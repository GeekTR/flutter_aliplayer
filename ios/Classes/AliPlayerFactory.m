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
    SEL methodSel=NSSelectorFromString([NSString stringWithFormat:@"%@:",method]);
    NSArray *arr = @[call,result,player];
    if([self respondsToSelector:methodSel]){
        IMP imp = [self methodForSelector:methodSel];
        CGRect (*func)(id, SEL, NSArray*) = (void *)imp;
        func(self, methodSel, arr);
    }else{
        result(FlutterMethodNotImplemented);
    }
}

- (void)setUrl:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSString* url = [call arguments];
    AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:url];
    [player setUrlSource:source];
}

- (void)prepare:(NSArray*)arr {
    AliPlayer *player = arr[2];
    [player prepare];
}

- (void)play:(NSArray*)arr {
    AliPlayer *player = arr[2];
    [player start];
}

- (void)pause:(NSArray*)arr {
    AliPlayer *player = arr[2];
    [player pause];
}

- (void)stop:(NSArray*)arr {
    AliPlayer *player = arr[2];
    [player stop];
}

- (void)isLoop:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@([player isLoop]));
}

- (void)setLoop:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* isLoop = [call arguments];
    [player setLoop:isLoop.boolValue];
}

- (void)isAutoPlay:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@([player isAutoPlay]));
}

- (void)setAutoPlay:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setAutoPlay:val.boolValue];
}

- (void)isMuted:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@([player isMuted]));
}

- (void)setMuted:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    NSNumber* val = [call arguments];
    AliPlayer *player = arr[2];
    [player setMuted:val.boolValue];
}
- (void)enableHardwareDecoder:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@([player enableHardwareDecoder]));
}

- (void)setEnableHardwareDecoder:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setEnableHardwareDecoder:val.boolValue];
}

- (void)getRotateMode:(NSArray*)arr {
    AliPlayer *player = arr[2];
    FlutterResult result = arr[1];
    result(@(player.rotateMode));
}

- (void)setRotateMode:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setRotateMode:val.intValue];
}

- (void)getScalingMode:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@(player.scalingMode));
}

- (void)setScalingMode:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setScalingMode:val.intValue];
}

- (void)getMirrorMode:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@(player.mirrorMode));
}

- (void)setMirrorMode:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setMirrorMode:val.intValue];
}

- (void)getRate:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    result(@(player.rate));
}

- (void)setRate:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    NSNumber* val = [call arguments];
    [player setRate:val.floatValue];
}

- (void)setVidSts:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    AVPVidStsSource *source = [[AVPVidStsSource alloc] init];
    NSDictionary *dic = call.arguments;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if([obj length]>0){
            [source setValue:obj forKey:(NSString *)key];
        }
    }];
    [player setStsSource:source];
}

- (void)addVidSource:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [call arguments];
    [player addVidSource:dic[@"vid"] uid:dic[@"uid"]];
}

- (void)addUrlSource:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [call arguments];
    [player addUrlSource:dic[@"url"] uid:dic[@"uid"]];
}

- (void)moveTo:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [call arguments];
    [player moveTo:dic[@"uid"] accId:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
}

- (void)moveToNext:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [call arguments];
    [player moveToNext:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
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

