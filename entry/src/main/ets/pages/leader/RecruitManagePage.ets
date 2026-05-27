// 招新管理页面 - 负责人端（发布招新海报/要求）
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { RecruitmentInfo, ClubInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct RecruitManagePage {
  @State myClubs: ClubInfo[] = []
  @State recruitments: RecruitmentInfo[] = []
  @State isLoading: boolean = true
  @State showCreateDialog: boolean = false
  @State selectedClubIndex: number = 0
  @State newTitle: string = ''
  @State newDescription: string = ''
  @State newRequirements: string = ''
  @State newContactInfo: string = ''
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.myClubs = await this.dataService.getClubsByLeader(user.id)
      let allRecs: RecruitmentInfo[] = []
      for (const club of this.myClubs) {
        const recs = await this.dataService.getRecruitments(club.id)
        allRecs = allRecs.concat(recs)
      }
      this.recruitments = allRecs
    }
    this.isLoading = false
  }

  async handleCreate() {
    if (!this.newTitle || !this.newDescription) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 })
      return
    }
    const club = this.myClubs[this.selectedClubIndex]
    if (club) {
      await this.dataService.createRecruitment({
        clubId: club.id, clubName: club.name,
        title: this.newTitle, description: this.newDescription,
        requirements: this.newRequirements, contactInfo: this.newContactInfo
      })
      promptAction.showToast({ message: '招新信息发布成功', duration: 1500 })
      this.showCreateDialog = false
      this.newTitle = ''
      this.newDescription = ''
      this.newRequirements = ''
      this.newContactInfo = ''
      this.loadData()
    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
            .onClick(() => { RouterUtil.back() }).padding(10)
          Text('招新管理').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
          Text('+').fontSize(28).fontColor(AppColors.PRIMARY)
            .onClick(() => { this.showCreateDialog = true }).padding(10)
        }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

        if (this.isLoading) {
          Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
            .layoutWeight(1).justifyContent(FlexAlign.Center)
        } else if (this.recruitments.length === 0) {
          Column({ space: 12 }) {
            Text('📢').fontSize(48)
            Text('暂无招新信息，点击右上角发布').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY)
          }.layoutWeight(1).justifyContent(FlexAlign.Center)
        } else {
          List({ space: 12 }) {
            ForEach(this.recruitments, (rec: RecruitmentInfo) => {
              ListItem() {
                Column({ space: 8 }) {
                  Row() {
                    Text(rec.clubName).fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor(AppColors.TAG_GREEN).borderRadius(AppRadius.ROUND)
                    Blank()
                    Text(rec.status === 'active' ? '招新中' : '已关闭')
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(rec.status === 'active' ? AppColors.PRIMARY : AppColors.TEXT_HINT)
                  }.width('100%')
                  Text(rec.title).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Text(rec.description).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
                    .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(`截止: ${DateUtil.formatDate(rec.deadline)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.WARNING)
                }
                .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.LG)
              }
            })
          }.layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
        }
      }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)

      // 发布招新弹窗
      if (this.showCreateDialog) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showCreateDialog = false })
          .position({ x: 0, y: 0 })

        Column({ space: 12 }) {
          Text('发布招新信息').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)

          if (this.myClubs.length > 1) {
            Select(this.myClubs.map(c => ({ value: c.name } as SelectOption)))
              .selected(this.selectedClubIndex)
              .value(this.myClubs.length > 0 ? this.myClubs[this.selectedClubIndex].name : '')
              .font({ size: AppFontSize.BODY }).width('100%')
              .onSelect((i: number) => { this.selectedClubIndex = i })
          }

          TextInput({ placeholder: '招新标题', text: this.newTitle })
            .width('100%').height(44).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newTitle = v })
          TextArea({ placeholder: '招新描述...', text: this.newDescription })
            .width('100%').height(80).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newDescription = v })
          TextInput({ placeholder: '招新要求', text: this.newRequirements })
            .width('100%').height(44).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newRequirements = v })
          TextInput({ placeholder: '联系方式', text: this.newContactInfo })
            .width('100%').height(44).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newContactInfo = v })

          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontSize(AppFontSize.BODY)
              .fontColor(AppColors.TEXT_SECONDARY).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .onClick(() => { this.showCreateDialog = false })
            Button('发布').layoutWeight(1).height(42).fontSize(AppFontSize.BODY)
              .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
              .onClick(() => { this.handleCreate() })
          }.width('100%')
        }
        .width('85%').padding(20).backgroundColor(Color.White).borderRadius(AppRadius.XL)
        .position({ x: '7.5%', y: '15%' })
      }
    }.width('100%').height('100%')
  }
}
