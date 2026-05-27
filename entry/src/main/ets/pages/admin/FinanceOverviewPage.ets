// 财务监管页面 - 管理员端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { FinanceRecord, ClubInfo } from '../../model/DataModels'

@Entry
@Component
struct FinanceOverviewPage {
  @State allRecords: FinanceRecord[] = []
  @State clubs: ClubInfo[] = []
  @State totalIncome: number = 0
  @State totalExpense: number = 0
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    this.allRecords = await this.dataService.getAllFinanceRecords()
    this.clubs = await this.dataService.getAllClubs()
    this.totalIncome = this.allRecords.filter(r => r.type === 'income').reduce((s, r) => s + r.amount, 0)
    this.totalExpense = this.allRecords.filter(r => r.type === 'expense').reduce((s, r) => s + r.amount, 0)
    this.isLoading = false
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('财务监管').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      Scroll() {
        Column({ space: 12 }) {
          // 总览
          Row() {
            this.StatItem('总收入', `¥${this.totalIncome}`, AppColors.PRIMARY)
            Divider().vertical(true).height(40).color(AppColors.DIVIDER)
            this.StatItem('总支出', `¥${this.totalExpense}`, AppColors.DANGER)
            Divider().vertical(true).height(40).color(AppColors.DIVIDER)
            this.StatItem('总余额', `¥${this.totalIncome - this.totalExpense}`, AppColors.ACCENT)
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)
          .justifyContent(FlexAlign.SpaceAround).margin({ top: 12 })

          // 各社团财务
          Column({ space: 10 }) {
            Text('各社团经费情况')
              .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

            ForEach(this.clubs.filter(c => c.status === 'approved'), (club: ClubInfo) => {
              Row({ space: 12 }) {
                Image(club.logo).width(44).height(44).borderRadius(AppRadius.SM).objectFit(ImageFit.Cover)
                Column({ space: 3 }) {
                  Text(club.name).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                  Text(`余额: ¥${this.dataService.getClubBalance(club.id)}`)
                    .fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Column({ space: 2 }) {
                  Text(`收: ¥${this.allRecords.filter(r => r.clubId === club.id && r.type === 'income').reduce((s, r) => s + r.amount, 0)}`)
                    .fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                  Text(`支: ¥${this.allRecords.filter(r => r.clubId === club.id && r.type === 'expense').reduce((s, r) => s + r.amount, 0)}`)
                    .fontSize(AppFontSize.SMALL).fontColor(AppColors.DANGER)
                }.alignItems(HorizontalAlign.End)
              }
              .width('100%').padding(12).backgroundColor(AppColors.BG_SECTION).borderRadius(AppRadius.SM)
            })
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)

          // 最近记录
          Column({ space: 10 }) {
            Text('最近财务记录')
              .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

            ForEach(this.allRecords.slice(0, 10), (record: FinanceRecord) => {
              Row({ space: 10 }) {
                Text(record.type === 'income' ? '📈' : '📉').fontSize(20)
                Column({ space: 2 }) {
                  Text(record.description).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                  Text(`${record.clubName} · ${record.operatorName} · ${DateUtil.formatDate(record.createTime)}`)
                    .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount}`)
                  .fontSize(AppFontSize.BODY).fontWeight(FontWeight.Bold)
                  .fontColor(record.type === 'income' ? AppColors.PRIMARY : AppColors.DANGER)
              }
              .width('100%').padding(10).backgroundColor(AppColors.BG_SECTION).borderRadius(AppRadius.SM)
            })
          }
          .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ bottom: 20 })
        }
      }.layoutWeight(1).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }

  @Builder StatItem(label: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }
}
