import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { userStore } from '../store/UserStore';
import { Constants } from '../common/Constants';
import { CommonUtil } from '../utils/CommonUtil';
import { AppTheme } from '../theme/AppTheme';
import { IconUtil } from '../utils/IconUtil';
import { LoginRequest } from '../models/UserModel';

class QuickAccount {
  username: string = '';
  password: string = '';

  constructor(username: string = '', password: string = '') {
    this.username = username;
    this.password = password;
  }
}

@Entry
@Component
struct LoginPage {
  @State private username: string = '';
  @State private password: string = '';
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';

  async handleLogin(): Promise<void> {
    if (!this.username.trim()) {
      this.errorMessage = '请输入用户名';
      return;
    }
    if (!this.password.trim()) {
      this.errorMessage = '请输入密码';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      const request: LoginRequest = new LoginRequest();
      request.username = this.username;
      request.password = this.password;
      const response = await MockDataService.login(request);
      await userStore.login(response.userInfo, response.token);
      await RouterUtil.toHome();
    } catch (error) {
      this.errorMessage = '登录失败，请重试';
    } finally {
      this.isLoading = false;
    }
  }

  async quickLogin(role: string): Promise<void> {
    this.isLoading = true;
    this.errorMessage = '';

    try {
      let account: QuickAccount | null = null;
      if (role === 'admin') {
        account = new QuickAccount('admin', '123456');
      } else if (role === 'leader') {
        account = new QuickAccount('leader1', '123456');
      } else if (role === 'student') {
        account = new QuickAccount('student1', '123456');
      }

      if (account) {
        const request: LoginRequest = new LoginRequest();
        request.username = account.username;
        request.password = account.password;
        const response = await MockDataService.login(request);
        await userStore.login(response.userInfo, response.token);
        await RouterUtil.toHome();
      }
    } catch (error) {
      this.errorMessage = '登录失败';
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Image('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=400&h=300&fit=crop')
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Cover)
            .borderRadius({ bottomLeft: 24, bottomRight: 24 })
            .blur(50)
            .opacity(0.8)

          Text('欢迎回来')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .margin({ top: -80, bottom: 8 })

          Text('登录您的账号以继续')
            .fontSize(14)
            .fontColor(AppTheme.TEXT_SECONDARY)
        }
        .width('100%')
        .padding({ left: 24, right: 24, bottom: 24 })

        Column() {
          Column() {
            Text('用户名')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            Row() {
              Image(IconUtil.INPUT)
                .width(20)
                .height(20)
                .margin({ right: 12 })

              TextInput({ placeholder: '请输入用户名', text: this.username })
                .type(InputType.Normal)
                .placeholderColor(AppTheme.TEXT_TERTIARY)
                .fontSize(16)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .border({ width: 0 })
                .onChange((value: string) => {
                  this.username = value;
                  this.errorMessage = '';
                })
            }
            .width('100%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(12)
          }
          .width('100%')
          .margin({ bottom: 16 })

          Column() {
            Text('密码')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            Row() {
              Image(IconUtil.LOCK)
                .width(20)
                .height(20)
                .margin({ right: 12 })

              TextInput({ placeholder: '请输入密码', text: this.password })
                .type(InputType.Password)
                .placeholderColor(AppTheme.TEXT_TERTIARY)
                .fontSize(16)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .border({ width: 0 })
                .onChange((value: string) => {
                  this.password = value;
                  this.errorMessage = '';
                })
            }
            .width('100%')
            .height(50)
            .padding({ left: 16, right: 16 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(12)
          }
          .width('100%')

          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(13)
              .fontColor(AppTheme.ERROR)
              .width('100%')
              .margin({ top: 12 })
          }

          Button(this.isLoading ? '登录中...' : '登录')
            .width('100%')
            .height(50)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.PRIMARY_COLOR)
            .fontColor(Color.White)
            .borderRadius(12)
            .margin({ top: 24 })
            .enabled(!this.isLoading)
            .onClick(() => {
              this.handleLogin();
            })

          Row() {
            Text('还没有账号？')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_SECONDARY)

            Text('立即注册')
              .fontSize(14)
              .fontColor(AppTheme.PRIMARY_COLOR)
              .fontWeight(FontWeight.Medium)
              .margin({ left: 4 })
              .onClick(() => {
                RouterUtil.push(Constants.ROUTE_REGISTER);
              })
          }
          .margin({ top: 16 })

          Column() {
            Text('快速体验')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_SECONDARY)
              .margin({ bottom: 12 })

            Row() {
              this.QuickLoginButton('管理员', () => { this.quickLogin('admin'); })
              this.QuickLoginButton('社长', () => { this.quickLogin('leader'); })
              this.QuickLoginButton('学生', () => { this.quickLogin('student'); })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .margin({ top: 40 })
        }
        .width('100%')
        .padding(24)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
  }

  @Builder
  QuickLoginButton(title: string, onClick: () => void) {
    Button(title)
      .width('30%')
      .height(40)
      .fontSize(14)
      .backgroundColor(AppTheme.BG_TERTIARY)
      .fontColor(AppTheme.TEXT_PRIMARY)
      .borderRadius(20)
      .onClick(onClick)
  }
}