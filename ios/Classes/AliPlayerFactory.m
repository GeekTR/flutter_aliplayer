//
//  VideoViewFactory.m
//  flutter_aliplayer
//
//  Created by lileilei on 2020/10/9.
//
#import "AliPlayerFactory.h"
#import "FlutterAliPlayerView.h"
#import "NSDictionary+ext.h"
#import "MJExtension.h"

#define kAliPlayerMethod    @"method"

@interface AliPlayerFactory () {
    NSObject<FlutterBinaryMessenger>* _messenger;
    FlutterMethodChannel* _channel;
    FlutterMethodChannel* _listPlayerchannel;
    UIView *playerView;
}

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation AliPlayerFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        [AliPlayer setEnableLog:YES];
        [AliPlayer setLogCallbackInfo:LOG_LEVEL_DEBUG callbackBlock:nil];
        
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
        
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_aliplayer_event" binaryMessenger:messenger];
        [eventChannel setStreamHandler:self];
        
    }
    return self;
}

#pragma mark - FlutterStreamHandler
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)eventSink{
    self.eventSink = eventSink;
    return nil;
}
 
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
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

- (void)destroy:(NSArray*)arr {
    AliPlayer *player = arr[2];
    [player destroy];
    if([player isKindOfClass:AliListPlayer.class]){
        self.aliListPlayer = nil;
    }else{
        self.aliPlayer = nil;
    }
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

- (void)setVidAuth:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    AVPVidAuthSource *source = [[AVPVidAuthSource alloc] init];
    NSDictionary *dic = call.arguments;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if([obj length]>0){
            [source setValue:obj forKey:(NSString *)key];
        }
    }];
    [player setAuthSource:source];
}

- (void)setVidMps:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliPlayer *player = arr[2];
    AVPVidMpsSource *source = [[AVPVidMpsSource alloc] init];
    NSDictionary *dic = [call.arguments removeNull];
    [source setVid:dic[@"vid"]];
    [source setAccId:dic[@"accessKeyId"]];
    [source setRegion:dic[@"region"]];
    [source setStsToken:dic[@"securityToken"]];
    [source setAccSecret:dic[@"accessKeySecret"]];
    [source setPlayDomain:dic[@"playDomain"]];
    [source setAuthInfo:dic[@"authInfo"]];
    [source setMtsHlsUriToken:dic[@"hlsUriToken"]];
    [player setMpsSource:source];
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
    NSDictionary *dic = [[call arguments] removeNull];
    
    NSString *aacId = [dic getStrByKey:@"accId"];
    if (aacId.length>0) {
        [player moveTo:dic[@"uid"] accId:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
    }else{
        [player moveTo:dic[@"uid"]];
    }
}

- (void)moveToNext:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [[call arguments] removeNull];
    [player moveToNext:dic[@"accId"] accKey:dic[@"accKey"] token:dic[@"token"] region:dic[@"region"]];
}

- (void)getMediaInfo:(NSArray*)arr {
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    AVPMediaInfo * info = [player getMediaInfo];
    NSLog(@"getMediaInfo==%@",info.mj_JSONString);
    result(info.mj_keyValues);
}

- (void)getCurrentTrack:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    FlutterResult result = arr[1];
    AliPlayer *player = arr[2];
    NSNumber *idxNum = call.arguments;
    AVPTrackInfo * info = [player getCurrentTrack:idxNum.intValue];
    NSLog(@"getCurrentTrack==%@",info.mj_JSONString);
    result(info.mj_keyValues);
}

- (void)selectTrack:(NSArray*)arr {
    FlutterMethodCall* call = arr.firstObject;
    AliListPlayer *player = arr[2];
    NSDictionary *dic = [[call arguments] removeNull];
    NSNumber *trackIdxNum = dic[@"trackIdx"];
    NSNumber *accurateNum = dic[@"accurate"];
    if (accurateNum.intValue==-1) {
        [player selectTrack:trackIdxNum.intValue];
    }else{
        [player selectTrack:trackIdxNum.intValue accurate:accurateNum.boolValue];
    }
    
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


#pragma mark AVPDelegate

/**
 @brief 错误代理回调
 @param player 播放器player指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
  
}

- (void)onSEIData:(AliPlayer*)player type:(int)type data:(NSData *)data {
    NSString *str = [NSString stringWithUTF8String:data.bytes];
    NSLog(@"SEI: %@", str);
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventType 播放器事件类型，@see AVPEventType
 */
-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone:
            self.eventSink(@{kAliPlayerMethod:@"onPrepared"});
            break;
            
        default:
            break;
    }
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventWithString 播放器事件类型
 @param description 播放器事件说明
 @see AVPEventType
 */
-(void)onPlayerEvent:(AliPlayer*)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description {
 
}

/**
 @brief 视频当前播放位置回调
 @param player 播放器player指针
 @param position 视频当前播放位置
 */
- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    
}

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
- (void)onBufferedPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    
}

/**
 @brief 获取track信息回调
 @param player 播放器player指针
 @param info track流信息数组 参考AVPTrackInfo
 */
- (void)onTrackReady:(AliPlayer*)player info:(NSArray<AVPTrackInfo*>*)info {
    self.eventSink(@{kAliPlayerMethod:@"onTrackReady"});
}

/**
 @brief 字幕显示回调
 @param player 播放器player指针
 @param trackIndex 字幕流索引.
 @param subtitleID  字幕ID.
 @param subtitle 字幕显示的字符串
 */
- (void)onSubtitleShow:(AliPlayer*)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID subtitle:(NSString *)subtitle {
    
}

/**
 @brief 字幕隐藏回调
 @param player 播放器player指针
 @param trackIndex 字幕流索引.
 @param subtitleID  字幕ID.
 */
- (void)onSubtitleHide:(AliPlayer*)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID {
    
}

/**
 @brief 获取截图回调
 @param player 播放器player指针
 @param image 图像
 */
- (void)onCaptureScreen:(AliPlayer *)player image:(UIImage *)image {
    
}

/**
 @brief track切换完成回调
 @param player 播放器player指针
 @param info 切换后的信息 参考AVPTrackInfo
 */
- (void)onTrackChanged:(AliPlayer*)player info:(AVPTrackInfo*)info {
    NSLog(@"onTrackChanged==%@",info.mj_JSONString);
    self.eventSink(@{kAliPlayerMethod:@"onTrackChanged",@"info":info.mj_keyValues});
}

/**
 @brief 获取缩略图成功回调
 @param positionMs 指定的缩略图位置
 @param fromPos 此缩略图的开始位置
 @param toPos 此缩略图的结束位置
 @param image 缩图略图像指针,对于mac是NSImage，iOS平台是UIImage指针
 */
- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    
}

/**
 @brief 获取缩略图失败回调
 @param positionMs 指定的缩略图位置
 */
- (void)onGetThumbnailFailed:(int64_t)positionMs {
    
}

/**
 @brief 视频缓冲进度回调
 @param player 播放器player指针
 @param progress 缓存进度0-100
 */
- (void)onLoadingProgress:(AliPlayer*)player progress:(float)progress {
    
}

/**
 @brief 外挂字幕被添加
 @param player 播放器player指针
 @param trackIndex 字幕显示的索引号
 @param URL 字幕url
 */
- (void)onSubtitleExtAdded:(AliPlayer*)player trackIndex:(int)trackIndex URL:(NSString *)URL {
    
}

@end

