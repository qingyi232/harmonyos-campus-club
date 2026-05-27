import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { RegisterRequest } from '../models/UserModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct RegisterPage {
  @State private username: string = '';
  @State private password: string = '';
  @State private confirmPassword: string = '';
  @State private realName: string = '';
  @State private studentId: string = '';
  @State private phone: string = '';
  @State private email: string = '';
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';

  // 表单验证
  validateForm(): boolean {
    if (!this.username.trim()) {
      this.errorMessage = '请输入用户名';
      return false;
    }
    if (this.username.length < 4) {
      this.errorMessage = '用户名至少4个字符';
      return false;
    }
    if (!this.password.trim()) {
      this.errorMessage = '请输入密码';
      return false;
    }
    if (this.password.length < 6) {
      this.errorMessage = '密码至少6个字符';
      return false;
    }
    if (this.password !== this.confirmPassword) {
      this.errorMessage = '两次密码不一致';
      return false;
    }
    if (!this.realName.trim()) {
      this.errorMessage = '请输入真实姓名';
      return false;
    }
    if (!this.studentId.trim()) {
      this.errorMessage = '请输入学号';
      return false;
    }
    if (!this.phone.trim()) {
      this.errorMessage = '请输入手机号';
      return false;
    }
    if (!CommonUtil.isValidPhone(this.phone)) {
      this.errorMessage = '手机号格式不正确';
      return false;
    }
    if (!this.email.trim()) {
      this.errorMessage = '请输入邮箱';
      return false;
    }
    if (!CommonUtil.isValidEmail(this.email)) {
      this.errorMessage = '邮箱格式不正确';
      return false;
    }
    return true;
  }

  // 注册处理
  async handleRegister(): Promise<void> {
    if (!this.validateForm()) {
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      const request: RegisterRequest = new RegisterRequest();
      request.username = this.username;
      request.password = this.password;
      request.realName = this.realName;
      request.studentId = this.studentId;
      request.phone = this.phone;
      request.email = this.email;

      await MockDataService.register(request);

      // 注册成功，返回登录页
      await RouterUtil.back();
    } catch (error) {
      this.errorMessage = error.message || '注册失败，请重试';
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Scroll() {
      Column() {
        // 顶部导航
        Row() {
          Image(IconUtil.ARROW_LEFT)
            .width(24)
            .height(24)
            .fillColor(AppTheme.TEXT_PRIMARY)
            .onClick(() => {
              RouterUtil.back();
            })

          Text('注册账号')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Row()
            .width(24)
            .height(24)
        }
        .width('100%')
        .height(90)
        .padding({ top: 36, left: 16, right: 16 })

        // 注册表单
        Column() {
          // 用户名
          this.InputField('用户名', '请输入用户名（4-20个字符）', this.username, (value: string) => {
            this.username = value;
            this.errorMessage = '';
          })

          // 密码
          this.InputField('密码', '请输入密码（至少6个字符）', this.password, (value: string) => {
            this.password = value;
            this.errorMessage = '';
          }, true)

          // 确认密码
          this.InputField('确认密码', '请再次输入密码', this.confirmPassword, (value: string) => {
            this.confirmPassword = value;
            this.errorMessage = '';
          }, true)

          // 真实姓名
          this.InputField('真实姓名', '请输入真实姓名', this.realName, (value: string) => {
            this.realName = value;
            this.errorMessage = '';
          })

          // 学号
          this.InputField('学号', '请输入学号', this.studentId, (value: string) => {
            this.studentId = value;
            this.errorMessage = '';
          })

          // 手机号
          this.InputField('手机号', '请输入手机号', this.phone, (value: string) => {
            this.phone = value;
            this.errorMessage = '';
          })

          // 邮箱
          this.InputField('邮箱', '请输入邮箱', this.email, (value: string) => {
            this.email = value;
            this.errorMessage = '';
          })

          // 错误提示
          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(12)
              .fontColor(AppTheme.ERROR)
              .width('100%')
              .margin({ top: 8, bottom: 16 })
          }

          // 注册按钮
          Button(this.isLoading ? '注册中...' : '注册')
            .width('100%')
            .height(50)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.PRIMARY_COLOR)
            .fontColor(AppTheme.TEXT_WHITE)
            .borderRadius(12)
            .enabled(!this.isLoading)
            .opacity(this.isLoading ? 0.6 : 1)
            .margin({ top: 8 })
            .onClick(() => {
              this.handleRegister();
            })

          // 登录链接
          Row() {
            Text('已有账号？')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_SECONDARY)
              .margin({ top: 16 })

            Text('立即登录')
              .fontSize(14)
              .fontColor(AppTheme.PRIMARY_COLOR)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 16, left: 4 })
              .onClick(() => {
                RouterUtil.back();
              })
          }
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 20 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
  }

  @Builder
  InputField(label: string, placeholder: string, value: string, onChange: (value: string) => void, isPassword: boolean = false) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 8 })

      Row() {
        TextInput({
          placeholder: placeholder,
          text: value
        })
          .type(isPassword ? InputType.Password : InputType.Normal)
          .placeholderColor(AppTheme.TEXT_TERTIARY)
          .fontSize(16)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .border({ width: 0 })
          .onChange(onChange)
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      .backgroundColor(AppTheme.BG_TERTIARY)
      .borderRadius(12)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }
}
