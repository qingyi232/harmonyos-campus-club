// 学生首页
import { AppColors, AppFontSize, AppRadius, OnlineImages } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ClubInfo, ActivityInfo, NoticeInfo, UserInfo } from '../../model/DataModels'

@Entry
@Component
struct StudentHomePage {
  @State currentUser: UserInfo | null = null
  @State clubs: ClubInfo[] = []
  @State activities: ActivityInfo[] = []
  @State notices: NoticeInfo[] = []
  @State currentTab: number = 0
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    this.loadData()
  }

  async loadData() {
    this.clubs = await this.dataService.getClubs()
    this.activities = await this.dataService.getActivities()
    this.notices = await this.dataService.getNotices('student')
  }

  build() {
    Column() {
      // 根据tab显示不同内容
      if (this.currentTab === 0) {
        this.HomeContent()
      } else if (this.currentTab === 1) {
        this.ClubsContent()
      } else if (this.currentTab === 2) {
        this.ActivitiesContent()
      } else if (this.currentTab === 3) {
        this.ProfileContent()
      }

      // 底部导航栏
      Row() {
        this.TabItem(0, '🏠', '首页')
        this.TabItem(1, '🏛', '社团')
        this.TabItem(2, '📅', '活动')
        this.TabItem(3, '👤', '我的')
      }
      .width('100%')
      .height(60)
      .backgroundColor(Color.White)
      .border({ width: { top: 1 }, color: AppColors.BORDER_LIGHT })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder TabItem(index: number, icon: string, label: string) {
    Column({ space: 3 }) {
      Text(icon)
        .fontSize(22)
      Text(label)
        .fontSize(11)
        .fontColor(this.currentTab === index ? AppColors.PRIMARY : AppColors.TEXT_HINT)
        .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)
    }
    .onClick(() => {
      this.currentTab = index
    })
    .padding(8)
  }

  // ========== 首页内容 ==========
  @Builder HomeContent() {
    Scroll() {
      Column({ space: 0 }) {
        // 顶部问候
        Row() {
          Column({ space: 4 }) {
            Text(`你好，${this.currentUser?.realName || '同学'} 👋`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
            Text('探索精彩社团生活')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.TEXT_SECONDARY)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Image(this.currentUser?.avatar || OnlineImages.AVATAR_DEFAULT)
            .width(48)
            .height(48)
            .borderRadius(24)
            .border({ width: 2, color: AppColors.PRIMARY_LIGHT })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 16 })
        .backgroundColor(Color.White)

        // Banner
        Image(OnlineImages.BANNER_CAMPUS)
          .width('92%')
          .height(150)
          .borderRadius(AppRadius.LG)
          .objectFit(ImageFit.Cover)
          .margin({ top: 12 })

        // 快捷入口
        Row() {
          this.QuickEntry('🏛', '全部社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_CLUBS) })
          this.QuickEntry('📅', '近期活动', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_ACTIVITIES) })
          this.QuickEntry('📢', '社团招新', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_RECRUITMENT) })
          this.QuickEntry('💼', '我的社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_MY_CLUBS) })
        }
        .width('92%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding(16)
        .margin({ top: 12 })
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.LG)

        // 第二行快捷入口
        Row() {
          this.QuickEntry('📋', '我的报名', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_PROFILE) })
          this.QuickEntry('✏', '创建社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_APPLY_CLUB) })
          this.QuickEntry('💰', '经费查看', () => {
            // 跳转到我的社团页面，从那里可以查看经费
            RouterUtil.pushUrl(PageRoutes.STUDENT_MY_CLUBS)
          })
          this.QuickEntry('🔔', '消息通知', () => {
            // 切换到首页通知区域
            this.currentTab = 0
          })
        }
        .width('92%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding(16)
        .margin({ top: 8 })
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.LG)

        // 通知公告
        if (this.notices.length > 0) {
          Column({ space: 10 }) {
            Row() {
              Text('📢')
                .fontSize(16)
              Text(' 通知公告')
                .fontSize(AppFontSize.SUBTITLE)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY)
            }
            .width('100%')

            ForEach(this.notices.slice(0, 3), (notice: NoticeInfo) => {
              Row() {
                Column({ space: 4 }) {
                  Text(notice.title)
                    .fontSize(AppFontSize.BODY)
                    .fontColor(AppColors.TEXT_PRIMARY)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(DateUtil.formatRelative(notice.createTime))
                    .fontSize(AppFontSize.SMALL)
                    .fontColor(AppColors.TEXT_HINT)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                if (!notice.isRead) {
                  Circle()
                    .width(8)
                    .height(8)
                    .fill(AppColors.DANGER)
                }
              }
              .width('100%')
              .padding(12)
              .backgroundColor(AppColors.BG_SECTION)
              .borderRadius(AppRadius.SM)
            })
          }
          .width('92%')
          .padding(16)
          .margin({ top: 12 })
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
        }

        // 热门社团
        Column({ space: 10 }) {
          Row() {
            Text('🔥 热门社团')
              .fontSize(AppFontSize.SUBTITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
              .layoutWeight(1)
            Text('查看全部 >')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.PRIMARY)
              .onClick(() => { RouterUtil.pushUrl(PageRoutes.STUDENT_CLUBS) })
          }
          .width('100%')

          ForEach(this.clubs.slice(0, 4), (club: ClubInfo) => {
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
                Text(club.slogan)
                  .fontSize(AppFontSize.CAPTION)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Row({ space: 6 }) {
                  Text(club.category)
                    .fontSize(10)
                    .fontColor(AppColors.PRIMARY)
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
            }
            .width('100%')
            .padding(12)
            .backgroundColor(AppColors.BG_SECTION)
            .borderRadius(AppRadius.SM)
            .onClick(() => {
              RouterUtil.pushUrl(PageRoutes.CLUB_DETAIL, { clubId: club.id } as Record<string, Object>)
            })
          })
        }
        .width('92%')
        .padding(16)
        .margin({ top: 12 })
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.LG)

        // 近期活动
        Column({ space: 10 }) {
          Row() {
            Text('📅 近期活动')
              .fontSize(AppFontSize.SUBTITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
              .layoutWeight(1)
            Text('查看全部 >')
              .fontSize(AppFontSize.CAPTION)
              .fontColor(AppColors.PRIMARY)
              .onClick(() => { RouterUtil.pushUrl(PageRoutes.STUDENT_ACTIVITIES) })
          }
          .width('100%')

          ForEach(this.activities.slice(0, 3), (activity: ActivityInfo) => {
            Column({ space: 8 }) {
              Image(activity.coverImage)
                .width('100%')
                .height(140)
                .borderRadius({ topLeft: AppRadius.MD, topRight: AppRadius.MD })
                .objectFit(ImageFit.Cover)

              Column({ space: 4 }) {
                Text(activity.title)
                  .fontSize(AppFontSize.BODY)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppColors.TEXT_PRIMARY)
                Row({ space: 6 }) {
                  Text(`📍 ${activity.location}`)
                    .fontSize(AppFontSize.SMALL)
                    .fontColor(AppColors.TEXT_SECONDARY)
                }
                Row() {
                  Text(`${activity.clubName}`)
                    .fontSize(AppFontSize.SMALL)
                    .fontColor(AppColors.PRIMARY)
                  Blank()
                  Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
                    .fontSize(AppFontSize.SMALL)
                    .fontColor(AppColors.TEXT_HINT)
                }
                .width('100%')
              }
              .width('100%')
              .padding({ left: 12, right: 12, bottom: 12 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .backgroundColor(AppColors.BG_SECTION)
            .borderRadius(AppRadius.MD)
            .onClick(() => {
              RouterUtil.pushUrl(PageRoutes.ACTIVITY_DETAIL, { activityId: activity.id } as Record<string, Object>)
            })
          })
        }
        .width('92%')
        .padding(16)
        .margin({ top: 12, bottom: 16 })
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.LG)
      }
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  @Builder QuickEntry(icon: string, label: string, action: () => void) {
    Column({ space: 6 }) {
      Text(icon)
        .fontSize(28)
      Text(label)
        .fontSize(AppFontSize.CAPTION)
        .fontColor(AppColors.TEXT_PRIMARY)
    }
    .onClick(action)
  }

  // ========== 社团列表Tab ==========
  @Builder ClubsContent() {
    Column() {
      Row() {
        Text('全部社团').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      }.width('100%').padding({ left: 20, right: 20, top: 16, bottom: 8 })

      if (this.clubs.length === 0) {
        Column({ space: 12 }) {
          Text('🏛').fontSize(48)
          Text('暂无社团').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_HINT)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.clubs, (club: ClubInfo) => {
            ListItem() {
              Row({ space: 12 }) {
                Image(club.logo).width(56).height(56).borderRadius(12).objectFit(ImageFit.Cover)
                Column({ space: 4 }) {
                  Text(club.name).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Text(club.description).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                    .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row({ space: 6 }) {
                    Text(`👤 ${club.memberCount}人`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                    Text(club.category).fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                      .padding({ left: 6, right: 6, top: 1, bottom: 1 }).backgroundColor(AppColors.TAG_GREEN).borderRadius(8)
                  }
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
              }
              .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.LG)
              .onClick(() => { RouterUtil.pushUrl(PageRoutes.CLUB_DETAIL, { clubId: club.id } as Record<string, Object>) })
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16 }).scrollBar(BarState.Off)
      }
    }.layoutWeight(1)
  }

  // ========== 活动列表Tab ==========
  @Builder ActivitiesContent() {
    Column() {
      Row() {
        Text('近期活动').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      }.width('100%').padding({ left: 20, right: 20, top: 16, bottom: 8 })

      if (this.activities.length === 0) {
        Column({ space: 12 }) {
          Text('📅').fontSize(48)
          Text('暂无活动').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_HINT)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.activities, (activity: ActivityInfo) => {
            ListItem() {
              Column({ space: 0 }) {
                Image(activity.coverImage).width('100%').height(140).objectFit(ImageFit.Cover)
                  .borderRadius({ topLeft: AppRadius.LG, topRight: AppRadius.LG })
                Column({ space: 6 }) {
                  Row() {
                    Text(activity.clubName).fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                    Blank()
                    Text(`${activity.currentParticipants}/${activity.maxParticipants}人`)
                      .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }.width('100%')
                  Text(activity.title).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Row({ space: 8 }) {
                    Text(`📍 ${activity.location}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_SECONDARY)
                    Blank()
                    Text(`📅 ${DateUtil.formatDate(activity.startTime)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }.width('100%')
                }.padding(12).alignItems(HorizontalAlign.Start)
              }
              .width('100%').backgroundColor(Color.White).borderRadius(AppRadius.LG)
              .onClick(() => { RouterUtil.pushUrl(PageRoutes.ACTIVITY_DETAIL, { activityId: activity.id } as Record<string, Object>) })
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16 }).scrollBar(BarState.Off)
      }
    }.layoutWeight(1)
  }

  // ========== 个人中心Tab ==========
  @Builder ProfileContent() {
    Scroll() {
      Column({ space: 12 }) {
        // 用户信息卡片
        Column({ space: 10 }) {
          Row({ space: 14 }) {
            Image(this.currentUser?.avatar || OnlineImages.DEFAULT_AVATAR)
              .width(64).height(64).borderRadius(32).objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text(this.currentUser?.realName || '').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
              Text(`${this.currentUser?.college || ''} · ${this.currentUser?.major || ''}`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
              Text(`学号: ${this.currentUser?.studentId || ''}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
          }.width('100%')
        }.width('100%').padding(20).backgroundColor(Color.White).borderRadius(AppRadius.LG)

        // 功能菜单
        Column({ space: 0 }) {
          this.ProfileMenuItem('🏛', '我的社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_MY_CLUBS) })
          Divider().color(AppColors.DIVIDER).margin({ left: 44 })
          this.ProfileMenuItem('📅', '活动记录', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_ACTIVITIES) })
          Divider().color(AppColors.DIVIDER).margin({ left: 44 })
          this.ProfileMenuItem('📢', '社团招新', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_RECRUITMENT) })
          Divider().color(AppColors.DIVIDER).margin({ left: 44 })
          this.ProfileMenuItem('✏', '申请创建社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_APPLY_CLUB) })
        }.width('100%').backgroundColor(Color.White).borderRadius(AppRadius.LG)

        // 退出登录
        Button('退出登录').width('100%').height(46).fontSize(AppFontSize.BODY)
          .fontColor(AppColors.DANGER).backgroundColor(Color.White).borderRadius(AppRadius.LG)
          .border({ width: 1, color: AppColors.DANGER })
          .onClick(() => { this.dataService.logout(); RouterUtil.replaceUrl(PageRoutes.LOGIN) })
      }.padding({ left: 16, right: 16, top: 16, bottom: 20 })
    }.layoutWeight(1).scrollBar(BarState.Off)
  }

  @Builder ProfileMenuItem(icon: string, label: string, action: () => void) {
    Row({ space: 12 }) {
      Text(icon).fontSize(20)
      Text(label).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      Text('>').fontSize(16).fontColor(AppColors.TEXT_HINT)
    }.width('100%').height(52).padding({ left: 16, right: 16 }).onClick(action)
  }
}
