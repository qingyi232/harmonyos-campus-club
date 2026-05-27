import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ActivityQueryParams } from '../services/MockDataService';
import { ActivityInfo } from '../models/ActivityModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { StatusTabItem } from '../models/ViewModel';
import { ActivityIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ActivityListPage {
  @State private activities: ActivityInfo[] = [];
  @State private filteredActivities: ActivityInfo[] = [];
  @State private isLoading: boolean = true;
  @State private searchKeyword: string = '';
  @State private selectedStatus: string = 'all';

  private statusTabs: StatusTabItem[] = [
    new StatusTabItem('全部', 'all'),
    new StatusTabItem('进行中', 'ongoing'),
    new StatusTabItem('即将开始', 'upcoming'),
    new StatusTabItem('已结束', 'completed')
  ];

  async aboutToAppear(): Promise<void> {
    await this.loadActivities();
  }

  async loadActivities(): Promise<void> {
    this.isLoading = true;
    try {
      const params: ActivityQueryParams = new ActivityQueryParams();
      params.status = 'approved';
      const data = await MockDataService.getActivityList(params);
      this.activities = data;
      this.filterActivities();
    } catch (error) {
      console.error('Load activities failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  filterActivities(): void {
    const now: number = Date.now();
    let result: ActivityInfo[] = this.activities;

    if (this.selectedStatus === 'ongoing') {
      result = result.filter((activity: ActivityInfo) => activity.status === 'ongoing');
    } else if (this.selectedStatus === 'upcoming') {
      result = result.filter((activity: ActivityInfo) => activity.startTime > now && activity.status === 'approved');
    } else if (this.selectedStatus === 'completed') {
      result = result.filter((activity: ActivityInfo) => activity.status === 'completed');
    }

    if (this.searchKeyword.trim()) {
      const keyword: string = this.searchKeyword.toLowerCase();
      result = result.filter((activity: ActivityInfo) => {
        return activity.title.toLowerCase().includes(keyword) ||
          activity.description.toLowerCase().includes(keyword) ||
          activity.clubName.toLowerCase().includes(keyword);
      });
    }

    this.filteredActivities = result;
  }

  onSearchChange(value: string): void {
    this.searchKeyword = value;
    this.filterActivities();
  }

  onStatusSelect(status: string): void {
    this.selectedStatus = status;
    this.filterActivities();
  }

  build() {
    Column() {
      this.Header();
      this.StatusTabs();

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
      } else if (this.filteredActivities.length === 0) {
        Row() {
          Column() {
            Image(IconUtil.EMPTY)
              .width(80)
              .height(80)
              .margin({ bottom: 16 })

            Text('暂无活动数据')
              .fontSize(16)
              .fontColor(AppTheme.TEXT_TERTIARY)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.filteredActivities, (activity: ActivityInfo) => {
            ListItem() {
              this.ActivityCard(activity);
            }
          }, (activity: ActivityInfo) => activity.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      }

      if (userStore.isLeader) {
        Button('创建活动')
          .width('90%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .fontColor(AppTheme.TEXT_WHITE)
          .borderRadius(24)
          .margin({ bottom: 16 })
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_ACTIVITY_APPLY);
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  Header() {
    Column() {
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('活动列表')
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

      Row() {
        Image(IconUtil.SEARCH)
          .width(20)
          .height(20)
          .margin({ right: 8 })

        TextInput({ placeholder: '搜索活动名称、描述或社团', text: this.searchKeyword })
          .type(InputType.Normal)
          .placeholderColor(AppTheme.TEXT_TERTIARY)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .border({ width: 0 })
          .onChange((value: string) => {
            this.onSearchChange(value);
          })
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(AppTheme.BG_TERTIARY)
      .borderRadius(22)
      .margin({ left: 16, right: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
  }

  @Builder
  StatusTabs() {
    Row() {
      ForEach(this.statusTabs, (tab: StatusTabItem) => {
        Text(tab.label)
          .fontSize(14)
          .fontColor(this.selectedStatus === tab.value ? AppTheme.TEXT_WHITE : AppTheme.TEXT_PRIMARY)
          .fontWeight(this.selectedStatus === tab.value ? FontWeight.Medium : FontWeight.Normal)
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor(this.selectedStatus === tab.value ? AppTheme.PRIMARY_COLOR : AppTheme.BG_TERTIARY)
          .borderRadius(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.onStatusSelect(tab.value);
          })
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .margin({ bottom: 8 })
  }

  @Builder
  ActivityCard(activity: ActivityInfo) {
    Column() {
      Image(activity.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=200&fit=crop')
        .width('100%')
        .height(140)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 12, topRight: 12 })

      Column() {
        Row() {
          Text(activity.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          if (activity.status === 'ongoing') {
            Text('进行中')
              .fontSize(11)
              .fontColor(AppTheme.TEXT_WHITE)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor(AppTheme.PRIMARY_COLOR)
              .borderRadius(4)
              .margin({ left: 8 })
          }
        }
        .width('100%')

        Text(activity.clubName)
          .fontSize(13)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ top: 4 })

        Row() {
          Row() {
            Image(IconUtil.TIME)
              .width(14)
              .height(14)
              .margin({ right: 4 })

            Text(CommonUtil.formatTimestamp(activity.startTime, 'MM-DD HH:mm'))
              .fontSize(12)
              .fontColor(AppTheme.TEXT_TERTIARY)
          }

          Row() {
            Image(IconUtil.LOCATION)
              .width(14)
              .height(14)
              .margin({ right: 4 })

            Text(activity.location)
              .fontSize(12)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .margin({ left: 16 })
        }
        .width('100%')
        .margin({ top: 8 })

        Row() {
          Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)

          Blank()

          Text(activity.status === 'ongoing' ? '立即报名' : '查看详情')
            .fontSize(13)
            .fontColor(AppTheme.PRIMARY_COLOR)
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .width('100%')
      .padding(12)
    }
    .width('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_ACTIVITY_DETAIL, new ActivityIdRouteParam(activity.id));
    })
  }
}