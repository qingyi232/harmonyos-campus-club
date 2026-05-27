import { userStore } from '../store/UserStore';
import { RouterUtil } from '../utils/RouterUtil';
import { Constants } from '../common/Constants';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct Index {
  @State private isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    // 模拟启动加载
    setTimeout(async () => {
      if (userStore.isLogin) {
        await RouterUtil.replace(Constants.ROUTE_HOME);
      } else {
        await RouterUtil.replace(Constants.ROUTE_LOGIN);
      }
    }, 1500);
  }

  build() {
    Column() {
      // Logo区域
      Column() {
        Image(IconUtil.APP_ICON)
          .width(120)
          .height(120)
          .margin({ bottom: 24 })

        Text('校园社团管理系统')
          .fontSize(24)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')

        Text('Campus Club Management')
          .fontSize(14)
          .fontColor('#6B7280')
          .margin({ top: 8 })
      }
      .width('100%')

      Blank()

      // 加载指示器
      if (this.isLoading) {
        LoadingProgress()
          .width(40)
          .height(40)
          .color('#10B981')
          .margin({ bottom: 40 })
      }

      Text('基于鸿蒙端云协同开发')
        .fontSize(12)
        .fontColor('#9CA3AF')
        .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 24, right: 24, top: 80, bottom: 20 })
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#FFFFFF', 0.0], ['#F9FAFB', 1.0]]
    })
  }
}
