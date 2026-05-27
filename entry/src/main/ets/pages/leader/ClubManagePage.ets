// 社团管理页面 - 负责人端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { ClubInfo, UserInfo } from '../../model/DataModels'

@Entry
@Component
struct ClubManagePage {
  @State clubs: ClubInfo[] = []
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.loadClubs()
  }

  async loadClubs() {
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.clubs = await this.dataService.getClubsByLeader(user.id)
    }
    this.isLoading = false
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('社团管理').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }
      .width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.clubs, (club: ClubInfo) => {
            ListItem() {
              Column({ space: 12 }) {
                Row({ space: 14 }) {
                  Image(club.logo).width(64).height(64).borderRadius(AppRadius.MD).objectFit(ImageFit.Cover)
                  Column({ space: 4 }) {
                    Text(club.name).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                    Text(club.slogan).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                    Row({ space: 8 }) {
                      Text(club.category).fontSize(10).fontColor(AppColors.PRIMARY_DARK)
                        .padding({ left: 8, right: 8, top: 2, bottom: 2 }).backgroundColor(AppColors.TAG_GREEN).borderRadius(AppRadius.ROUND)
                      Text(`👥 ${club.memberCount}/${club.maxMembers}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                    }
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                }.width('100%')

                Divider().color(AppColors.DIVIDER)

                // 管理操作
                Row() {
                  this.ActionBtn('✏ 编辑', () => {
                    RouterUtil.pushUrl(PageRoutes.LEADER_EDIT_CLUB, { clubId: club.id } as Record<string, Object>)
                  })
                  Divider().vertical(true).height(20).color(AppColors.DIVIDER)
                  this.ActionBtn('👥 成员', () => {
                    RouterUtil.pushUrl(PageRoutes.LEADER_MEMBER_MANAGE, { clubId: club.id } as Record<string, Object>)
                  })
                  Divider().vertical(true).height(20).color(AppColors.DIVIDER)
                  this.ActionBtn('📅 活动', () => {
                    RouterUtil.pushUrl(PageRoutes.LEADER_ACTIVITY_MANAGE, { clubId: club.id } as Record<string, Object>)
                  })
                  Divider().vertical(true).height(20).color(AppColors.DIVIDER)
                  this.ActionBtn('💰 财务', () => {
                    RouterUtil.pushUrl(PageRoutes.LEADER_FINANCE, { clubId: club.id } as Record<string, Object>)
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceAround)
              }
              .width('100%')
              .padding(16)
              .backgroundColor(Color.White)
              .borderRadius(AppRadius.LG)
            }
          })
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 12 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }

  @Builder ActionBtn(label: string, action: () => void) {
    Text(label)
      .fontSize(AppFontSize.CAPTION)
      .fontColor(AppColors.PRIMARY)
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .onClick(action)
  }
}
