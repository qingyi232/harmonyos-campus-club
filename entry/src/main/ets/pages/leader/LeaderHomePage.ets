// 社团负责人首页
import { AppColors, AppFontSize, AppRadius, OnlineImages } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { UserInfo, ClubInfo, ActivityInfo, JoinApplication, ApprovalStatus } from '../../model/DataModels'

@Entry
@Component
struct LeaderHomePage {
  @State currentUser: UserInfo | null = null
  @State myClubs: ClubInfo[] = []
  @State recentActivities: ActivityInfo[] = []
  @State pendingApplications: JoinApplication[] = []
  @State totalMembers: number = 0
  @State totalBalance: number = 0
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    this.loadData()
  }

  async loadData() {
    if (!this.currentUser) return
    this.myClubs = await this.dataService.getClubsByLeader(this.currentUser.id)
    let allActivities: ActivityInfo[] = []
    let allPending: JoinApplication[] = []
    let memberCount = 0
    let balance = 0
    for (const club of this.myClubs) {
      const acts = await this.dataService.getActivitiesByClub(club.id)
      allActivities = allActivities.concat(acts)
      const pending = await this.dataService.getPendingJoinApplications(club.id)
      allPending = allPending.concat(pending)
      const members = await this.dataService.getClubMembers(club.id)
      memberCount += members.length
      balance += this.dataService.getClubBalance(club.id)
    }
    this.recentActivities = allActivities.slice(0, 5)
    this.pendingApplications = allPending
    this.totalMembers = memberCount
    this.totalBalance = balance
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 0 }) {
          // 顶部
          Column({ space: 8 }) {
            Row() {
              Column({ space: 4 }) {
                Text(`${this.currentUser?.realName || ''}，社长好 👋`)
                  .fontSize(22)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text('管理你的社团，让它更精彩')
                  .fontSize(AppFontSize.CAPTION)
                  .fontColor('#FFFFFFCC')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Image(this.currentUser?.avatar || OnlineImages.AVATAR_DEFAULT)
                .width(48)
                .height(48)
                .borderRadius(24)
                .border({ width: 2, color: '#FFFFFF80' })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 50, bottom: 20 })
          .linearGradient({
            angle: 135,
            colors: [['#2ECC71', 0], ['#27AE60', 0.5], ['#1E8449', 1]]
          })

          // 数据概览
          Row() {
            this.StatCard('🏛', '我的社团', `${this.myClubs.length}个`)
            this.StatCard('👥', '总成员', `${this.totalMembers}人`)
            this.StatCard('📅', '活动数', `${this.recentActivities.length}个`)
            this.StatCard('💰', '余额', `¥${this.totalBalance}`)
          }
          .width('92%')
          .justifyContent(FlexAlign.SpaceAround)
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
          .margin({ top: -20 })
          .shadow({ radius: 8, color: '#1A000000', offsetY: 2 })

          // 待处理提醒
          if (this.pendingApplications.length > 0) {
            Row({ space: 10 }) {
              Text('🔔')
                .fontSize(20)
              Text(`有 ${this.pendingApplications.length} 条入社申请待审核`)
                .fontSize(AppFontSize.BODY)
                .fontColor(AppColors.WARNING)
                .layoutWeight(1)
              Text('去处理 >')
                .fontSize(AppFontSize.CAPTION)
                .fontColor(AppColors.PRIMARY)
                .onClick(() => {
                  if (this.myClubs.length > 0) {
                    RouterUtil.pushUrl(PageRoutes.LEADER_MEMBER_MANAGE, { clubId: this.myClubs[0].id } as Record<string, Object>)
                  }
                })
            }
            .width('92%')
            .padding(14)
            .backgroundColor('#FFF8E1')
            .borderRadius(AppRadius.MD)
            .margin({ top: 12 })
          }

          // 功能入口
          Column({ space: 10 }) {
            Text('管理功能')
              .fontSize(AppFontSize.SUBTITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
              .alignSelf(ItemAlign.Start)

            Grid() {
              GridItem() { this.FuncEntry('🏛', '社团管理', AppColors.TAG_GREEN, () => { RouterUtil.pushUrl(PageRoutes.LEADER_CLUB_MANAGE) }) }
              GridItem() { this.FuncEntry('📅', '活动管理', AppColors.TAG_BLUE, () => { RouterUtil.pushUrl(PageRoutes.LEADER_ACTIVITY_MANAGE) }) }
              GridItem() { this.FuncEntry('👥', '成员管理', AppColors.TAG_ORANGE, () => {
                if (this.myClubs.length > 0) RouterUtil.pushUrl(PageRoutes.LEADER_MEMBER_MANAGE, { clubId: this.myClubs[0].id } as Record<string, Object>)
              }) }
              GridItem() { this.FuncEntry('💰', '财务管理', AppColors.TAG_PURPLE, () => { RouterUtil.pushUrl(PageRoutes.LEADER_FINANCE) }) }
              GridItem() { this.FuncEntry('📢', '招新管理', AppColors.TAG_BLUE, () => { RouterUtil.pushUrl(PageRoutes.LEADER_RECRUIT_MANAGE) }) }
              GridItem() { this.FuncEntry('✏', '编辑社团', AppColors.TAG_GREEN, () => {
                if (this.myClubs.length > 0) RouterUtil.pushUrl(PageRoutes.LEADER_EDIT_CLUB, { clubId: this.myClubs[0].id } as Record<string, Object>)
              }) }
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(12)
            .columnsGap(12)
            .width('100%')
            .height(200)
          }
          .width('92%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
          .margin({ top: 12 })

          // 我的社团列表
          Column({ space: 10 }) {
            Text('我管理的社团')
              .fontSize(AppFontSize.SUBTITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
              .alignSelf(ItemAlign.Start)

            ForEach(this.myClubs, (club: ClubInfo) => {
              Row({ space: 12 }) {
                Image(club.logo)
                  .width(56)
                  .height(56)
                  .borderRadius(AppRadius.MD)
                  .objectFit(ImageFit.Cover)
                Column({ space: 4 }) {
                  Text(club.name)
                    .fontSize(AppFontSize.BODY)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)
                  Row({ space: 8 }) {
                    Text(club.category)
                      .fontSize(10)
                      .fontColor(AppColors.PRIMARY_DARK)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor(AppColors.TAG_GREEN)
                      .borderRadius(AppRadius.ROUND)
                    Text(`${club.memberCount}人`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Text('>')
                  .fontSize(16)
                  .fontColor(AppColors.TEXT_HINT)
              }
              .width('100%')
              .padding(12)
              .backgroundColor(AppColors.BG_SECTION)
              .borderRadius(AppRadius.SM)
              .onClick(() => {
                RouterUtil.pushUrl(PageRoutes.LEADER_CLUB_MANAGE, { clubId: club.id } as Record<string, Object>)
              })
            })
          }
          .width('92%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
          .margin({ top: 12, bottom: 16 })

          // 退出登录
          Button('退出登录')
            .width('92%')
            .height(48)
            .fontSize(AppFontSize.BODY)
            .fontColor(AppColors.DANGER)
            .backgroundColor(Color.White)
            .borderRadius(AppRadius.LG)
            .border({ width: 1, color: AppColors.DANGER })
            .margin({ bottom: 30 })
            .onClick(() => {
              this.dataService.logout()
              RouterUtil.replaceUrl(PageRoutes.LOGIN)
            })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder StatCard(icon: string, label: string, value: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(24)
      Text(value).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }

  @Builder FuncEntry(icon: string, label: string, bgColor: string, action: () => void) {
    Column({ space: 8 }) {
      Text(icon).fontSize(32)
      Text(label).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(bgColor)
    .borderRadius(AppRadius.LG)
    .onClick(action)
  }
}
