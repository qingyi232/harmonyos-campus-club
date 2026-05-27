// 创建活动页面
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { ClubInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct CreateActivityPage {
  @State title: string = ''
  @State description: string = ''
  @State location: string = ''
  @State maxParticipants: string = '50'
  @State selectedClubIndex: number = 0
  @State myClubs: ClubInfo[] = []
  @State isLoading: boolean = false
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.loadClubs()
  }

  async loadClubs() {
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.myClubs = await this.dataService.getClubsByLeader(user.id)
    }
  }

  async handleCreate() {
    if (!this.title || !this.description || !this.location) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 })
      return
    }
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    const club = this.myClubs[this.selectedClubIndex]
    if (user && club) {
      const success = await this.dataService.createActivity({
        clubId: club.id, clubName: club.name,
        title: this.title, description: this.description,
        location: this.location, maxParticipants: parseInt(this.maxParticipants) || 50,
        startTime: Date.now() + 7 * 86400000, endTime: Date.now() + 7 * 86400000 + 10800000,
        creatorId: user.id, creatorName: user.realName,
        tags: []
      })
      if (success) {
        promptAction.showToast({ message: '活动创建成功，等待审核', duration: 1500 })
        RouterUtil.back()
      }
    }
    this.isLoading = false
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('创建活动').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }
      .width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Scroll() {
        Column({ space: 14 }) {
          // 选择社团
          Column({ space: 6 }) {
            Text('所属社团').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            Select(this.myClubs.map((c, i) => ({ value: c.name } as SelectOption)))
              .selected(this.selectedClubIndex)
              .value(this.myClubs.length > 0 ? this.myClubs[this.selectedClubIndex].name : '请选择')
              .font({ size: AppFontSize.BODY })
              .fontColor(AppColors.TEXT_PRIMARY)
              .backgroundColor(AppColors.BG_INPUT)
              .width('100%')
              .borderRadius(AppRadius.MD)
              .onSelect((index: number) => { this.selectedClubIndex = index })
          }.width('100%')

          this.FormField('活动标题', '请输入活动标题', this.title, (v: string) => { this.title = v })
          this.FormField('活动地点', '请输入活动地点', this.location, (v: string) => { this.location = v })
          this.FormField('人数上限', '请输入最大参与人数', this.maxParticipants, (v: string) => { this.maxParticipants = v })

          Column({ space: 6 }) {
            Text('活动描述').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            TextArea({ placeholder: '请详细描述活动内容...', text: this.description })
              .width('100%').height(120).fontSize(AppFontSize.BODY)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .border({ width: 1, color: AppColors.BORDER_LIGHT })
              .padding(12)
              .onChange((v: string) => { this.description = v })
          }.width('100%')

          Button(this.isLoading ? '提交中...' : '提交审核')
            .width('100%').height(50).fontSize(17).fontWeight(FontWeight.Medium)
            .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.LG)
            .margin({ top: 10 }).enabled(!this.isLoading)
            .onClick(() => { this.handleCreate() })
        }
        .padding({ left: 24, right: 24, top: 16, bottom: 30 })
      }
      .layoutWeight(1).scrollBar(BarState.Off)
    }
    .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }

  @Builder FormField(label: string, placeholder: string, value: string, onChange: (val: string) => void) {
    Column({ space: 6 }) {
      Text(label).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
      TextInput({ placeholder: placeholder, text: value })
        .width('100%').height(46).fontSize(AppFontSize.BODY)
        .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
        .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding({ left: 14, right: 14 })
        .onChange(onChange)
    }.width('100%')
  }
}
