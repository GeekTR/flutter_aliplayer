package com.alibaba.fplayer.flutter_aliplayer;

import android.graphics.Bitmap;
import android.text.TextUtils;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.FilterConfig;
import com.aliyun.player.IPlayer;
import com.aliyun.player.VidPlayerConfigGen;
import com.aliyun.player.nativeclass.CacheConfig;
import com.aliyun.player.nativeclass.MediaInfo;
import com.aliyun.player.nativeclass.PlayerConfig;
import com.aliyun.player.nativeclass.Thumbnail;
import com.aliyun.player.nativeclass.TrackInfo;
import com.aliyun.player.source.Definition;
import com.aliyun.player.source.LiveSts;
import com.aliyun.player.source.StsInfo;
import com.aliyun.player.source.UrlSource;
import com.aliyun.player.source.VidAuth;
import com.aliyun.player.source.VidMps;
import com.aliyun.player.source.VidSts;
import com.aliyun.thumbnail.ThumbnailBitmapInfo;
import com.aliyun.thumbnail.ThumbnailHelper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterAliPlayer extends FlutterPlayerBase {

    private final Gson mGson;
    private ThumbnailHelper mThumbnailHelper;
    private AliPlayer mAliPlayer;

    public FlutterAliPlayer(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, String playerId) {
        this.mPlayerId = playerId;
        this.mContext = flutterPluginBinding.getApplicationContext();
        mGson = new Gson();
        mAliPlayer = AliPlayerFactory.createAliPlayer(mContext);
        initListener(mAliPlayer);
    }

    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "setUrl":
                String url = methodCall.argument("arg");
                setDataSource(mAliPlayer, url);
                result.success(null);
                break;
            case "setPlayerView":
                break;
            case "setVidSts":
                Map<String, Object> stsMap = (Map<String, Object>) methodCall.argument("arg");
                VidSts vidSts = new VidSts();
                vidSts.setRegion((String) stsMap.get("region"));
                vidSts.setVid((String) stsMap.get("vid"));
                vidSts.setAccessKeyId((String) stsMap.get("accessKeyId"));
                vidSts.setAccessKeySecret((String) stsMap.get("accessKeySecret"));
                vidSts.setSecurityToken((String) stsMap.get("securityToken"));
                vidSts.setQuality((String) stsMap.get("quality"), (Boolean) stsMap.get("forceQuality"));

                List<String> stsMaplist = (List<String>) stsMap.get("definitionList");
                if (stsMaplist != null) {
                    List<Definition> definitionList = new ArrayList<>();
                    for (String item : stsMaplist) {
                        if (Definition.DEFINITION_AUTO.getName().equals(item)) {
                            definitionList.add(Definition.DEFINITION_AUTO);
                        } else {
                            if (Definition.DEFINITION_FD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_FD);
                            } else if (Definition.DEFINITION_LD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_LD);
                            } else if (Definition.DEFINITION_SD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SD);
                            } else if (Definition.DEFINITION_HD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HD);
                            } else if (Definition.DEFINITION_OD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_OD);
                            } else if (Definition.DEFINITION_2K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_2K);
                            } else if (Definition.DEFINITION_4K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_4K);
                            } else if (Definition.DEFINITION_SQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SQ);
                            } else if (Definition.DEFINITION_HQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HQ);
                            }
                        }
                    }
                    vidSts.setDefinition(definitionList);
                }

                if (stsMap.containsKey("previewTime") && !TextUtils.isEmpty((CharSequence) stsMap.get("previewTime"))) {
                    VidPlayerConfigGen vidPlayerConfigGen = new VidPlayerConfigGen();
                    int previewTime = Integer.valueOf((String) stsMap.get("previewTime"));
                    vidPlayerConfigGen.setPreviewTime(previewTime);
                    vidSts.setPlayConfig(vidPlayerConfigGen);
                }
                setDataSource(mAliPlayer, vidSts);
                result.success(null);
                break;
            case "setVidAuth":
                Map<String, Object> authMap = (Map<String, Object>) methodCall.argument("arg");
                VidAuth vidAuth = new VidAuth();
                vidAuth.setVid((String) authMap.get("vid"));
                vidAuth.setRegion((String) authMap.get("region"));
                vidAuth.setPlayAuth((String) authMap.get("playAuth"));
                vidAuth.setQuality((String) authMap.get("quality"), (Boolean) authMap.get("forceQuality"));

                List<String> authMaplist = (List<String>) authMap.get("definitionList");
                if (authMaplist != null) {
                    List<Definition> definitionList = new ArrayList<>();
                    for (String item : authMaplist) {
                        if (Definition.DEFINITION_AUTO.getName().equals(item)) {
                            definitionList.add(Definition.DEFINITION_AUTO);
                        } else {
                            if (Definition.DEFINITION_FD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_FD);
                            } else if (Definition.DEFINITION_LD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_LD);
                            } else if (Definition.DEFINITION_SD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SD);
                            } else if (Definition.DEFINITION_HD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HD);
                            } else if (Definition.DEFINITION_OD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_OD);
                            } else if (Definition.DEFINITION_2K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_2K);
                            } else if (Definition.DEFINITION_4K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_4K);
                            } else if (Definition.DEFINITION_SQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SQ);
                            } else if (Definition.DEFINITION_HQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HQ);
                            }
                        }
                    }
                    vidAuth.setDefinition(definitionList);
                }

                if (authMap.containsKey("previewTime") && !TextUtils.isEmpty((String) authMap.get("previewTime"))) {
                    VidPlayerConfigGen vidPlayerConfigGen = new VidPlayerConfigGen();
                    int previewTime = Integer.valueOf((String) authMap.get("previewTime"));
                    vidPlayerConfigGen.setPreviewTime(previewTime);
                    vidAuth.setPlayConfig(vidPlayerConfigGen);
                }
                setDataSource(mAliPlayer, vidAuth);
                result.success(null);
                break;
            case "setVidMps":
                Map<String, Object> mpsMap = (Map<String, Object>) methodCall.argument("arg");
                VidMps vidMps = new VidMps();
                vidMps.setMediaId((String) mpsMap.get("vid"));
                vidMps.setRegion((String) mpsMap.get("region"));
                vidMps.setAccessKeyId((String) mpsMap.get("accessKeyId"));
                vidMps.setAccessKeySecret((String) mpsMap.get("accessKeySecret"));

                List<String> mpsMaplist = (List<String>) mpsMap.get("definitionList");
                if (mpsMaplist != null) {
                    List<Definition> definitionList = new ArrayList<>();
                    for (String item : mpsMaplist) {
                        if (Definition.DEFINITION_AUTO.getName().equals(item)) {
                            definitionList.add(Definition.DEFINITION_AUTO);
                        } else {
                            if (Definition.DEFINITION_FD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_FD);
                            } else if (Definition.DEFINITION_LD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_LD);
                            } else if (Definition.DEFINITION_SD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SD);
                            } else if (Definition.DEFINITION_HD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HD);
                            } else if (Definition.DEFINITION_OD.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_OD);
                            } else if (Definition.DEFINITION_2K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_2K);
                            } else if (Definition.DEFINITION_4K.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_4K);
                            } else if (Definition.DEFINITION_SQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_SQ);
                            } else if (Definition.DEFINITION_HQ.getName().equals(item)) {
                                definitionList.add(Definition.DEFINITION_HQ);
                            }
                        }
                    }
                    vidMps.setDefinition(definitionList);
                }

                if (mpsMap.containsKey("playDomain") && !TextUtils.isEmpty((String) mpsMap.get("playDomain"))) {
                    vidMps.setPlayDomain((String) mpsMap.get("playDomain"));
                }
                vidMps.setAuthInfo((String) mpsMap.get("authInfo"));
                vidMps.setHlsUriToken((String) mpsMap.get("hlsUriToken"));
                vidMps.setSecurityToken((String) mpsMap.get("securityToken"));
                setDataSource(mAliPlayer, vidMps);
                result.success(null);
                break;
            case "setLiveSts":
                Map<String, Object> liveStsMap = methodCall.argument("arg");
                String liveStsUrl = (String) liveStsMap.get("url");
                String liveStsAccessKeyId = (String) liveStsMap.get("accessKeyId");
                String liveStsAccessKeySecret = (String) liveStsMap.get("accessKeySecret");
                String liveStsSecurityToken = (String) liveStsMap.get("securityToken");
                String liveStsRegion = (String) liveStsMap.get("region");
                String liveStsDomain = (String) liveStsMap.get("domain");
                String liveStsApp = (String) liveStsMap.get("app");
                String liveStsStream = (String) liveStsMap.get("stream");
                List<String> liveStsDefinitionList = (List<String>) liveStsMap.get("definitionList");
                LiveSts liveSts = new LiveSts();
                liveSts.setUrl(liveStsUrl);
                liveSts.setAccessKeyId(liveStsAccessKeyId);
                liveSts.setAccessKeySecret(liveStsAccessKeySecret);
                liveSts.setSecurityToken(liveStsSecurityToken);
                liveSts.setRegion(liveStsRegion);
                liveSts.setDomain(liveStsDomain);
                liveSts.setApp(liveStsApp);
                liveSts.setStream(liveStsStream);
                setDataSource(mAliPlayer, liveSts);
                result.success(null);
                break;
            case "updateLiveStsInfo":
                Map<String, Object> updateLiveStsInfoMap = methodCall.argument("arg");
                String updateLiveStsInfoAccessKeyId = (String) updateLiveStsInfoMap.get("accId");
                String updateLiveStsInfoAccessKeySecret = (String) updateLiveStsInfoMap.get("accKey");
                String updateLiveStsSecurityToken = (String) updateLiveStsInfoMap.get("token");
                String updateLiveStsRegion = (String) updateLiveStsInfoMap.get("region");
                StsInfo stsInfo = new StsInfo();
                stsInfo.setAccessKeyId(updateLiveStsInfoAccessKeyId);
                stsInfo.setAccessKeySecret(updateLiveStsInfoAccessKeySecret);
                stsInfo.setSecurityToken(updateLiveStsSecurityToken);
                stsInfo.setRegion(updateLiveStsRegion);
                updateLiveStsInfo(mAliPlayer, stsInfo);
                result.success(null);
                break;
            case "prepare":
                prepare(mAliPlayer);
                result.success(null);
                break;
            case "play":
                start(mAliPlayer);
                result.success(null);
                break;
            case "pause":
                pause(mAliPlayer);
                result.success(null);
                break;
            case "stop":
                stop(mAliPlayer);
                result.success(null);
                break;
            case "destroy":
                release(mAliPlayer);
                result.success(null);
                break;
            case "reload":
                reload(mAliPlayer);
                break;
            case "seekTo": {
                Map<String, Object> seekToMap = (Map<String, Object>) methodCall.argument("arg");
                Integer position = (Integer) seekToMap.get("position");
                Integer seekMode = (Integer) seekToMap.get("seekMode");
                seekTo(mAliPlayer, position, seekMode);
                result.success(null);
            }
            break;
            case "getMediaInfo": {
                MediaInfo mediaInfo = getMediaInfo(mAliPlayer);
                if (mediaInfo != null) {
                    Map<String, Object> getMediaInfoMap = new HashMap<>();
                    getMediaInfoMap.put("title", mediaInfo.getTitle());
                    getMediaInfoMap.put("status", mediaInfo.getStatus());
                    getMediaInfoMap.put("mediaType", mediaInfo.getMediaType());
                    getMediaInfoMap.put("duration", mediaInfo.getDuration());
                    getMediaInfoMap.put("transcodeMode", mediaInfo.getTransCodeMode());
                    getMediaInfoMap.put("coverURL", mediaInfo.getCoverUrl());
                    List<Thumbnail> thumbnail = mediaInfo.getThumbnailList();
                    List<Map<String, Object>> thumbailList = new ArrayList<>();
                    for (Thumbnail thumb : thumbnail) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("url", thumb.mURL);
                        thumbailList.add(map);
                        getMediaInfoMap.put("thumbnails", thumbailList);
                    }
                    List<TrackInfo> trackInfos = mediaInfo.getTrackInfos();
                    List<Map<String, Object>> trackInfoList = new ArrayList<>();
                    for (TrackInfo trackInfo : trackInfos) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("vodFormat", trackInfo.getVodFormat());
                        map.put("videoHeight", trackInfo.getVideoHeight());
                        map.put("videoWidth", trackInfo.getVideoHeight());
                        map.put("subtitleLanguage", trackInfo.getSubtitleLang());
                        map.put("trackBitrate", trackInfo.getVideoBitrate());
                        map.put("vodFileSize", trackInfo.getVodFileSize());
                        map.put("trackIndex", trackInfo.getIndex());
                        map.put("trackDefinition", trackInfo.getVodDefinition());
                        map.put("audioSampleFormat", trackInfo.getAudioSampleFormat());
                        map.put("audioLanguage", trackInfo.getAudioLang());
                        map.put("vodPlayUrl", trackInfo.getVodPlayUrl());
                        map.put("trackType", trackInfo.getType().ordinal());
                        map.put("audioSamplerate", trackInfo.getAudioSampleRate());
                        map.put("audioChannels", trackInfo.getAudioChannels());
                        trackInfoList.add(map);
                        getMediaInfoMap.put("tracks", trackInfoList);
                    }
                    result.success(getMediaInfoMap);
                }
            }
            break;
            case "snapshot":
                mSnapShotPath = methodCall.argument("arg").toString();
                snapshot(mAliPlayer);
                result.success(null);
                break;
            case "setLoop":
                setLoop(mAliPlayer, (Boolean) methodCall.argument("arg"));
                result.success(null);
                break;
            case "isLoop":
                result.success(isLoop(mAliPlayer));
                break;
            case "setAutoPlay":
                setAutoPlay(mAliPlayer, (Boolean) methodCall.argument("arg"));
                result.success(null);
                break;
            case "isAutoPlay":
                result.success(isAutoPlay(mAliPlayer));
                break;
            case "setMuted":
                setMuted(mAliPlayer, (Boolean) methodCall.argument("arg"));
                result.success(null);
                break;
            case "isMuted":
                result.success(isMuted(mAliPlayer));
                break;
            case "setEnableHardwareDecoder":
                Boolean setEnableHardwareDecoderArgumnt = (Boolean) methodCall.argument("arg");
                setEnableHardWareDecoder(mAliPlayer, setEnableHardwareDecoderArgumnt);
                result.success(null);
                break;
            case "setScalingMode":
                setScaleMode(mAliPlayer, (Integer) methodCall.argument("arg"));
                result.success(null);
                break;
            case "getScalingMode":
                result.success(getScaleMode(mAliPlayer));
                break;
            case "setMirrorMode":
                setMirrorMode(mAliPlayer, (Integer) methodCall.argument("arg"));
                result.success(null);
                break;
            case "getMirrorMode":
                result.success(getMirrorMode(mAliPlayer));
                break;
            case "setRotateMode":
                setRotateMode(mAliPlayer, (Integer) methodCall.argument("arg"));
                result.success(null);
                break;
            case "getRotateMode":
                result.success(getRotateMode(mAliPlayer));
                break;
            case "setRate":
                setSpeed(mAliPlayer, (Double) methodCall.argument("arg"));
                result.success(null);
                break;
            case "getRate":
                result.success(getSpeed(mAliPlayer));
                break;
            case "setVideoBackgroundColor":
                setVideoBackgroundColor(mAliPlayer, (Long) methodCall.argument("arg"));
                result.success(null);
                break;
            case "setVolume":
                setVolume(mAliPlayer, (Double) methodCall.argument("arg"));
                result.success(null);
                break;
            case "getVolume":
                result.success(getVolume(mAliPlayer));
                break;
            case "setConfig": {
                Map<String, Object> setConfigMap = (Map<String, Object>) methodCall.argument("arg");
                PlayerConfig config = getConfig(mAliPlayer);
                if (config != null) {
                    String configJson = mGson.toJson(setConfigMap);
                    config = mGson.fromJson(configJson, PlayerConfig.class);
                    setConfig(mAliPlayer, config);
                }
                result.success(null);
            }
            break;
            case "getConfig":
                PlayerConfig config = getConfig(mAliPlayer);
                String json = mGson.toJson(config);
                Map<String, Object> configMap = mGson.fromJson(json, Map.class);
                result.success(configMap);
                break;
            case "getCacheConfig":
                CacheConfig cacheConfig = getCacheConfig();
                String cacheConfigJson = mGson.toJson(cacheConfig);
                Map<String, Object> cacheConfigMap = mGson.fromJson(cacheConfigJson, Map.class);
                result.success(cacheConfigMap);
                break;
            case "setCacheConfig":
                Map<String, Object> setCacheConnfigMap = (Map<String, Object>) methodCall.argument("arg");
                String setCacheConfigJson = mGson.toJson(setCacheConnfigMap);
                CacheConfig setCacheConfig = mGson.fromJson(setCacheConfigJson, CacheConfig.class);
                setCacheConfig(mAliPlayer, setCacheConfig);
                result.success(null);
                break;
            case "getCurrentTrack":
                Integer currentTrackIndex = (Integer) methodCall.argument("arg");
                TrackInfo currentTrack = getCurrentTrack(mAliPlayer, currentTrackIndex);
                if (currentTrack != null) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("vodFormat", currentTrack.getVodFormat());
                    map.put("videoHeight", currentTrack.getVideoHeight());
                    map.put("videoWidth", currentTrack.getVideoHeight());
                    map.put("subtitleLanguage", currentTrack.getSubtitleLang());
                    map.put("trackBitrate", currentTrack.getVideoBitrate());
                    map.put("vodFileSize", currentTrack.getVodFileSize());
                    map.put("trackIndex", currentTrack.getIndex());
                    map.put("trackDefinition", currentTrack.getVodDefinition());
                    map.put("audioSampleFormat", currentTrack.getAudioSampleFormat());
                    map.put("audioLanguage", currentTrack.getAudioLang());
                    map.put("vodPlayUrl", currentTrack.getVodPlayUrl());
                    map.put("trackType", currentTrack.getType().ordinal());
                    map.put("audioSamplerate", currentTrack.getAudioSampleRate());
                    map.put("audioChannels", currentTrack.getAudioChannels());
                    result.success(map);
                }
                break;
            case "selectTrack":
                Map<String, Object> selectTrackMap = (Map<String, Object>) methodCall.argument("arg");
                Integer trackIdx = (Integer) selectTrackMap.get("trackIdx");
                Integer accurate = (Integer) selectTrackMap.get("accurate");
                selectTrack(mAliPlayer, trackIdx, accurate == 1);
                result.success(null);
                break;
            case "addExtSubtitle":
                String extSubtitlUrl = (String) methodCall.argument("arg");
                addExtSubtitle(mAliPlayer, extSubtitlUrl);
                result.success(null);
                break;
            case "selectExtSubtitle":
                Map<String, Object> selectExtSubtitleMap = (Map<String, Object>) methodCall.argument("arg");
                Integer trackIndex = (Integer) selectExtSubtitleMap.get("trackIndex");
                Boolean selectExtSubtitlEnable = (Boolean) selectExtSubtitleMap.get("enable");
                selectExtSubtitle(mAliPlayer, trackIndex, selectExtSubtitlEnable);
                result.success(null);
                break;
            case "createThumbnailHelper":
                String thhumbnailUrl = (String) methodCall.argument("arg");
                createThumbnailHelper(thhumbnailUrl);
                result.success(null);
                break;
            case "requestBitmapAtPosition":
                Integer requestBitmapProgress = (Integer) methodCall.argument("arg");
                requestBitmapAtPosition(requestBitmapProgress);
                result.success(null);
                break;
            case "setPreferPlayerName":
                String playerName = methodCall.argument("arg");
                setPlayerName(mAliPlayer, playerName);
                result.success(null);
                break;
            case "getPlayerName":
                result.success(getPlayerName(mAliPlayer));
                break;
            case "setStreamDelayTime":
                Map<String, Object> streamDelayTimeMap = (Map<String, Object>) methodCall.argument("arg");
                Integer index = (Integer) streamDelayTimeMap.get("index");
                Integer time = (Integer) streamDelayTimeMap.get("time");
                setStreamDelayTime(mAliPlayer, index, time);
                result.success(null);
                break;
            case "setMaxAccurateSeekDelta":
                Integer maxAccurateSeekDelta = methodCall.argument("arg");
                setMaxAccurateSeekDelta(mAliPlayer, maxAccurateSeekDelta);
                result.success(null);
                break;
            case "setDefaultBandWidth":
                Integer defaultBandWidth = methodCall.argument("arg");
                setDefaultBandWidth(mAliPlayer, defaultBandWidth);
                result.success(null);
                break;
            case "setFastStart":
                Boolean fastStart = methodCall.argument("arg");
                setFastStart(mAliPlayer, fastStart);
                result.success(null);
                break;
            case "setFilterConfig":
                String setFilterConfigJson = methodCall.argument("arg");
                FilterConfig filterConfig = new FilterConfig();
                List<FlutterAliPlayerFilterConfigBean> flutterAliPlayerFilterConfigBeanList = mGson.fromJson(setFilterConfigJson, new TypeToken<List<FlutterAliPlayerFilterConfigBean>>() {
                }.getType());
                for (FlutterAliPlayerFilterConfigBean flutterAliPlayerFilterConfigBean : flutterAliPlayerFilterConfigBeanList) {
                    String target = flutterAliPlayerFilterConfigBean.getTarget();
                    FilterConfig.Filter filter = new FilterConfig.Filter(target);
                    List<String> options = flutterAliPlayerFilterConfigBean.getOptions();
                    if (options != null && options.size() > 0) {
                        for (String option : options) {
                            FilterConfig.FilterOptions filterOptions = new FilterConfig.FilterOptions();
                            filterOptions.setOption(option, 0);
                            filter.setOptions(filterOptions);
                        }
                    }
                    filterConfig.addFilter(filter);
                }
                setFilterConfig(mAliPlayer, filterConfig);
                break;
            case "updateFilterConfig":
                Map<String, Object> updateFilterConfig = methodCall.argument("arg");
                String updateFilterConfigTarget = (String) updateFilterConfig.get("target");
                Map<String, Object> updateFilterConfigOptionsMap = (Map<String, Object>) updateFilterConfig.get("options");
                Set<String> updateFilterConfigOptionsMapKey = updateFilterConfigOptionsMap.keySet();
                FilterConfig.FilterOptions updateFilterConfigFilterOptions = new FilterConfig.FilterOptions();
                for (String key : updateFilterConfigOptionsMapKey) {
                    updateFilterConfigFilterOptions.setOption(key, updateFilterConfigOptionsMap.get(key));
                }
                updateFilterConfig(mAliPlayer, updateFilterConfigTarget, updateFilterConfigFilterOptions);

                break;
            case "setFilterInvalid":
                Map<String, Object> setFilterInvalidMap = methodCall.argument("arg");
                String setFilterInvalidTarget = (String) setFilterInvalidMap.get("target");
                boolean setFilterInvalidBoolean = Boolean.parseBoolean((String) setFilterInvalidMap.get("invalid"));
                setFilterInvalid(mAliPlayer, setFilterInvalidTarget, setFilterInvalidBoolean);
                break;
            case "clearScreen":
                mAliPlayer.clearScreen();
                result.success(null);
                break;
            case "setTraceID":
                String traceId = methodCall.argument("arg");
                mAliPlayer.setTraceId(traceId);
                result.success(null);
                break;
            case "getCacheFilePath":
                String getCacheFilePathUrl = (String) methodCall.arguments;
                result.success(getCacheFilePath(mAliPlayer, getCacheFilePathUrl));
                break;
            case "getCacheFilePathWithVid":
                Map<String, Object> getCacheFilePathWithVidMap = (Map<String, Object>) methodCall.arguments;
                String vid = (String) getCacheFilePathWithVidMap.get("vid");
                String format = (String) getCacheFilePathWithVidMap.get("format");
                String definition = (String) getCacheFilePathWithVidMap.get("definition");
                result.success(getCacheFilePathWithVid(mAliPlayer, vid, format, definition));
                break;
            case "getPropertyString":
                String getPropertyString = methodCall.arguments();
                result.success(getPropertyString(mAliPlayer, getPropertyString));
                break;
            case "getOption":
                String getOptionType = (String) methodCall.arguments;
                IPlayer.Option option;
                switch (getOptionType) {
                    case "download_bitrate":
                        option = IPlayer.Option.DownloadBitrate;
                        break;
                    case "video_bitrate":
                        option = IPlayer.Option.VideoBitrate;
                        break;
                    case "audio_bitrate":
                        option = IPlayer.Option.AudioBitrate;
                        break;
                    default:
                        option = IPlayer.Option.RenderFPS;
                        break;
                }
                result.success(getOption(mAliPlayer, option));
                break;
            case "sendCustomEvent":
                Map<String,Object> sendCustomEventMap = methodCall.arguments();
                String sendCustomArgs = (String) sendCustomEventMap.get("arg");
                sendCustomEvent(mAliPlayer, sendCustomArgs);
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public IPlayer getAliPlayer() {
        return mAliPlayer;
    }

    private void setDataSource(AliPlayer mAliPlayer, String url) {
        if (mAliPlayer != null) {
            UrlSource urlSource = new UrlSource();
            urlSource.setUri(url);
            ((AliPlayer) mAliPlayer).setDataSource(urlSource);
        }
    }

    private void setDataSource(AliPlayer mAliPlayer, VidSts vidSts) {
        if (mAliPlayer != null) {
            ((AliPlayer) mAliPlayer).setDataSource(vidSts);
        }
    }

    private void setDataSource(AliPlayer mAliPlayer, VidAuth vidAuth) {
        if (mAliPlayer != null) {
            ((AliPlayer) mAliPlayer).setDataSource(vidAuth);
        }
    }

    private void setDataSource(AliPlayer mAliPlayer, VidMps vidMps) {
        if (mAliPlayer != null) {
            ((AliPlayer) mAliPlayer).setDataSource(vidMps);
        }
    }

    private void setDataSource(AliPlayer mAliPlayer, LiveSts liveSts) {
        if (mAliPlayer != null) {
            ((AliPlayer) mAliPlayer).setDataSource(liveSts);
        }
    }

    private void prepare(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.prepare();
        }
    }

    private void start(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.start();
        }
    }

    private void pause(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.pause();
        }
    }

    private void stop(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.stop();
        }
    }

    private void reload(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.reload();
        }
    }

    private void release(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.release();
            mAliPlayer = null;
        }
    }

    private void seekTo(AliPlayer mAliPlayer, long position, int seekMode) {
        if (mAliPlayer != null) {
            IPlayer.SeekMode mSeekMode;
            if (seekMode == IPlayer.SeekMode.Accurate.getValue()) {
                mSeekMode = IPlayer.SeekMode.Accurate;
            } else {
                mSeekMode = IPlayer.SeekMode.Inaccurate;
            }
            mAliPlayer.seekTo(position, mSeekMode);
        }
    }


    private MediaInfo getMediaInfo(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            return mAliPlayer.getMediaInfo();
        }
        return null;
    }

    private void snapshot(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            mAliPlayer.snapshot();
        }
    }

    private void setLoop(AliPlayer mAliPlayer, Boolean isLoop) {
        if (mAliPlayer != null) {
            mAliPlayer.setLoop(isLoop);
        }
    }

    private Boolean isLoop(AliPlayer mAliPlayer) {
        return mAliPlayer != null && mAliPlayer.isLoop();
    }

    private void setAutoPlay(AliPlayer mAliPlayer, Boolean isAutoPlay) {
        if (mAliPlayer != null) {
            mAliPlayer.setAutoPlay(isAutoPlay);
        }
    }

    private Boolean isAutoPlay(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            return mAliPlayer.isAutoPlay();
        }
        return false;
    }

    private void setMuted(AliPlayer mAliPlayer, Boolean muted) {
        if (mAliPlayer != null) {
            mAliPlayer.setMute(muted);
        }
    }

    private Boolean isMuted(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            return mAliPlayer.isMute();
        }
        return false;
    }

    private void setEnableHardWareDecoder(AliPlayer mAliPlayer, Boolean mEnableHardwareDecoder) {
        if (mAliPlayer != null) {
            mAliPlayer.enableHardwareDecoder(mEnableHardwareDecoder);
        }
    }

    private void setScaleMode(AliPlayer mAliPlayer, int model) {
        if (mAliPlayer != null) {
            IPlayer.ScaleMode mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            if (model == IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue()) {
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT;
            } else if (model == IPlayer.ScaleMode.SCALE_ASPECT_FILL.getValue()) {
                mScaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FILL;
            } else if (model == IPlayer.ScaleMode.SCALE_TO_FILL.getValue()) {
                mScaleMode = IPlayer.ScaleMode.SCALE_TO_FILL;
            }
            mAliPlayer.setScaleMode(mScaleMode);
        }
    }

    private int getScaleMode(AliPlayer mAliPlayer) {
        int scaleMode = IPlayer.ScaleMode.SCALE_ASPECT_FIT.getValue();
        if (mAliPlayer != null) {
            scaleMode = mAliPlayer.getScaleMode().getValue();
        }
        return scaleMode;
    }

    private void setMirrorMode(AliPlayer mAliPlayer, int mirrorMode) {
        if (mAliPlayer != null) {
            IPlayer.MirrorMode mMirrorMode;
            if (mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL.getValue()) {
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_HORIZONTAL;
            } else if (mirrorMode == IPlayer.MirrorMode.MIRROR_MODE_VERTICAL.getValue()) {
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_VERTICAL;
            } else {
                mMirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE;
            }
            mAliPlayer.setMirrorMode(mMirrorMode);
        }
    }

    private int getMirrorMode(AliPlayer mAliPlayer) {
        int mirrorMode = IPlayer.MirrorMode.MIRROR_MODE_NONE.getValue();
        if (mAliPlayer != null) {
            mirrorMode = mAliPlayer.getMirrorMode().getValue();
        }
        return mirrorMode;
    }

    private void setRotateMode(AliPlayer mAliPlayer, int rotateMode) {
        if (mAliPlayer != null) {
            IPlayer.RotateMode mRotateMode;
            if (rotateMode == IPlayer.RotateMode.ROTATE_90.getValue()) {
                mRotateMode = IPlayer.RotateMode.ROTATE_90;
            } else if (rotateMode == IPlayer.RotateMode.ROTATE_180.getValue()) {
                mRotateMode = IPlayer.RotateMode.ROTATE_180;
            } else if (rotateMode == IPlayer.RotateMode.ROTATE_270.getValue()) {
                mRotateMode = IPlayer.RotateMode.ROTATE_270;
            } else {
                mRotateMode = IPlayer.RotateMode.ROTATE_0;
            }
            mAliPlayer.setRotateMode(mRotateMode);
        }
    }

    private int getRotateMode(AliPlayer mAliPlayer) {
        int rotateMode = IPlayer.RotateMode.ROTATE_0.getValue();
        if (mAliPlayer != null) {
            rotateMode = mAliPlayer.getRotateMode().getValue();
        }
        return rotateMode;
    }

    private void setSpeed(AliPlayer mAliPlayer, double speed) {
        if (mAliPlayer != null) {
            mAliPlayer.setSpeed((float) speed);
        }
    }

    private double getSpeed(AliPlayer mAliPlayer) {
        double speed = 0;
        if (mAliPlayer != null) {
            speed = mAliPlayer.getSpeed();
        }
        return speed;
    }

    private void setVideoBackgroundColor(AliPlayer mAliPlayer, long color) {
        if (mAliPlayer != null) {
            mAliPlayer.setVideoBackgroundColor((int) color);
        }
    }

    private void setVolume(AliPlayer mAliPlayer, double volume) {
        if (mAliPlayer != null) {
            mAliPlayer.setVolume((float) volume);
        }
    }

    private double getVolume(AliPlayer mAliPlayer) {
        double volume = 1.0;
        if (mAliPlayer != null) {
            volume = mAliPlayer.getVolume();
        }
        return volume;
    }

    private void setConfig(AliPlayer mAliPlayer, PlayerConfig playerConfig) {
        if (mAliPlayer != null) {
            mAliPlayer.setConfig(playerConfig);
        }
    }

    private PlayerConfig getConfig(AliPlayer mAliPlayer) {
        if (mAliPlayer != null) {
            return mAliPlayer.getConfig();
        }
        return null;
    }

    private CacheConfig getCacheConfig() {
        return new CacheConfig();
    }

    private void setCacheConfig(AliPlayer mAliPlayer, CacheConfig cacheConfig) {
        if (mAliPlayer != null) {
            mAliPlayer.setCacheConfig(cacheConfig);
        }
    }

    private TrackInfo getCurrentTrack(AliPlayer mAliPlayer, int currentTrackIndex) {
        if (mAliPlayer != null) {
            return mAliPlayer.currentTrack(currentTrackIndex);
        } else {
            return null;
        }
    }

    private void selectTrack(AliPlayer mAliPlayer, int trackId, boolean accurate) {
        if (mAliPlayer != null) {
            mAliPlayer.selectTrack(trackId, accurate);
        }
    }

    private void addExtSubtitle(AliPlayer mAliPlayer, String url) {
        if (mAliPlayer != null) {
            mAliPlayer.addExtSubtitle(url);
        }
    }

    private void selectExtSubtitle(AliPlayer mAliPlayer, int trackIndex, boolean enable) {
        if (mAliPlayer != null) {
            mAliPlayer.selectExtSubtitle(trackIndex, enable);
        }
    }

    private void createThumbnailHelper(String url) {
        mThumbnailHelper = new ThumbnailHelper(url);
        mThumbnailHelper.setOnPrepareListener(new ThumbnailHelper.OnPrepareListener() {
            @Override
            public void onPrepareSuccess() {
                Map<String, Object> map = new HashMap<>();
                map.put("method", "thumbnail_onPrepared_Success");
//                mEventSink.success(map);
                if (mFlutterAliPlayerListener != null) {
                    mFlutterAliPlayerListener.onThumbnailPrepareSuccess(map);
                }
            }

            @Override
            public void onPrepareFail() {
                Map<String, Object> map = new HashMap<>();
                map.put("method", "thumbnail_onPrepared_Fail");
//                mEventSink.success(map);
                if (mFlutterAliPlayerListener != null) {
                    mFlutterAliPlayerListener.onThumbnailPrepareFail(map);
                }
            }
        });

        mThumbnailHelper.setOnThumbnailGetListener(new ThumbnailHelper.OnThumbnailGetListener() {
            @Override
            public void onThumbnailGetSuccess(long l, ThumbnailBitmapInfo thumbnailBitmapInfo) {
                if (thumbnailBitmapInfo != null && thumbnailBitmapInfo.getThumbnailBitmap() != null) {
                    Map<String, Object> map = new HashMap<>();

                    Bitmap thumbnailBitmap = thumbnailBitmapInfo.getThumbnailBitmap();
                    if(thumbnailBitmap != null){
                        ByteArrayOutputStream stream = new ByteArrayOutputStream();
                        thumbnailBitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
                        thumbnailBitmap.recycle();
                        long[] positionRange = thumbnailBitmapInfo.getPositionRange();

                        map.put("method", "onThumbnailGetSuccess");
                        map.put("thumbnailbitmap", stream.toByteArray());
                        map.put("thumbnailRange", positionRange);
//                      mEventSink.success(map);
                        if (mFlutterAliPlayerListener != null) {
                            mFlutterAliPlayerListener.onThumbnailGetSuccess(map);
                        }
                    }
                }
            }

            @Override
            public void onThumbnailGetFail(long l, String s) {
                Map<String, Object> map = new HashMap<>();
                map.put("method", "onThumbnailGetFail");
//                mEventSink.success(map);
                if (mFlutterAliPlayerListener != null) {
                    mFlutterAliPlayerListener.onThumbnailGetFail(map);
                }
            }
        });
        mThumbnailHelper.prepare();
    }

    private void requestBitmapAtPosition(int position) {
        if (mThumbnailHelper != null) {
            mThumbnailHelper.requestBitmapAtPosition(position);
        }
    }

    private void setPlayerName(AliPlayer mAliPlayer, String playerName) {
        if (mAliPlayer != null) {
            mAliPlayer.setPreferPlayerName(playerName);
        }
    }

    private String getPlayerName(AliPlayer mAliPlayer) {
        return mAliPlayer == null ? "" : mAliPlayer.getPlayerName();
    }

    private void setStreamDelayTime(AliPlayer mAliPlayer, int index, int time) {
        if (mAliPlayer != null) {
            mAliPlayer.setStreamDelayTime(index, time);
        }
    }

    private void setMaxAccurateSeekDelta(AliPlayer mAliPlayer, int maxAccurateSeekDelta) {
        if (mAliPlayer != null) {
            mAliPlayer.setMaxAccurateSeekDelta(maxAccurateSeekDelta);
        }
    }

    private void setDefaultBandWidth(AliPlayer mAliPlayer, int defaultBandWidth) {
        if (mAliPlayer != null) {
            mAliPlayer.setDefaultBandWidth(defaultBandWidth);
        }
    }

    private void setFastStart(AliPlayer mAliPlayer, Boolean fastStart) {
        if (mAliPlayer != null) {
            mAliPlayer.setFastStart(fastStart);
        }
    }

    private void updateFilterConfig(AliPlayer mAliPlayer, String updateFilterConfigTarget, FilterConfig.FilterOptions updateFilterConfigFilterOptions) {
        if (mAliPlayer != null) {
            mAliPlayer.updateFilterConfig(updateFilterConfigTarget, updateFilterConfigFilterOptions);
        }
    }

    private void setFilterInvalid(AliPlayer mAliPlayer, String setFilterInvalidTarget, boolean setFilterInvalidBoolean) {
        if (mAliPlayer != null) {
            mAliPlayer.setFilterInvalid(setFilterInvalidTarget, setFilterInvalidBoolean);
        }
    }

    private void setFilterConfig(AliPlayer mAliPlayer, FilterConfig filterConfig) {
        if (mAliPlayer != null) {
            mAliPlayer.setFilterConfig(filterConfig);
        }
    }

    private void sendCustomEvent(AliPlayer mAliPlayer, String sendCustomEvent) {
        if (mAliPlayer != null) {
            mAliPlayer.sendCustomEvent(sendCustomEvent);
        }
    }

    private Object getOption(AliPlayer mAliPlayer, IPlayer.Option option) {
        if (mAliPlayer != null) {
            return mAliPlayer.getOption(option);
        }
        return null;
    }

    private void setIPResolveType(AliPlayer mAliPlayer, IPlayer.IPResolveType type) {
        if (mAliPlayer != null) {
            mAliPlayer.setIPResolveType(type);
        }
    }

    private String getPropertyString(AliPlayer mAliPlayer, String getPropertyString) {
        if (mAliPlayer != null) {
            IPlayer.PropertyKey propertyKey = IPlayer.PropertyKey.valueOf(getPropertyString);
            return mAliPlayer.getPropertyString(propertyKey);
        }
        return null;
    }

    private void updateLiveStsInfo(AliPlayer mAliPlayer, StsInfo stsInfo) {
        if (mAliPlayer != null) {
            mAliPlayer.updateStsInfo(stsInfo);
        }
    }

    private String getCacheFilePathWithVid(AliPlayer mAliPlayer, String vid, String format, String definition) {
        if (mAliPlayer != null) {
            return mAliPlayer.getCacheFilePath(vid, format, definition, 0);
        }
        return null;
    }

    private String getCacheFilePath(AliPlayer mAliPlayer, String url) {
        if (mAliPlayer != null) {
            return mAliPlayer.getCacheFilePath(url);
        }
        return null;
    }
}
