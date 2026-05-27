// 编辑社团信息页面 - 负责人端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { ClubInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct EditClubPage {
  @State club: ClubInfo | null = null
  @State description: string = ''
  @State slogan: string = ''
  @State contactInfo: string = ''
  @State tagsStr: string = ''
  @State isLoading: boolean = false
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    const params = RouterUtil.getParams()
    if (params && params.clubId) {
      this.loadClub(params.clubId as string)
    }
  }

  async loadClub(clubId: string) {
    this.club = await this.dataService.getClubById(clubId)
    if (this.club) {
      this.description = this.club.description
      this.slogan = this.club.slogan
      this.contactInfo = this.club.contactInfo
      this.tagsStr = this.club.tags.join('、')
    }
  }

  async handleSave() {
    if (!this.club) return
    this.isLoading = true
    const tags = this.tagsStr.split(/[、,，]/).filter(t => t.trim())
    const success = await this.dataService.updateClubInfo(this.club.id, {
      description: this.description,
      slogan: this.slogan,
      contactInfo: this.contactInfo,
      tags: tags
    })
    if (success) {
      promptAction.showToast({ message: '社团信息已更新', duration: 1500 })
      RouterUtil.back()
    }
    this.isLoading = false
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('编辑社团信息').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Scroll() {
        Column({ space: 14 }) {
          if (this.club) {
            // 社团名称（不可编辑）
            Column({ space: 6 }) {
              Text('社团名称').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
              Text(this.club.name)
                .width('100%').height(46).fontSize(AppFontSize.BODY)
                .fontColor(AppColors.TEXT_HINT)
                .padding({ left: 14 })
                .backgroundColor(AppColors.BG_SECTION)
                .borderRadius(AppRadius.MD)
            }.width('100%')

            Column({ space: 6 }) {
              Text('社团口号').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '请输入社团口号', text: this.slogan })
                .width('100%').height(46).fontSize(AppFontSize.BODY)
                .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
                .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding({ left: 14, right: 14 })
                .onChange((v: string) => { this.slogan = v })
            }.width('100%')

            Column({ space: 6 }) {
              Text('社团简介').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
              TextArea({ placeholder: '请输入社团简介...', text: this.description })
                .width('100%').height(120).fontSize(AppFontSize.BODY)
                .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
                .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding(12)
                .onChange((v: string) => { this.description = v })
            }.width('100%')

            Column({ space: 6 }) {
              Text('联系方式').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '如：QQ群号、微信群等', text: this.contactInfo })
                .width('100%').height(46).fontSize(AppFontSize.BODY)
                .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
                .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding({ left: 14, right: 14 })
                .onChange((v: string) => { this.contactInfo = v })
            }.width('100%')

            Column({ space: 6 }) {
              Text('标签（用顿号分隔）').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
              TextInput({ placeholder: '如：编程、算法、项目实战', text: this.tagsStr })
                .width('100%').height(46).fontSize(AppFontSize.BODY)
                .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
                .border({ width: 1, color: AppColors.BORDER_LIGHT }).padding({ left: 14, right: 14 })
                .onChange((v: string) => { this.tagsStr = v })
            }.width('100%')

            Button(this.isLoading ? '保存中...' : '保存修改')
              .width('100%').height(50).fontSize(17).fontWeight(FontWeight.Medium)
              .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.LG)
              .margin({ top: 10 }).enabled(!this.isLoading)
              .onClick(() => { this.handleSave() })
          }
        }
        .padding({ left: 24, right: 24, top: 16, bottom: 30 })
      }.layoutWeight(1).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
