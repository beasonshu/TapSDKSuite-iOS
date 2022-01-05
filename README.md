# TapSDKSuite
## Usage
1. 把 TapSDKSuiteKit.framework 添加到你的工程内并设置为 `Do Not Embed`，导入 TapSDKSuiteResource.bundle
2. 声明头文件 `#import <TapSDKSuiteKit/TapSDKSuiteKit.h>` 
3. 配置功能入口

    ```objectivec
    // 入口数量建议不少于3个以保证显示效果
    NSArray<TapSDKSuiteComponent *>*array = @[[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeMoment,
                                           [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeFirend],
                                           [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeAchievement],
                                           [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeChat],
                                           [[TapSDKSuiteComponent alloc] initWithType:TapSDKSuiteComponentTypeLeaderboard]];

    [[TapSDKSuite shareInstance] setComponentArray:array];
    ```
    目前我们提供了默认的5种功能入口，包含动态、好友、成就、聊天、排行榜。每个功能都可以自行配置标题和图标。当然也可以自定义 type。

    ```objectivec
    // 对于自定义图标，您可以把自己的图标放在 TapSDKSuiteResource.bundle/images 目录下，然后使用如下方法读取。
    UIImage *customUIImage = [TapSDKSuiteUtils getImageFromBundle:@"your image name"];
    [[TapSDKSuiteComponent alloc] initWithType:NSInteger title:@"customTitle" icon:customUIImage];
    ```

4. 处理点击事件
    ```objectivec
    @interface YourClass ()<TapSDKSuiteDelegate>
    
    @end

    @implementation YourClass

    - (void)someMethod {
        [TapSDKSuite shareInstance].delegate = self;
    }
    
    - (void)onItemClick:(TapSDKSuiteComponent *)component {
        switch (component.type) {
            case TapSDKSuiteComponentTypeMoment:
            {
                // open Moment
            }
            break;
            case TapSDKSuiteComponentTypeFirend:
            {
                // open Friend
            }
            break;
            case TapSDKSuiteComponentTypeAchievement:
            {
                // open Achievement
            }
            break;
            case TapSDKSuiteComponentTypeChat:
            {
                // open Chat
            }
            break;
            case TapSDKSuiteComponentTypeLeaderboard:
            {
                // open Leaderboard
            }
            break;

            default:
                break;
        }
    }
    @end
    ```

5. 打开悬浮窗
    ```objectivec
    // 每次应用打开后第一次调用该接口时会有 Tap Logo 的动画来提醒用户，后续再次调用则不再展示。关闭后台进程重新打开应用时会重新播放动画。
    [TapSDKSuite enable];
    ```
6. 关闭悬浮窗
    ```objectivec
    // 贴边的悬浮按钮带有一个滑动和点击的事件响应，如果影响应用自身的一些交互行为，可临时调用此接口关闭悬浮窗
    [TapSDKSuite disable];
    ```

## Tips

TapSDKSuite 暂时不支持自由旋转，在 enable 后只能保证当前展示情况，如果旋转的话需要 调用 diable 后重新 enable.

## License

TapSDKSuite is released under the MIT license. See [LICENSE](LICENSE) for details.