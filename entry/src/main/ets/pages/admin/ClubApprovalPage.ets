// 社团审批页面 - 管理员端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ClubApplication, ApprovalStatus } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ClubApprovalPage {
  @State applications: ClubApplication[] = []
  @State selectedFilter: string = '待审核'
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()
  private filters: string[] = ['待审核', '已通过', '已拒绝', '全部']

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    let status: ApprovalStatus | undefined
    if (this.selectedFilter === '待审核') status = ApprovalStatus.PENDING
    else if (this.selectedFilter === '已通过') status = ApprovalStatus.APPROVED
    else if (this.selectedFilter === '已拒绝') status = ApprovalStatus.REJECTED
    this.applications = await this.dataService.getClubApplications(status)
    this.isLoading = false
  }

  async handleApprove(app: ClubApplication, approved: boolean) {
    const success = await this.dataService.approveClubApplication(app.id, approved, approved ? '审核通过，欢迎新社团！' : '暂不符合成立条件')
    if (success) {
      promptAction.showToast({ message: approved ? '已批准' : '已拒绝', duration: 1500 })
      this.loadData()
    }
  }

  getStatusColor(status: ApprovalStatus): string {
    switch (status) {
      case ApprovalStatus.PENDING: return AppColors.WARNING
      case ApprovalStatus.APPROVED: return AppColors.PRIMARY
      case ApprovalStatus.REJECTED: return AppColors.DANGER
    }
    return AppColors.TEXT_HINT
  }

  getStatusText(status: ApprovalStatus): string {
    switch (status) {
      case ApprovalStatus.PENDING: return '待审核'
      case ApprovalStatus.APPROVED: return '已通过'
      case ApprovalStatus.REJECTED: return '已拒绝'
    }
    return ''
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('社团审批').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Row() {
        ForEach(this.filters, (f: string) => {
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
      } else if (this.applications.length === 0) {
        Column({ space: 12 }) {
          Text('📋').fontSize(48)
          Text('暂无申请记录').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.applications, (app: ClubApplication) => {
            ListItem() {
              Column({ space: 10 }) {
                Row() {
                  Text(app.clubName).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
                  Text(this.getStatusText(app.status)).fontSize(11).fontColor(Color.White)
                    .backgroundColor(this.getStatusColor(app.status))
                    .padding({ left: 10, right: 10, top: 3, bottom: 3 }).borderRadius(AppRadius.ROUND)
                }.width('100%')

                Text(`分类: ${app.category}`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                Text(`申请人: ${app.userName}`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                Text(`申请理由: ${app.reason}`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                  .maxLines(3).textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(`描述: ${app.description}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                Text(`申请时间: ${DateUtil.formatDateTime(app.createTime)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)

                if (app.status === ApprovalStatus.PENDING) {
                  Row({ space: 12 }) {
                    Button('拒绝').layoutWeight(1).height(40).fontSize(AppFontSize.BODY)
                      .fontColor(AppColors.DANGER).backgroundColor(Color.White)
                      .border({ width: 1, color: AppColors.DANGER }).borderRadius(AppRadius.MD)
                      .onClick(() => { this.handleApprove(app, false) })
                    Button('批准').layoutWeight(1).height(40).fontSize(AppFontSize.BODY)
                      .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
                      .onClick(() => { this.handleApprove(app, true) })
                  }.width('100%').margin({ top: 4 })
                }

                if (app.reviewComment) {
                  Text(`审核意见: ${app.reviewComment}`).fontSize(AppFontSize.SMALL)
                    .fontColor(AppColors.TEXT_SECONDARY).padding(8)
                    .backgroundColor(AppColors.BG_SECTION).borderRadius(AppRadius.SM).width('100%')
                }
              }
              .width('100%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
      }
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
