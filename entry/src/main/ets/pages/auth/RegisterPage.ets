// 注册页面
import { AppColors, AppFontSize, AppSpacing, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct RegisterPage {
  @State username: string = ''
  @State password: string = ''
  @State confirmPassword: string = ''
  @State realName: string = ''
  @State studentId: string = ''
  @State phone: string = ''
  @State college: string = ''
  @State major: string = ''
  @State grade: string = ''
  @State isLoading: boolean = false
  private dataService: DataService = DataService.getInstance()

  async handleRegister() {
    if (!this.username || !this.password || !this.realName || !this.studentId) {
      promptAction.showToast({ message: '请填写必填信息', duration: 2000 })
      return
    }
    if (this.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次密码不一致', duration: 2000 })
      return
    }
    this.isLoading = true
    try {
      const success = await this.dataService.register({
        username: this.username, password: this.password,
        realName: this.realName, studentId: this.studentId,
        phone: this.phone, college: this.college,
        major: this.major, grade: this.grade
      })
      if (success) {
        promptAction.showToast({ message: '注册成功，请登录', duration: 1500 })
        RouterUtil.back()
      } else {
        promptAction.showToast({ message: '用户名已存在', duration: 2000 })
      }
    } catch (e) {
      promptAction.showToast({ message: '注册失败，请重试', duration: 2000 })
    }
    this.isLoading = false
  }

  @Builder InputField(label: string, placeholder: string, value: string, onChange: (val: string) => void, isPassword: boolean = false) {
    Column({ space: 6 }) {
      Text(label)
        .fontSize(AppFontSize.CAPTION)
        .fontColor(AppColors.TEXT_SECONDARY)
        .alignSelf(ItemAlign.Start)
      TextInput({ placeholder: placeholder, text: value })
        .width('100%')
        .height(46)
        .fontSize(AppFontSize.BODY)
        .backgroundColor(AppColors.BG_INPUT)
        .borderRadius(AppRadius.MD)
        .border({ width: 1, color: AppColors.BORDER_LIGHT })
        .padding({ left: 14, right: 14 })
        .type(isPassword ? InputType.Password : InputType.Normal)
        .onChange(onChange)
    }
    .width('100%')
    .margin({ bottom: 12 })
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() })
          .padding(10)
        Text('新用户注册')
          .fontSize(AppFontSize.TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('').width(44)
      }
      .width('100%')
      .height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor(Color.White)

      // 表单
      Scroll() {
        Column() {
          this.InputField('用户名 *', '请输入用户名', this.username, (v: string) => { this.username = v })
          this.InputField('密码 *', '请输入密码', this.password, (v: string) => { this.password = v }, true)
          this.InputField('确认密码 *', '请再次输入密码', this.confirmPassword, (v: string) => { this.confirmPassword = v }, true)
          this.InputField('真实姓名 *', '请输入真实姓名', this.realName, (v: string) => { this.realName = v })
          this.InputField('学号 *', '请输入学号', this.studentId, (v: string) => { this.studentId = v })
          this.InputField('手机号', '请输入手机号', this.phone, (v: string) => { this.phone = v })
          this.InputField('学院', '请输入所在学院', this.college, (v: string) => { this.college = v })
          this.InputField('专业', '请输入所学专业', this.major, (v: string) => { this.major = v })
          this.InputField('年级', '如：2023级', this.grade, (v: string) => { this.grade = v })

          Button(this.isLoading ? '注册中...' : '注 册')
            .width('100%')
            .height(50)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppRadius.LG)
            .margin({ top: 20 })
            .enabled(!this.isLoading)
            .onClick(() => { this.handleRegister() })

          Row({ space: 4 }) {
            Text('已有账号？')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
            Text('返回登录')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.PRIMARY)
              .fontWeight(FontWeight.Medium)
              .onClick(() => { RouterUtil.back() })
          }
          .margin({ top: 16, bottom: 30 })
        }
        .padding({ left: 24, right: 24, top: 20 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}
