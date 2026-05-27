// 活动审批页面 - 管理员端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ActivityInfo, ActivityStatus } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ActivityApprovalPage {
  @State activities: ActivityInfo[] = []
  @State selectedFilter: string = '待审核'
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    const all = await this.dataService.getAllActivities()
    if (this.selectedFilter === '待审核') {
      this.activities = all.filter(a => a.status === ActivityStatus.PENDING)
    } else if (this.selectedFilter === '已通过') {
      this.activities = all.filter(a => a.status === ActivityStatus.APPROVED || a.status === ActivityStatus.ONGOING)
    } else if (this.selectedFilter === '已拒绝') {
      this.activities = all.filter(a => a.status === ActivityStatus.REJECTED)
    } else {
      this.activities = all
    }
    this.isLoading = false
  }

  async handleApprove(activity: ActivityInfo, approved: boolean) {
    const success = await this.dataService.approveActivity(activity.id, approved)
    if (success) {
      promptAction.showToast({ message: approved ? '已批准' : '已拒绝', duration: 1500 })
      this.loadData()
    }
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('活动审批').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Row() {
        ForEach(['待审核', '已通过', '已拒绝', '全部'], (f: string) => {
          Text(f).fontSize(AppFontSize.BODY)
            .fontColor(this.selectedFilter === f ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
            .fontWeight(this.selectedFilter === f ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 14, right: 14, top: 12, bottom: 12 })
            .border({ width: { bottom: 2 }, color: this.selectedFilter === f ? AppColors.PRIMARY : Color.Transparent })
            .onClick(() => { this.selectedFilter = f; this.loadData() })
        })
      }.width('100%').backgroundColor(Color.White).justifyContent(FlexAlign.SpaceAround)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.activities.length === 0) {
        Column({ space: 12 }) {
          Text('📅').fontSize(48)
          Text('暂无活动记录').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.activities, (activity: ActivityInfo) => {
            ListItem() {
              Column({ space: 8 }) {
                Row({ space: 12 }) {
                  Image(activity.coverImage).width(80).height(60).borderRadius(AppRadius.SM).objectFit(ImageFit.Cover)
                  Column({ space: 4 }) {
                    Text(activity.title).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium)
                      .fontColor(AppColors.TEXT_PRIMARY).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(`${activity.clubName} · ${activity.creatorName}`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                    Text(`📍 ${activity.location} · 📅 ${DateUtil.formatDate(activity.startTime)}`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                    Text(`人数上限: ${activity.maxParticipants}人`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                }.width('100%')

                Text(activity.description).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                  .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })

                if (activity.status === ActivityStatus.PENDING) {
                  Row({ space: 12 }) {
                    Button('拒绝').layoutWeight(1).height(38).fontSize(AppFontSize.BODY)
                      .fontColor(AppColors.DANGER).backgroundColor(Color.White)
                      .border({ width: 1, color: AppColors.DANGER }).borderRadius(AppRadius.MD)
                      .onClick(() => { this.handleApprove(activity, false) })
                    Button('批准').layoutWeight(1).height(38).fontSize(AppFontSize.BODY)
                      .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
                      .onClick(() => { this.handleApprove(activity, true) })
                  }.width('100%')
                }
              }
              .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.LG)
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
      }
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
