## 5.4.3-dev.2
----------------------------------
1. 集成 Rts 低延时直播无法播放问题

## 5.4.3-dev.1
----------------------------------
1.修复 5.4.2 编译报错问题

## 5.4.2
----------------------------------
1. 增加直播时移功能(测试中)
2. 修复下载无法设置 region 问题
3. 重复创建 AliPlayer 对象，导致先创建的 AliPlayer 对象回调监听失效问题

## 5.4.0
----------------------------------
1. 支持多个播放实例，具体可以参照demo代码`multiple_player_page.dart`
2. 播放器回调添加playerId参数，用于多实例调用的区分
3. 添加`setPlayerView`方法，创建播放器后，需要绑定view到播发器
4. 去除原列表播放器管道，在android和iOS源码层AliListPlayer与AliPlayer公用一个管道
5. `initService`、`getSDKVersion`以及log级别开关等方法改为静态方法，与原生sdk对齐

## 5.2.2
----------------------------------
1. Docking Aliyun Player SDK (PlatForm include Android、iOS)
2. RenderView: Android uses TextureView,iOS uses UIView

