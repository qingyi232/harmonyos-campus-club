// 活动列表页面 - 学生端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ActivityInfo, ActivityStatus } from '../../model/DataModels'

@Entry
@Component
struct ActivityListPage {
  @State activities: ActivityInfo[] = []
  @State filteredActivities: ActivityInfo[] = []
  @State selectedFilter: string = '全部'
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()
  private filters: string[] = ['全部', '报名中', '进行中', '已结束']

  aboutToAppear() {
    this.loadActivities()
  }

  async loadActivities() {
    this.isLoading = true
    this.activities = await this.dataService.getActivities()
    this.filteredActivities = [...this.activities]
    this.isLoading = false
  }

  filterActivities() {
    if (this.selectedFilter === '全部') {
      this.filteredActivities = [...this.activities]
    } else if (this.selectedFilter === '报名中') {
      this.filteredActivities = this.activities.filter(a => a.status === ActivityStatus.APPROVED)
    } else if (this.selectedFilter === '进行中') {
      this.filteredActivities = this.activities.filter(a => a.status === ActivityStatus.ONGOING)
    } else {
      this.filteredActivities = this.activities.filter(a => a.status === ActivityStatus.FINISHED)
    }
  }

  getStatusText(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.APPROVED: return '报名中'
      case ActivityStatus.ONGOING: return '进行中'
      case ActivityStatus.FINISHED: return '已结束'
      case ActivityStatus.PENDING: return '待审核'
      default: return '未知'
    }
  }

  getStatusColor(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.APPROVED: return AppColors.PRIMARY
      case ActivityStatus.ONGOING: return AppColors.WARNING
      case ActivityStatus.FINISHED: return AppColors.TEXT_HINT
      default: return AppColors.TEXT_SECONDARY
    }
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
        Text('社团活动')
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

      // 筛选标签
      Row({ space: 0 }) {
        ForEach(this.filters, (filter: string) => {
          Text(filter)
            .fontSize(AppFontSize.BODY)
            .fontColor(this.selectedFilter === filter ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
            .fontWeight(this.selectedFilter === filter ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .border({ width: { bottom: 2 }, color: this.selectedFilter === filter ? AppColors.PRIMARY : Color.Transparent })
            .onClick(() => {
              this.selectedFilter = filter
              this.filterActivities()
            })
        })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceAround)

      // 活动列表
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color(AppColors.PRIMARY)
          Text('加载中...').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_HINT).margin({ top: 8 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.filteredActivities.length === 0) {
        Column({ space: 12 }) {
          Text('📭').fontSize(48)
          Text('暂无相关活动').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 14 }) {
          ForEach(this.filteredActivities, (activity: ActivityInfo) => {
            ListItem() {
              Column() {
                // 封面图
                Stack({ alignContent: Alignment.TopEnd }) {
                  Image(activity.coverImage)
                    .width('100%')
                    .height(160)
                    .objectFit(ImageFit.Cover)
                    .borderRadius({ topLeft: AppRadius.LG, topRight: AppRadius.LG })

                  Text(this.getStatusText(activity.status))
                    .fontSize(11)
                    .fontColor(Color.White)
                    .backgroundColor(this.getStatusColor(activity.status))
                    .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                    .borderRadius({ topRight: AppRadius.LG, bottomLeft: AppRadius.MD })
                }

                // 活动信息
                Column({ space: 6 }) {
                  Text(activity.title)
                    .fontSize(AppFontSize.SUBTITLE)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row({ space: 6 }) {
                    Text(`🏛 ${activity.clubName}`)
                      .fontSize(AppFontSize.CAPTION)
                      .fontColor(AppColors.PRIMARY)
                  }

                  Row({ space: 16 }) {
                    Text(`📍 ${activity.location}`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_SECONDARY)
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(`📅 ${DateUtil.formatDate(activity.startTime)}`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_SECONDARY)
                  }
                  .width('100%')

                  // 报名进度
                  Row() {
                    Progress({ value: activity.currentParticipants, total: activity.maxParticipants })
                      .width('70%')
                      .height(6)
                      .color(AppColors.PRIMARY)
                      .backgroundColor(AppColors.PRIMARY_LIGHT)
                      .borderRadius(3)
                    Blank()
                    Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                  .width('100%')
                }
                .width('100%')
                .padding(14)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(AppRadius.LG)
              .onClick(() => {
                RouterUtil.pushUrl(PageRoutes.ACTIVITY_DETAIL, { activityId: activity.id } as Record<string, Object>)
              })
            }
          })
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}
