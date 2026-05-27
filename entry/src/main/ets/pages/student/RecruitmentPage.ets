// 社团招新页面 - 学生端浏览招新信息
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { RecruitmentInfo, UserInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct RecruitmentPage {
  @State recruitments: RecruitmentInfo[] = []
  @State currentUser: UserInfo | null = null
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    this.loadData()
  }

  async loadData() {
    this.isLoading = true
    this.recruitments = await this.dataService.getRecruitments()
    this.isLoading = false
  }

  async handleApply(rec: RecruitmentInfo) {
    if (!this.currentUser) return
    const success = await this.dataService.submitJoinApplication({
      clubId: rec.clubId,
      clubName: rec.clubName,
      userId: this.currentUser.id,
      userName: this.currentUser.realName,
      studentId: this.currentUser.studentId,
      introduction: '通过招新页面申请加入'
    })
    if (success) {
      promptAction.showToast({ message: '申请已提交，等待社团负责人审核', duration: 2000 })
    } else {
      promptAction.showToast({ message: '您已提交过该社团的申请', duration: 2000 })
    }
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('社团招新').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.recruitments.length === 0) {
        Column({ space: 12 }) {
          Text('📢').fontSize(48)
          Text('暂无招新信息').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 14 }) {
          ForEach(this.recruitments, (rec: RecruitmentInfo) => {
            ListItem() {
              Column({ space: 0 }) {
                // 招新海报
                Image(rec.posterImage)
                  .width('100%')
                  .height(160)
                  .objectFit(ImageFit.Cover)
                  .borderRadius({ topLeft: AppRadius.LG, topRight: AppRadius.LG })

                Column({ space: 8 }) {
                  Row() {
                    Text(rec.clubName)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.PRIMARY)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor(AppColors.TAG_GREEN)
                      .borderRadius(AppRadius.ROUND)
                    Blank()
                    Text(`截止: ${DateUtil.formatDate(rec.deadline)}`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.WARNING)
                  }.width('100%')

                  Text(rec.title)
                    .fontSize(AppFontSize.SUBTITLE)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)

                  Text(rec.description)
                    .fontSize(AppFontSize.CAPTION)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row({ space: 6 }) {
                    Text('📋 要求:')
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                    Text(rec.requirements)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_SECONDARY)
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }.width('100%')

                  Row({ space: 6 }) {
                    Text('📞 联系:')
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                    Text(rec.contactInfo)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_SECONDARY)
                      .layoutWeight(1)
                      .maxLines(1)
                  }.width('100%')

                  Button('申请加入')
                    .width('100%')
                    .height(40)
                    .fontSize(AppFontSize.BODY)
                    .fontColor(Color.White)
                    .backgroundColor(AppColors.PRIMARY)
                    .borderRadius(AppRadius.MD)
                    .margin({ top: 4 })
                    .onClick(() => { this.handleApply(rec) })
                }
                .width('100%')
                .padding(14)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(AppRadius.LG)
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
      }
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
