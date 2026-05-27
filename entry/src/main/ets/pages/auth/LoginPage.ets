// 登录页面 - 清新校园风格
import { AppColors, AppFontSize, AppSpacing, AppRadius, OnlineImages } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { UserRole } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct LoginPage {
  @State username: string = ''
  @State password: string = ''
  @State isLoading: boolean = false
  @State showPassword: boolean = false
  private dataService: DataService = DataService.getInstance()

  async handleLogin() {
    if (!this.username || !this.password) {
      promptAction.showToast({ message: '请输入用户名和密码', duration: 2000 })
      return
    }
    this.isLoading = true
    try {
      const user = await this.dataService.login(this.username, this.password)
      if (user) {
        promptAction.showToast({ message: `欢迎回来，${user.realName}`, duration: 1500 })
        switch (user.role) {
          case UserRole.ADMIN:
            RouterUtil.replaceUrl(PageRoutes.ADMIN_HOME)
            break
          case UserRole.LEADER:
            RouterUtil.replaceUrl(PageRoutes.LEADER_HOME)
            break
          default:
            RouterUtil.replaceUrl(PageRoutes.STUDENT_HOME)
            break
        }
      } else {
        promptAction.showToast({ message: '用户名或密码错误', duration: 2000 })
      }
    } catch (e) {
      promptAction.showToast({ message: '登录失败，请重试', duration: 2000 })
    }
    this.isLoading = false
  }

  build() {
    Stack() {
      // 背景
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [['#E8F5E9', 0], ['#F1F8E9', 0.4], ['#FFFFFF', 1]]
        })

      Column() {
        // 顶部装饰
        Column() {
          // Logo区域
          Image(OnlineImages.BANNER_CAMPUS)
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Cover)
            .borderRadius({ bottomLeft: 30, bottomRight: 30 })
            .opacity(0.85)
        }
        .width('100%')

        // 登录表单区域
        Column({ space: 0 }) {
          // 标题
          Column({ space: 6 }) {
            Text('校园社团管理系统')
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)

            Text('Campus Club Management System')
              .fontSize(13)
              .fontColor(AppColors.TEXT_HINT)
              .letterSpacing(1)
          }
          .margin({ top: 30, bottom: 30 })

          // 用户名输入
          Column({ space: 8 }) {
            Text('用户名')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
              .alignSelf(ItemAlign.Start)

            Row() {
              Text('👤')
                .fontSize(18)
                .margin({ right: 10 })
              TextInput({ placeholder: '请输入用户名', text: this.username })
                .layoutWeight(1)
                .backgroundColor(Color.Transparent)
                .fontSize(AppFontSize.BODY)
                .onChange((val: string) => { this.username = val })
            }
            .width('100%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .backgroundColor(AppColors.BG_INPUT)
            .borderRadius(AppRadius.MD)
            .border({ width: 1, color: AppColors.BORDER_LIGHT })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 密码输入
          Column({ space: 8 }) {
            Text('密码')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
              .alignSelf(ItemAlign.Start)

            Row() {
              Text('🔒')
                .fontSize(18)
                .margin({ right: 10 })
              TextInput({ placeholder: '请输入密码', text: this.password })
                .layoutWeight(1)
                .backgroundColor(Color.Transparent)
                .fontSize(AppFontSize.BODY)
                .type(this.showPassword ? InputType.Normal : InputType.Password)
                .onChange((val: string) => { this.password = val })
              Text(this.showPassword ? '🙈' : '👁')
                .fontSize(18)
                .onClick(() => { this.showPassword = !this.showPassword })
            }
            .width('100%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .backgroundColor(AppColors.BG_INPUT)
            .borderRadius(AppRadius.MD)
            .border({ width: 1, color: AppColors.BORDER_LIGHT })
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 快捷登录提示
          Row() {
            Text('测试账号: admin/leader1/student1  密码: 123456')
              .fontSize(11)
              .fontColor(AppColors.TEXT_HINT)
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ bottom: 24 })

          // 登录按钮
          Button(this.isLoading ? '登录中...' : '登 录')
            .width('100%')
            .height(50)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppRadius.LG)
            .enabled(!this.isLoading)
            .onClick(() => { this.handleLogin() })

          // 注册入口
          Row({ space: 4 }) {
            Text('还没有账号？')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
            Text('立即注册')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.PRIMARY)
              .fontWeight(FontWeight.Medium)
              .onClick(() => { RouterUtil.pushUrl(PageRoutes.REGISTER) })
          }
          .margin({ top: 20 })
        }
        .width('100%')
        .padding({ left: 32, right: 32 })

        // 底部
        Blank()
        Text('基于鸿蒙端云协同开发')
          .fontSize(11)
          .fontColor(AppColors.TEXT_HINT)
          .margin({ bottom: 30 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
