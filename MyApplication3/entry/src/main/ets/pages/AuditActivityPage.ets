import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ActivityQueryParams } from '../services/MockDataService';
import { ActivityInfo } from '../models/ActivityModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct AuditActivityPage {
  @State private activities: ActivityInfo[] = [];
  @State private isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    await this.loadActivities();
  }

  async loadActivities(): Promise<void> {
    this.isLoading = true;
    try {
      const params = new ActivityQueryParams();
      params.status = 'pending';
      const data = await MockDataService.getActivityList(params);
      this.activities = data;
    } catch (error) {
      console.error('Load activities failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  async handleAudit(activityId: string, status: string): Promise<void> {
    try {
      await MockDataService.auditActivity(activityId, status);
      // 重新加载数据
      await this.loadActivities();
    } catch (error) {
      console.error('Audit failed:', JSON.stringify(error));
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

        Text('活动审核')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text(`${this.activities.length}`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
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
      } else if (this.activities.length === 0) {
        Row() {
          Column() {
            Image(IconUtil.OK)
              .width(80)
              .height(80)
              .fillColor(AppTheme.PRIMARY_COLOR)
              .margin({ bottom: 16 })

            Text('暂无待审核的活动')
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
              this.AuditCard(activity)
            }
          }, (activity: ActivityInfo) => activity.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  AuditCard(activity: ActivityInfo) {
    Column() {
      Row() {
        Image(activity.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=100&h=100&fit=crop')
          .width(70)
          .height(70)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)

        Column() {
          Text(activity.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(activity.clubName)
            .fontSize(13)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })

          Text(CommonUtil.formatTimestamp(activity.startTime, 'MM-DD HH:mm'))
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
      }
      .width('100%')

      Text(activity.description)
        .fontSize(14)
        .fontColor(AppTheme.TEXT_SECONDARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ top: 12 })

      Row() {
        Text(`地点：${activity.location}`)
          .fontSize(13)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .layoutWeight(1)

        Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
          .fontSize(13)
          .fontColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')
      .margin({ top: 8 })

      Row() {
        Button('拒绝')
          .width('48%')
          .height(40)
          .fontSize(14)
          .backgroundColor(AppTheme.BG_TERTIARY)
          .fontColor(AppTheme.ERROR)
          .borderRadius(8)
          .onClick(() => {
            this.handleAudit(activity.id, 'rejected');
          })

        Button('通过')
          .width('48%')
          .height(40)
          .fontSize(14)
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .fontColor(AppTheme.TEXT_WHITE)
          .borderRadius(8)
          .onClick(() => {
            this.handleAudit(activity.id, 'approved');
          })
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
  }
}
