import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ActivityQueryParams } from '../services/MockDataService';
import { ActivityInfo, ActivityRegistration } from '../models/ActivityModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { userStore } from '../store/UserStore';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct MyActivityPage {
  @State private registrations: ActivityRegistration[] = [];
  @State private activities: ActivityInfo[] = [];
  @State private isLoading: boolean = true;
  @State private currentTab: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      // 获取用户报名的活动
      const regs = await MockDataService.getUserRegistrations(userStore.userId);
      this.registrations = regs;

      // 如果是社长，获取创建的活动
      if (userStore.isLeader) {
        const params = new ActivityQueryParams();
        const acts = await MockDataService.getActivityList(params);
        this.activities = acts.filter(a => a.creatorId === userStore.userId);
      }
    } catch (error) {
      console.error('Load activities failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
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

        Text('我的活动')
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
      .padding({ left: 16, right: 16, top: 36 })

      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Tabs({ barPosition: BarPosition.Start }) {
          // 报名的活动
          TabContent() {
            this.RegistrationList()
          }
          .tabBar(`报名活动(${this.registrations.length})`)

          // 创建的活动（仅社长）
          if (userStore.isLeader) {
            TabContent() {
              this.ActivityList()
            }
            .tabBar(`创建活动(${this.activities.length})`)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .barHeight(44)
        .animationDuration(200)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  RegistrationList() {
    if (this.registrations.length === 0) {
      Row() {
        Column() {
          Image(IconUtil.EMPTY)
            .width(80)
            .height(80)
            .fillColor(AppTheme.TEXT_TERTIARY)
            .margin({ bottom: 16 })

          Text('您还没有报名任何活动')
            .fontSize(16)
            .fontColor(AppTheme.TEXT_TERTIARY)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.registrations, (reg: ActivityRegistration) => {
          ListItem() {
            this.RegistrationCard(reg)
          }
        }, (reg: ActivityRegistration) => reg.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })
    }
  }

  @Builder
  RegistrationCard(reg: ActivityRegistration) {
    Row() {
      Column() {
        Text(reg.activityTitle)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)

        Text(CommonUtil.formatTimestamp(reg.registerTime, 'YYYY-MM-DD HH:mm'))
          .fontSize(13)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ top: 6 })

        Row() {
          Text(reg.status === 'registered' ? '已报名' : reg.status === 'attended' ? '已参加' : '已取消')
            .fontSize(12)
            .fontColor(reg.status === 'registered' ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(4)
            .margin({ top: 8 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Image(IconUtil.ARROW_RIGHT)
        .width(20)
        .height(20)
        .fillColor(AppTheme.TEXT_TERTIARY)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
  }

  @Builder
  ActivityList() {
    if (this.activities.length === 0) {
      Row() {
        Column() {
          Image(IconUtil.EMPTY)
            .width(80)
            .height(80)
            .fillColor(AppTheme.TEXT_TERTIARY)
            .margin({ bottom: 16 })

          Text('您还没有创建任何活动')
            .fontSize(16)
            .fontColor(AppTheme.TEXT_TERTIARY)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.activities, (activity: ActivityInfo) => {
          ListItem() {
            this.ActivityCard(activity)
          }
        }, (activity: ActivityInfo) => activity.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })
    }
  }

  @Builder
  ActivityCard(activity: ActivityInfo) {
    Row() {
      Image(activity.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=100&h=100&fit=crop')
        .width(70)
        .height(70)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)

      Column() {
        Text(activity.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(CommonUtil.formatTimestamp(activity.startTime, 'MM-DD HH:mm'))
          .fontSize(12)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ top: 6 })

        Row() {
          Text(CommonUtil.getStatusText(activity.status, 'activity'))
            .fontSize(11)
            .fontColor(CommonUtil.getStatusColor(activity.status))
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(4)

          Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
            .fontSize(11)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ left: 8 })
        }
        .margin({ top: 6 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })

      Image(IconUtil.ARROW_RIGHT)
        .width(20)
        .height(20)
        .fillColor(AppTheme.TEXT_TERTIARY)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
  }
}
