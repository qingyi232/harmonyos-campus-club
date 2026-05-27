// 社团经费查看页面 - 学生端（隐藏敏感信息）
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { FinanceRecord, ClubInfo, UserInfo } from '../../model/DataModels'

@Entry
@Component
struct ClubFinanceViewPage {
  @State records: FinanceRecord[] = []
  @State club: ClubInfo | null = null
  @State balance: number = 0
  @State totalIncome: number = 0
  @State totalExpense: number = 0
  @State isLoading: boolean = true
  @State showReceiptPreview: boolean = false
  @State previewReceiptUrl: string = ''
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    const params = RouterUtil.getParams()
    if (params && params.clubId) {
      this.loadData(params.clubId as string)
    }
  }

  async loadData(clubId: string) {
    this.isLoading = true
    this.club = await this.dataService.getClubById(clubId)
    this.records = await this.dataService.getFinanceRecords(clubId)
    this.balance = this.dataService.getClubBalance(clubId)
    this.totalIncome = this.records.filter(r => r.type === 'income').reduce((s, r) => s + r.amount, 0)
    this.totalExpense = this.records.filter(r => r.type === 'expense').reduce((s, r) => s + r.amount, 0)
    this.isLoading = false
  }

  build() {
    Stack() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text(`${this.club?.name || '社团'}经费明细`).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      // 概览
      Row() {
        this.StatItem('总收入', `¥${this.totalIncome}`, AppColors.PRIMARY)
        Divider().vertical(true).height(40).color(AppColors.DIVIDER)
        this.StatItem('总支出', `¥${this.totalExpense}`, AppColors.DANGER)
        Divider().vertical(true).height(40).color(AppColors.DIVIDER)
        this.StatItem('余额', `¥${this.balance}`, AppColors.ACCENT)
      }
      .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)
      .justifyContent(FlexAlign.SpaceAround).margin({ top: 12 })

      // 提示
      Row({ space: 6 }) {
        Text('ℹ').fontSize(14)
        Text('以下为本社团公开的经费收支明细，操作人信息已隐藏。')
          .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
      }.width('92%').margin({ top: 8 })

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.records, (record: FinanceRecord) => {
            ListItem() {
              Row({ space: 12 }) {
                Text(record.type === 'income' ? '📈' : '📉')
                  .fontSize(24).width(40).height(40).textAlign(TextAlign.Center)
                  .backgroundColor(record.type === 'income' ? AppColors.TAG_GREEN : AppColors.TAG_RED)
                  .borderRadius(20)
                Column({ space: 3 }) {
                  Row({ space: 6 }) {
                    Text(record.description).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                    if (record.receipt) {
                      Text('🧾').fontSize(14)
                        .onClick(() => {
                          this.previewReceiptUrl = record.receipt
                          this.showReceiptPreview = true
                        })
                    }
                  }
                  Row({ space: 8 }) {
                    Text(record.category).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                    Text(DateUtil.formatDate(record.createTime)).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                  }
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Text(`${record.type === 'income' ? '+' : '-'}¥${record.amount}`)
                  .fontSize(AppFontSize.BODY).fontWeight(FontWeight.Bold)
                  .fontColor(record.type === 'income' ? AppColors.PRIMARY : AppColors.DANGER)
              }
              .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.MD)
            }
          })
        }.layoutWeight(1).padding({ left: 16, right: 16, top: 12 }).scrollBar(BarState.Off)
      }
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)

    if (this.showReceiptPreview) {
      Column().width('100%').height('100%').backgroundColor('#80000000')
        .onClick(() => { this.showReceiptPreview = false }).position({ x: 0, y: 0 })
      Column({ space: 12 }) {
        Row() {
          Text('凭证照片').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          Blank()
          Text('✕').fontSize(20).fontColor(AppColors.TEXT_SECONDARY)
            .onClick(() => { this.showReceiptPreview = false })
        }.width('100%')
        Image(this.previewReceiptUrl).width('100%').height(250).borderRadius(AppRadius.MD).objectFit(ImageFit.Contain)
      }.width('85%').padding(20).backgroundColor(Color.White).borderRadius(AppRadius.XL)
        .position({ x: '7.5%', y: '25%' })
    }
    }.width('100%').height('100%')
  }

  @Builder StatItem(label: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }
}
