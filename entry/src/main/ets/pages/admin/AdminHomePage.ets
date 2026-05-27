// 管理员首页
import { AppColors, AppFontSize, AppRadius, OnlineImages } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { UserInfo, StatisticsData, ClubApplication, ApprovalStatus, ActivityInfo, ActivityStatus } from '../../model/DataModels'

@Entry
@Component
struct AdminHomePage {
  @State currentUser: UserInfo | null = null
  @State stats: StatisticsData | null = null
  @State pendingClubApps: number = 0
  @State pendingActivityApps: number = 0
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    this.loadData()
  }

  async loadData() {
    this.stats = await this.dataService.getStatistics()
    const clubApps = await this.dataService.getClubApplications(ApprovalStatus.PENDING)
    this.pendingClubApps = clubApps.length
    const allActivities = await this.dataService.getAllActivities()
    this.pendingActivityApps = allActivities.filter(a => a.status === ActivityStatus.PENDING).length
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 0 }) {
          // 顶部
          Column() {
            Row() {
              Column({ space: 4 }) {
                Text(`管理员 ${this.currentUser?.realName || ''} 👋`)
                  .fontSize(22).fontWeight(FontWeight.Bold).fontColor(Color.White)
                Text('校园社团管理系统 · 管理后台')
                  .fontSize(AppFontSize.CAPTION).fontColor('#FFFFFFCC')
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)
              Image(this.currentUser?.avatar || OnlineImages.AVATAR_DEFAULT)
                .width(48).height(48).borderRadius(24).border({ width: 2, color: '#FFFFFF80' })
            }.width('100%')
          }
          .width('100%').padding({ left: 20, right: 20, top: 50, bottom: 24 })
          .linearGradient({ angle: 135, colors: [['#1E8449', 0], ['#27AE60', 0.5], ['#2ECC71', 1]] })

          // 数据概览
          Column({ space: 12 }) {
            Row() {
              this.BigStat('🏛', '社团总数', `${this.stats?.totalClubs || 0}`)
              this.BigStat('👥', '学生总数', `${this.stats?.totalStudents || 0}`)
              this.BigStat('📅', '活动总数', `${this.stats?.totalActivities || 0}`)
              this.BigStat('💰', '经费余额', `¥${this.stats?.totalFinance || 0}`)
            }.width('100%').justifyContent(FlexAlign.SpaceAround)
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)
          .margin({ top: -16 }).shadow({ radius: 8, color: '#1A000000', offsetY: 2 })

          // 待处理事项
          Column({ space: 10 }) {
            Text('⏳ 待处理事项')
              .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

            Row({ space: 12 }) {
              this.PendingCard('社团申请', this.pendingClubApps, AppColors.WARNING, () => {
                RouterUtil.pushUrl(PageRoutes.ADMIN_CLUB_APPROVAL)
              })
              this.PendingCard('活动审批', this.pendingActivityApps, AppColors.ACCENT, () => {
                RouterUtil.pushUrl(PageRoutes.ADMIN_ACTIVITY_APPROVAL)
              })
            }.width('100%')
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ top: 12 })

          // 管理功能
          Column({ space: 10 }) {
            Text('📋 管理功能')
              .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

            Grid() {
              GridItem() { this.FuncEntry('🏛', '社团审批', AppColors.TAG_GREEN, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_CLUB_APPROVAL) }) }
              GridItem() { this.FuncEntry('📅', '活动审批', AppColors.TAG_BLUE, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_ACTIVITY_APPROVAL) }) }
              GridItem() { this.FuncEntry('💰', '财务监管', AppColors.TAG_ORANGE, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_FINANCE_OVERVIEW) }) }
              GridItem() { this.FuncEntry('📊', '数据统计', AppColors.TAG_PURPLE, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_STATISTICS) }) }
              GridItem() { this.FuncEntry('👥', '用户管理', AppColors.TAG_BLUE, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_USER_MANAGE) }) }
              GridItem() { this.FuncEntry('🔔', '通知公告', AppColors.BG_INPUT, () => { RouterUtil.pushUrl(PageRoutes.ADMIN_STATISTICS) }) }
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(12).columnsGap(12)
            .width('100%').height(200)
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ top: 12 })

          // 社团分类统计
          if (this.stats && this.stats.clubCategoryStats.length > 0) {
            Column({ space: 10 }) {
              Text('📊 社团分类分布')
                .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

              ForEach(this.stats.clubCategoryStats, (stat: { category: string; count: number; percentage: number }) => {
                Row({ space: 10 }) {
                  Text(stat.category).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY).width(80)
                  Progress({ value: stat.percentage, total: 100 })
                    .layoutWeight(1).height(8).color(AppColors.PRIMARY)
                    .backgroundColor(AppColors.PRIMARY_LIGHT).borderRadius(4)
                  Text(`${stat.count}个 (${stat.percentage}%)`)
                    .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT).width(80).textAlign(TextAlign.End)
                }.width('100%')
              })
            }
            .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ top: 12 })
          }

          // 退出登录
          Button('退出登录')
            .width('92%').height(48).fontSize(AppFontSize.BODY)
            .fontColor(AppColors.DANGER).backgroundColor(Color.White)
            .borderRadius(AppRadius.LG).border({ width: 1, color: AppColors.DANGER })
            .margin({ top: 20, bottom: 30 })
            .onClick(() => { this.dataService.logout(); RouterUtil.replaceUrl(PageRoutes.LOGIN) })
        }
      }
      .layoutWeight(1).scrollBar(BarState.Off)
    }
    .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }

  @Builder BigStat(icon: string, label: string, value: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(24)
      Text(value).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }

  @Builder PendingCard(label: string, count: number, color: string, action: () => void) {
    Row({ space: 10 }) {
      Column({ space: 4 }) {
        Text(label).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
        Text(`${count} 条待处理`).fontSize(AppFontSize.SMALL).fontColor(count > 0 ? color : AppColors.TEXT_HINT)
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
      Text('>').fontSize(16).fontColor(AppColors.TEXT_HINT)
    }
    .layoutWeight(1).padding(14).backgroundColor(count > 0 ? '#FFF8E1' : AppColors.BG_SECTION)
    .borderRadius(AppRadius.MD).onClick(action)
  }

  @Builder FuncEntry(icon: string, label: string, bgColor: string, action: () => void) {
    Column({ space: 6 }) {
      Text(icon).fontSize(28)
      Text(label).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_PRIMARY)
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(bgColor).borderRadius(AppRadius.LG).onClick(action)
  }
}
