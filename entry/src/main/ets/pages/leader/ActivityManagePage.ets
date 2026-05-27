// 活动管理页面 - 负责人端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ActivityInfo, ActivityStatus, ClubInfo } from '../../model/DataModels'

@Entry
@Component
struct ActivityManagePage {
  @State activities: ActivityInfo[] = []
  @State myClubs: ClubInfo[] = []
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.loadData()
  }

  async loadData() {
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.myClubs = await this.dataService.getClubsByLeader(user.id)
      let allActs: ActivityInfo[] = []
      for (const club of this.myClubs) {
        const acts = await this.dataService.getActivitiesByClub(club.id)
        allActs = allActs.concat(acts)
      }
      this.activities = allActs
    }
    this.isLoading = false
  }

  getStatusText(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.PENDING: return '待审核'
      case ActivityStatus.APPROVED: return '已通过'
      case ActivityStatus.REJECTED: return '已拒绝'
      case ActivityStatus.ONGOING: return '进行中'
      case ActivityStatus.FINISHED: return '已结束'
      default: return '草稿'
    }
  }

  getStatusColor(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.PENDING: return AppColors.WARNING
      case ActivityStatus.APPROVED: return AppColors.PRIMARY
      case ActivityStatus.REJECTED: return AppColors.DANGER
      case ActivityStatus.ONGOING: return AppColors.ACCENT
      default: return AppColors.TEXT_HINT
    }
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('活动管理').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('+').fontSize(28).fontColor(AppColors.PRIMARY)
          .onClick(() => { RouterUtil.pushUrl(PageRoutes.LEADER_CREATE_ACTIVITY) }).padding(10)
      }
      .width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.activities.length === 0) {
        Column({ space: 12 }) {
          Text('📅').fontSize(48)
          Text('暂无活动，点击右上角创建').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.activities, (activity: ActivityInfo) => {
            ListItem() {
              Row({ space: 12 }) {
                Image(activity.coverImage).width(90).height(70).borderRadius(AppRadius.SM).objectFit(ImageFit.Cover)
                Column({ space: 4 }) {
                  Row() {
                    Text(activity.title).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium)
                      .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(this.getStatusText(activity.status)).fontSize(10)
                      .fontColor(Color.White).backgroundColor(this.getStatusColor(activity.status))
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 }).borderRadius(AppRadius.ROUND)
                  }.width('100%')
                  Text(`${activity.clubName}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                  Row({ space: 12 }) {
                    Text(`📍 ${activity.location}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                      .maxLines(1).layoutWeight(1)
                    Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }.width('100%')
                  Text(`📅 ${DateUtil.formatDate(activity.startTime)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
              }
              .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.LG)
            }
          })
        }
        .layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
      }
    }
    .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
