import { RouterUtil } from '../utils/RouterUtil';
import { userStore } from '../store/UserStore';
import { Constants } from '../common/Constants';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { MockDataService } from '../services/MockDataService';
import { UserParticipationStats } from '../models/StatisticsModel';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ProfilePage {
  @State private stats: UserParticipationStats | null = null;

  async aboutToAppear(): Promise<void> {
    await this.loadStats();
  }

  async loadStats(): Promise<void> {
    try {
      const data = await MockDataService.getUserParticipationStats(userStore.userId);
      this.stats = data;
    } catch (error) {
      console.error('Load stats failed:', JSON.stringify(error));
    }
  }

  async handleLogout(): Promise<void> {
    await userStore.logout();
    await RouterUtil.toLogin();
  }

  build() {
    Scroll() {
      Column() {
        // 用户信息卡片
        this.UserInfoCard()

        // 统计数据
        if (this.stats) {
          this.StatsCard()
        }

        // 功能菜单
        this.MenuSection()

        // 退出登录
        Button('退出登录')
          .width('90%')
          .height(48)
          .fontSize(16)
          .backgroundColor(AppTheme.BG_TERTIARY)
          .fontColor(AppTheme.ERROR)
          .borderRadius(24)
          .margin({ top: 16, bottom: 32 })
          .onClick(() => {
            this.handleLogout();
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  UserInfoCard() {
    Column() {
      // 顶部导航
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_WHITE)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('个人中心')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_WHITE)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Image(IconUtil.SETTINGS)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_WHITE)
      }
      .width('100%')
      .height(90)
      .padding({ left: 16, right: 16, top: 36 })

      // 用户信息
      Row() {
        Image(userStore.userAvatar || 'https://i.pravatar.cc/150')
          .width(70)
          .height(70)
          .objectFit(ImageFit.Cover)
          .borderRadius(35)
          .border({ width: 3, color: AppTheme.TEXT_WHITE })

        Column() {
          Text(userStore.userName || '用户')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.TEXT_WHITE)

          Row() {
            Text(CommonUtil.getRoleText(userStore.userInfo?.role || 'student'))
              .fontSize(13)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.9)
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor('rgba(255,255,255,0.2)')
              .borderRadius(4)

            if (userStore.clubName) {
              Text(userStore.clubName)
                .fontSize(13)
                .fontColor(AppTheme.TEXT_WHITE)
                .opacity(0.9)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .backgroundColor('rgba(255,255,255,0.2)')
                .borderRadius(4)
                .margin({ left: 8 })
            }
          }
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 20 })
    }
    .width('100%')
    .backgroundColor(AppTheme.PRIMARY_COLOR)
    .borderRadius({ bottomLeft: 24, bottomRight: 24 })
  }

  @Builder
  StatsCard() {
    Row() {
      this.StatItem('加入社团', `${this.stats?.joinedClubs || 0}个`)
      this.StatItem('参与活动', `${this.stats?.participatedActivities || 0}次`)
      this.StatItem('活动时长', `${this.stats?.totalHours || 0}小时`)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  StatItem(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppTheme.PRIMARY_COLOR)

      Text(label)
        .fontSize(13)
        .fontColor(AppTheme.TEXT_TERTIARY)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  MenuSection() {
    Column() {
      this.MenuItem('我的社团', IconUtil.COMMUNITY, () => {
        RouterUtil.push(Constants.ROUTE_MY_CLUB);
      })

      this.MenuItem('我的活动', IconUtil.CALENDAR, () => {
        RouterUtil.push(Constants.ROUTE_MY_ACTIVITY);
      })

      if (userStore.isLeader) {
        this.MenuItem('成员管理', IconUtil.CONTACTS, () => {
          RouterUtil.push(Constants.ROUTE_MEMBER_MANAGE, new ClubIdRouteParam(userStore.clubId ?? ''));
        })

        this.MenuItem('财务管理', IconUtil.WALLET, () => {
          RouterUtil.push(Constants.ROUTE_FINANCE_MANAGE, new ClubIdRouteParam(userStore.clubId ?? ''));
        })
      }

      if (userStore.isAdmin) {
        this.MenuItem('社团审核', IconUtil.OK, () => {
          RouterUtil.push(Constants.ROUTE_AUDIT_CLUB);
        })

        this.MenuItem('活动审核', IconUtil.OK, () => {
          RouterUtil.push(Constants.ROUTE_AUDIT_ACTIVITY);
        })

        this.MenuItem('数据统计', IconUtil.STATISTICS, () => {
          RouterUtil.push(Constants.ROUTE_STATISTICS);
        })
      }

      this.MenuItem('关于我们', IconUtil.INFO, () => {
        this.showAboutDialog();
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16 })
  }

  @Builder
  MenuItem(title: string, icon: string, onClick: () => void) {
    Row() {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(AppTheme.PRIMARY_COLOR)

      Text(title)
        .fontSize(16)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .layoutWeight(1)
        .margin({ left: 12 })

      Image(IconUtil.ARROW_RIGHT)
        .width(20)
        .height(20)
        .fillColor(AppTheme.TEXT_TERTIARY)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .onClick(onClick)
  }

  showAboutDialog(): void {
    AlertDialog.show({
      title: '关于我们',
      message: '校园社团管理系统\n\n基于鸿蒙端云协同开发\n\n版本：1.0.0\n\n© 2024 Campus Club Management',
      autoCancel: true,
      confirm: {
        value: '确定',
        action: () => {
          // 关闭对话框
        }
      }
    });
  }
}
