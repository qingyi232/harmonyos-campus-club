// 我的社团页面
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { ClubInfo, UserInfo } from '../../model/DataModels'

@Entry
@Component
struct MyClubsPage {
  @State myClubs: ClubInfo[] = []
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.loadMyClubs()
  }

  async loadMyClubs() {
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.myClubs = await this.dataService.getMyClubs(user.id)
    }
    this.isLoading = false
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
        Text('我的社团')
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

      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color(AppColors.PRIMARY)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.myClubs.length === 0) {
        Column({ space: 16 }) {
          Text('🏛').fontSize(56)
          Text('你还没有加入任何社团').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
          Button('去发现社团')
            .fontSize(AppFontSize.BODY)
            .fontColor(Color.White)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppRadius.ROUND)
            .height(42)
            .onClick(() => { RouterUtil.pushUrl(PageRoutes.STUDENT_CLUBS) })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.myClubs, (club: ClubInfo) => {
            ListItem() {
              Column() {
                Image(club.coverImage)
                  .width('100%')
                  .height(120)
                  .objectFit(ImageFit.Cover)
                  .borderRadius({ topLeft: AppRadius.LG, topRight: AppRadius.LG })

                Row({ space: 12 }) {
                  Image(club.logo)
                    .width(50)
                    .height(50)
                    .borderRadius(AppRadius.MD)
                    .margin({ top: -25 })
                    .border({ width: 3, color: Color.White })

                  Column({ space: 4 }) {
                    Text(club.name)
                      .fontSize(AppFontSize.SUBTITLE)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(AppColors.TEXT_PRIMARY)
                    Row({ space: 8 }) {
                      Text(club.category)
                        .fontSize(10)
                        .fontColor(AppColors.PRIMARY_DARK)
                        .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                        .backgroundColor(AppColors.TAG_GREEN)
                        .borderRadius(AppRadius.ROUND)
                      Text(`👥 ${club.memberCount}人`)
                        .fontSize(AppFontSize.SMALL)
                        .fontColor(AppColors.TEXT_HINT)
                    }
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding({ left: 14, right: 14, top: 8, bottom: 14 })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(AppRadius.LG)
              .onClick(() => {
                RouterUtil.pushUrl(PageRoutes.CLUB_DETAIL, { clubId: club.id } as Record<string, Object>)
              })
            }
          })
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 12 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}
