// 社团详情页面
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ClubInfo, ClubMember, ActivityInfo, UserInfo, UserRole, FinanceRecord } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ClubDetailPage {
  @State club: ClubInfo | null = null
  @State members: ClubMember[] = []
  @State activities: ActivityInfo[] = []
  @State financeRecords: FinanceRecord[] = []
  @State clubBalance: number = 0
  @State currentUser: UserInfo | null = null
  @State isMember: boolean = false
  @State isLoading: boolean = true
  @State activeTab: number = 0
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    const params = RouterUtil.getParams()
    if (params && params.clubId) {
      this.loadClubDetail(params.clubId as string)
    }
  }

  async loadClubDetail(clubId: string) {
    this.isLoading = true
    this.club = await this.dataService.getClubById(clubId)
    this.members = await this.dataService.getClubMembers(clubId)
    this.activities = await this.dataService.getActivitiesByClub(clubId)
    this.financeRecords = await this.dataService.getFinanceRecords(clubId)
    this.clubBalance = this.dataService.getClubBalance(clubId)
    if (this.currentUser) {
      const myClubs = await this.dataService.getMyClubs(this.currentUser.id)
      this.isMember = myClubs.some(c => c.id === clubId)
    }
    this.isLoading = false
  }

  async handleJoin() {
    if (!this.currentUser || !this.club) return
    const success = await this.dataService.submitJoinApplication({
      clubId: this.club.id, clubName: this.club.name,
      userId: this.currentUser.id, userName: this.currentUser.realName,
      studentId: this.currentUser.studentId, introduction: '我对贵社团很感兴趣，希望加入！'
    })
    if (success) {
      promptAction.showToast({ message: '申请已提交，等待审核', duration: 2000 })
    } else {
      promptAction.showToast({ message: '您已提交过申请', duration: 2000 })
    }
  }

  build() {
    Column() {
      if (this.isLoading || !this.club) {
        Column() {
          LoadingProgress().width(40).height(40).color(AppColors.PRIMARY)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 顶部导航
        Stack({ alignContent: Alignment.TopStart }) {
          Image(this.club.coverImage)
            .width('100%')
            .height(220)
            .objectFit(ImageFit.Cover)

          Row() {
            Text('←')
              .fontSize(24)
              .fontColor(Color.White)
              .onClick(() => { RouterUtil.back() })
              .padding(10)
              .backgroundColor('#40000000')
              .borderRadius(20)
          }
          .padding({ left: 12, top: 44 })
        }
        .width('100%')
        .height(220)

        // 社团信息卡片
        Column({ space: 8 }) {
          Row({ space: 14 }) {
            Image(this.club.logo)
              .width(64)
              .height(64)
              .borderRadius(AppRadius.MD)
              .border({ width: 3, color: Color.White })
              .margin({ top: -32 })

            Column({ space: 4 }) {
              Text(this.club.name)
                .fontSize(AppFontSize.TITLE)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY)
              Text(this.club.slogan)
                .fontSize(AppFontSize.CAPTION)
                .fontColor(AppColors.TEXT_SECONDARY)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')

          Row({ space: 12 }) {
            Text(this.club.category)
              .fontSize(11)
              .fontColor(AppColors.PRIMARY_DARK)
              .padding({ left: 10, right: 10, top: 3, bottom: 3 })
              .backgroundColor(AppColors.TAG_GREEN)
              .borderRadius(AppRadius.ROUND)
            Text(`👥 ${this.club.memberCount}/${this.club.maxMembers}人`)
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
            Text(`负责人: ${this.club.leaderName}`)
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
          }
          .width('100%')
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 8, bottom: 16 })
        .backgroundColor(Color.White)

        // Tab切换
        Row() {
          ForEach(['简介', '成员', '活动', '经费'], (tab: string, index: number) => {
            Text(tab)
              .fontSize(AppFontSize.BODY)
              .fontColor(this.activeTab === index ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
              .fontWeight(this.activeTab === index ? FontWeight.Bold : FontWeight.Normal)
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .border({ width: { bottom: 2 }, color: this.activeTab === index ? AppColors.PRIMARY : Color.Transparent })
              .onClick(() => { this.activeTab = index })
          })
        }
        .width('100%')
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: 1 })

        // Tab内容
        Scroll() {
          Column() {
            if (this.activeTab === 0) {
              this.IntroTab()
            } else if (this.activeTab === 1) {
              this.MembersTab()
            } else if (this.activeTab === 2) {
              this.ActivitiesTab()
            } else {
              this.FinanceTab()
            }
          }
          .padding(16)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 底部操作栏（学生端）
        if (this.currentUser?.role === UserRole.STUDENT && !this.isMember) {
          Row() {
            Button('申请加入社团')
              .width('90%')
              .height(48)
              .fontSize(AppFontSize.BODY)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .backgroundColor(AppColors.PRIMARY)
              .borderRadius(AppRadius.LG)
              .onClick(() => { this.handleJoin() })
          }
          .width('100%')
          .height(70)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(Color.White)
          .border({ width: { top: 1 }, color: AppColors.BORDER_LIGHT })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder IntroTab() {
    Column({ space: 12 }) {
      Text('社团简介')
        .fontSize(AppFontSize.SUBTITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)
      Text(this.club?.description || '')
        .fontSize(AppFontSize.BODY)
        .fontColor(AppColors.TEXT_SECONDARY)
        .lineHeight(24)
      Divider().color(AppColors.DIVIDER).margin({ top: 8, bottom: 8 })
      Text('联系方式')
        .fontSize(AppFontSize.SUBTITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)
      Text(this.club?.contactInfo || '暂无')
        .fontSize(AppFontSize.BODY)
        .fontColor(AppColors.TEXT_SECONDARY)
      if (this.club && this.club.tags.length > 0) {
        Divider().color(AppColors.DIVIDER).margin({ top: 8, bottom: 8 })
        Text('标签')
          .fontSize(AppFontSize.SUBTITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.club.tags, (tag: string) => {
            Text(`#${tag}`)
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.ACCENT)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
              .backgroundColor(AppColors.TAG_BLUE)
              .borderRadius(AppRadius.ROUND)
              .margin({ right: 8, bottom: 8 })
          })
        }
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder MembersTab() {
    Column({ space: 8 }) {
      Text(`共 ${this.members.length} 名成员`)
        .fontSize(AppFontSize.CAPTION)
        .fontColor(AppColors.TEXT_HINT)
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 4 })

      ForEach(this.members, (member: ClubMember) => {
        Row({ space: 12 }) {
          Text(member.userName.charAt(0))
            .fontSize(18)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .width(42)
            .height(42)
            .borderRadius(21)
            .backgroundColor(member.role === 'leader' ? AppColors.PRIMARY : AppColors.ACCENT)

          Column({ space: 3 }) {
            Text(member.userName)
              .fontSize(AppFontSize.BODY)
              .fontColor(AppColors.TEXT_PRIMARY)
            Text(`学号: ${member.studentId}`)
              .fontSize(AppFontSize.SMALL)
              .fontColor(AppColors.TEXT_HINT)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Text(member.role === 'leader' ? '社长' : member.role === 'vice_leader' ? '副社长' : '成员')
            .fontSize(AppFontSize.SMALL)
            .fontColor(member.role === 'leader' ? AppColors.WARNING : AppColors.TEXT_SECONDARY)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor(member.role === 'leader' ? AppColors.TAG_ORANGE : AppColors.BG_INPUT)
            .borderRadius(AppRadius.ROUND)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.SM)
      })
    }
    .width('100%')
  }

  @Builder ActivitiesTab() {
    Column({ space: 10 }) {
      if (this.activities.length === 0) {
        Text('暂无活动')
          .fontSize(AppFontSize.BODY)
          .fontColor(AppColors.TEXT_HINT)
          .padding(30)
      } else {
        ForEach(this.activities, (activity: ActivityInfo) => {
          Row({ space: 12 }) {
            Image(activity.coverImage)
              .width(80)
              .height(60)
              .borderRadius(AppRadius.SM)
              .objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text(activity.title)
                .fontSize(AppFontSize.BODY)
                .fontColor(AppColors.TEXT_PRIMARY)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(`📍 ${activity.location}`)
                .fontSize(AppFontSize.SMALL)
                .fontColor(AppColors.TEXT_SECONDARY)
              Text(`📅 ${DateUtil.formatDate(activity.startTime)}`)
                .fontSize(AppFontSize.SMALL)
                .fontColor(AppColors.TEXT_HINT)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.SM)
        })
      }
    }
    .width('100%')
  }

  @Builder FinanceTab() {
    Column({ space: 10 }) {
      // 余额概览
      Row() {
        Column({ space: 4 }) {
          Text('社团经费余额').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_HINT)
          Text(`¥${this.clubBalance}`).fontSize(24).fontWeight(FontWeight.Bold).fontColor(AppColors.PRIMARY)
        }.alignItems(HorizontalAlign.Start)
      }
      .width('100%').padding(14).backgroundColor(AppColors.TAG_GREEN).borderRadius(AppRadius.MD)

      Row({ space: 6 }) {
        Text('ℹ').fontSize(14)
        Text('以下为本社团公开的经费收支明细，操作人信息已隐藏。')
          .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT).layoutWeight(1)
      }.width('100%')

      if (this.financeRecords.length === 0) {
        Text('暂无经费记录').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_HINT).padding(20)
      } else {
        ForEach(this.financeRecords, (record: FinanceRecord) => {
          Row({ space: 10 }) {
            Text(record.type === 'income' ? '📈' : '📉').fontSize(20)
            Column({ space: 2 }) {
              Text(record.description).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
              Text(record.category).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
            }.layoutWeight(1).alignItems(HorizontalAlign.Start)
            Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount}`)
              .fontSize(AppFontSize.BODY).fontWeight(FontWeight.Bold)
              .fontColor(record.type === 'income' ? AppColors.PRIMARY : AppColors.DANGER)
          }
          .width('100%').padding(12).backgroundColor(Color.White).borderRadius(AppRadius.SM)
        })
      }
    }
    .width('100%')
  }
}
