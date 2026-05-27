// 申请创建社团页面 - 学生端
import { AppColors, AppFontSize, AppRadius, ClubCategories } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ApplyClubPage {
  @State clubName: string = ''
  @State description: string = ''
  @State category: string = '学术科技'
  @State reason: string = ''
  @State isLoading: boolean = false
  @State selectedCategoryIndex: number = 0
  private dataService: DataService = DataService.getInstance()

  async handleSubmit() {
    if (!this.clubName || !this.description || !this.reason) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 })
      return
    }
    this.isLoading = true
    const user = this.dataService.getCurrentUser()
    if (user) {
      const success = await this.dataService.submitClubApplication({
        userId: user.id,
        userName: user.realName,
        clubName: this.clubName,
        description: this.description,
        category: this.category,
        reason: this.reason
      })
      if (success) {
        promptAction.showToast({ message: '申请已提交，等待管理员审核', duration: 2000 })
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
        Text('申请创建社团').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Scroll() {
        Column({ space: 14 }) {
          // 提示
          Row({ space: 8 }) {
            Text('💡').fontSize(18)
            Text('填写社团信息后提交，管理员审核通过后即可成立社团。')
              .fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).layoutWeight(1)
          }
          .width('100%').padding(12).backgroundColor(AppColors.TAG_GREEN).borderRadius(AppRadius.MD)

          this.FormField('社团名称 *', '请输入社团名称', this.clubName, (v: string) => { this.clubName = v })

          Column({ space: 6 }) {
            Text('社团分类 *').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            Select(ClubCategories.ALL.map(c => ({ value: c } as SelectOption)))
              .selected(this.selectedCategoryIndex)
              .value(ClubCategories.ALL[this.selectedCategoryIndex])
              .font({ size: AppFontSize.BODY })
              .fontColor(AppColors.TEXT_PRIMARY)
              .backgroundColor(AppColors.BG_INPUT)
              .width('100%')
              .borderRadius(AppRadius.MD)
              .onSelect((index: number) => {
                this.selectedCategoryIndex = index
                this.category = ClubCategories.ALL[index]
              })
          }.width('100%')

          Column({ space: 6 }) {
            Text('社团简介 *').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            TextArea({ placeholder: '请详细描述社团的宗旨、活动方向等...', text: this.description })
              .width('100%').height(100).fontSize(AppFontSize.BODY)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding(12)
              .onChange((v: string) => { this.description = v })
          }.width('100%')

          Column({ space: 6 }) {
            Text('申请理由 *').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            TextArea({ placeholder: '请说明创建该社团的理由和必要性...', text: this.reason })
              .width('100%').height(100).fontSize(AppFontSize.BODY)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding(12)
              .onChange((v: string) => { this.reason = v })
          }.width('100%')

          Button(this.isLoading ? '提交中...' : '提交申请')
            .width('100%').height(50).fontSize(17).fontWeight(FontWeight.Medium)
            .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.LG)
            .margin({ top: 10 }).enabled(!this.isLoading)
            .onClick(() => { this.handleSubmit() })
        }
        .padding({ left: 24, right: 24, top: 16, bottom: 30 })
      }.layoutWeight(1).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
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
