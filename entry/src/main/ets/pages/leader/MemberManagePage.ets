// 成员管理页面 - 负责人端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ClubMember, JoinApplication, ApprovalStatus, ClubInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct MemberManagePage {
  @State members: ClubMember[] = []
  @State pendingApps: JoinApplication[] = []
  @State activeTab: number = 0
  @State clubId: string = ''
  @State clubName: string = ''
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    const params = RouterUtil.getParams()
    if (params && params.clubId) {
      this.clubId = params.clubId as string
      this.loadData()
    } else {
      this.loadFirstClub()
    }
  }

  async loadFirstClub() {
    const user = this.dataService.getCurrentUser()
    if (user) {
      const clubs = await this.dataService.getClubsByLeader(user.id)
      if (clubs.length > 0) {
        this.clubId = clubs[0].id
        this.clubName = clubs[0].name
        this.loadData()
      }
    }
  }

  async loadData() {
    this.isLoading = true
    this.members = await this.dataService.getClubMembers(this.clubId)
    this.pendingApps = await this.dataService.getPendingJoinApplications(this.clubId)
    const club = await this.dataService.getClubById(this.clubId)
    if (club) this.clubName = club.name
    this.isLoading = false
  }

  async handleApprove(app: JoinApplication, approved: boolean) {
    const success = await this.dataService.approveJoinApplication(app.id, approved)
    if (success) {
      promptAction.showToast({ message: approved ? '已通过申请' : '已拒绝申请', duration: 1500 })
      this.loadData()
    }
  }

  async handleRemoveMember(member: ClubMember) {
    const success = await this.dataService.removeMember(member.id)
    if (success) {
      promptAction.showToast({ message: '已移除成员', duration: 1500 })
      this.loadData()
    }
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text(`成员管理 - ${this.clubName}`).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        Text('').width(44)
      }
      .width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      // Tab
      Row() {
        Text(`成员列表 (${this.members.length})`)
          .fontSize(AppFontSize.BODY)
          .fontColor(this.activeTab === 0 ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
          .fontWeight(this.activeTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .padding({ left: 20, right: 20, top: 12, bottom: 12 })
          .border({ width: { bottom: 2 }, color: this.activeTab === 0 ? AppColors.PRIMARY : Color.Transparent })
          .onClick(() => { this.activeTab = 0 })
        Text(`待审核 (${this.pendingApps.length})`)
          .fontSize(AppFontSize.BODY)
          .fontColor(this.activeTab === 1 ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
          .fontWeight(this.activeTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .padding({ left: 20, right: 20, top: 12, bottom: 12 })
          .border({ width: { bottom: 2 }, color: this.activeTab === 1 ? AppColors.PRIMARY : Color.Transparent })
          .onClick(() => { this.activeTab = 1 })
      }
      .width('100%').backgroundColor(Color.White).justifyContent(FlexAlign.SpaceAround)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 8 }) {
            if (this.activeTab === 0) {
              // 成员列表
              ForEach(this.members, (member: ClubMember) => {
                Row({ space: 12 }) {
                  Text(member.userName.charAt(0))
                    .fontSize(18).fontColor(Color.White).textAlign(TextAlign.Center)
                    .width(44).height(44).borderRadius(22)
                    .backgroundColor(member.role === 'leader' ? AppColors.PRIMARY : AppColors.ACCENT)
                  Column({ space: 3 }) {
                    Text(member.userName).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                    Text(`学号: ${member.studentId} · 加入: ${DateUtil.formatDate(member.joinTime)}`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                  if (member.role === 'leader') {
                    Text('社长').fontSize(AppFontSize.SMALL).fontColor(AppColors.WARNING)
                      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                      .backgroundColor(AppColors.TAG_ORANGE).borderRadius(AppRadius.ROUND)
                  } else {
                    Text('移除').fontSize(AppFontSize.SMALL).fontColor(AppColors.DANGER)
                      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                      .border({ width: 1, color: AppColors.DANGER }).borderRadius(AppRadius.ROUND)
                      .onClick(() => { this.handleRemoveMember(member) })
                  }
                }
                .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.MD)
              })
            } else {
              // 待审核申请
              if (this.pendingApps.length === 0) {
                Column({ space: 12 }) {
                  Text('✅').fontSize(48)
                  Text('暂无待审核申请').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
                }.padding(40)
              } else {
                ForEach(this.pendingApps, (app: JoinApplication) => {
                  Column({ space: 10 }) {
                    Row({ space: 12 }) {
                      Text(app.userName.charAt(0))
                        .fontSize(18).fontColor(Color.White).textAlign(TextAlign.Center)
                        .width(44).height(44).borderRadius(22).backgroundColor(AppColors.ACCENT)
                      Column({ space: 3 }) {
                        Text(app.userName).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                        Text(`学号: ${app.studentId}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                        Text(`申请时间: ${DateUtil.formatDateTime(app.createTime)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                      }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                    }.width('100%')

                    Text(`自我介绍: ${app.introduction}`)
                      .fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                      .padding(10).backgroundColor(AppColors.BG_SECTION).borderRadius(AppRadius.SM).width('100%')

                    Row({ space: 12 }) {
                      Button('拒绝').layoutWeight(1).height(38).fontSize(AppFontSize.BODY)
                        .fontColor(AppColors.DANGER).backgroundColor(Color.White)
                        .border({ width: 1, color: AppColors.DANGER }).borderRadius(AppRadius.MD)
                        .onClick(() => { this.handleApprove(app, false) })
                      Button('通过').layoutWeight(1).height(38).fontSize(AppFontSize.BODY)
                        .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
                        .onClick(() => { this.handleApprove(app, true) })
                    }.width('100%')
                  }
                  .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.MD)
                })
              }
            }
          }.padding({ left: 16, right: 16, top: 12, bottom: 20 })
        }.layoutWeight(1).scrollBar(BarState.Off)
      }
    }
    .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
