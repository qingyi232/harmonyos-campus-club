// 财务管理页面 - 负责人端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { FinanceRecord, ClubInfo } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct FinancePage {
  @State records: FinanceRecord[] = []
  @State myClubs: ClubInfo[] = []
  @State selectedClubIndex: number = 0
  @State balance: number = 0
  @State totalIncome: number = 0
  @State totalExpense: number = 0
  @State isLoading: boolean = true
  @State showAddDialog: boolean = false
  @State newType: string = 'expense'
  @State newAmount: string = ''
  @State newDescription: string = ''
  @State newCategory: string = ''
  @State newReceipt: string = ''
  @State showReceiptPreview: boolean = false
  @State previewReceiptUrl: string = ''
  private dataService: DataService = DataService.getInstance()
  private receiptImages: string[] = [
    'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1572883454114-1cf0031ede2a?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&h=300&fit=crop'
  ]

  aboutToAppear() {
    this.loadClubs()
  }

  async loadClubs() {
    const user = this.dataService.getCurrentUser()
    if (user) {
      this.myClubs = await this.dataService.getClubsByLeader(user.id)
      if (this.myClubs.length > 0) {
        const params = RouterUtil.getParams()
        if (params && params.clubId) {
          const idx = this.myClubs.findIndex(c => c.id === params.clubId)
          if (idx >= 0) this.selectedClubIndex = idx
        }
        this.loadRecords()
      }
    }
  }

  async loadRecords() {
    this.isLoading = true
    const club = this.myClubs[this.selectedClubIndex]
    if (club) {
      this.records = await this.dataService.getFinanceRecords(club.id)
      this.balance = this.dataService.getClubBalance(club.id)
      this.totalIncome = this.records.filter(r => r.type === 'income').reduce((s, r) => s + r.amount, 0)
      this.totalExpense = this.records.filter(r => r.type === 'expense').reduce((s, r) => s + r.amount, 0)
    }
    this.isLoading = false
  }

  async handleAddRecord() {
    if (!this.newAmount || !this.newDescription) {
      promptAction.showToast({ message: '请填写完整信息', duration: 2000 })
      return
    }
    const user = this.dataService.getCurrentUser()
    const club = this.myClubs[this.selectedClubIndex]
    if (user && club) {
      await this.dataService.addFinanceRecord({
        clubId: club.id, clubName: club.name,
        type: this.newType, amount: parseFloat(this.newAmount),
        description: this.newDescription, category: this.newCategory || '其他',
        receipt: this.newReceipt,
        operatorId: user.id, operatorName: user.realName
      })
      promptAction.showToast({ message: '记录添加成功', duration: 1500 })
      this.showAddDialog = false
      this.newAmount = ''
      this.newDescription = ''
      this.newCategory = ''
      this.newReceipt = ''
      this.loadRecords()
    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
            .onClick(() => { RouterUtil.back() }).padding(10)
          Text('财务管理').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
          Text('+').fontSize(28).fontColor(AppColors.PRIMARY)
            .onClick(() => { this.showAddDialog = true }).padding(10)
        }
        .width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

        // 社团选择
        if (this.myClubs.length > 1) {
          Scroll() {
            Row({ space: 8 }) {
              ForEach(this.myClubs, (club: ClubInfo, index: number) => {
                Text(club.name)
                  .fontSize(AppFontSize.CAPTION)
                  .fontColor(this.selectedClubIndex === index ? Color.White : AppColors.TEXT_PRIMARY)
                  .backgroundColor(this.selectedClubIndex === index ? AppColors.PRIMARY : Color.White)
                  .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                  .borderRadius(AppRadius.ROUND)
                  .border({ width: 1, color: this.selectedClubIndex === index ? AppColors.PRIMARY : AppColors.BORDER })
                  .onClick(() => { this.selectedClubIndex = index; this.loadRecords() })
              })
            }.padding({ left: 16, right: 16 })
          }
          .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off).width('100%').height(50)
        }

        // 财务概览
        Row() {
          this.FinanceStat('收入', `¥${this.totalIncome}`, AppColors.PRIMARY)
          Divider().vertical(true).height(40).color(AppColors.DIVIDER)
          this.FinanceStat('支出', `¥${this.totalExpense}`, AppColors.DANGER)
          Divider().vertical(true).height(40).color(AppColors.DIVIDER)
          this.FinanceStat('余额', `¥${this.balance}`, AppColors.ACCENT)
        }
        .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)
        .justifyContent(FlexAlign.SpaceAround).margin({ top: 12 })

        // 记录列表
        if (this.isLoading) {
          Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
            .layoutWeight(1).justifyContent(FlexAlign.Center)
        } else {
          List({ space: 8 }) {
            ForEach(this.records, (record: FinanceRecord) => {
              ListItem() {
                Row({ space: 12 }) {
                  Text(record.type === 'income' ? '📈' : '📉')
                    .fontSize(28)
                    .width(44).height(44)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(record.type === 'income' ? AppColors.TAG_GREEN : AppColors.TAG_RED)
                    .borderRadius(22)

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
                      Text(`${record.operatorName}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
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
          }
          .layoutWeight(1).padding({ left: 16, right: 16, top: 12 }).scrollBar(BarState.Off)
        }
      }
      .width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)

      // 添加记录弹窗
      if (this.showAddDialog) {
        Column() {
          Column() {
            // 遮罩
          }
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showAddDialog = false })
        }
        .width('100%').height('100%').position({ x: 0, y: 0 })

        Column({ space: 14 }) {
          Text('添加财务记录').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)

          Row({ space: 12 }) {
            Text('收入').fontSize(AppFontSize.BODY)
              .fontColor(this.newType === 'income' ? Color.White : AppColors.PRIMARY)
              .backgroundColor(this.newType === 'income' ? AppColors.PRIMARY : Color.White)
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(AppRadius.ROUND).border({ width: 1, color: AppColors.PRIMARY })
              .onClick(() => { this.newType = 'income' })
            Text('支出').fontSize(AppFontSize.BODY)
              .fontColor(this.newType === 'expense' ? Color.White : AppColors.DANGER)
              .backgroundColor(this.newType === 'expense' ? AppColors.DANGER : Color.White)
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(AppRadius.ROUND).border({ width: 1, color: AppColors.DANGER })
              .onClick(() => { this.newType = 'expense' })
          }

          TextInput({ placeholder: '金额', text: this.newAmount })
            .width('100%').height(46).type(InputType.Number)
            .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newAmount = v })
          TextInput({ placeholder: '用途说明', text: this.newDescription })
            .width('100%').height(46)
            .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newDescription = v })
          TextInput({ placeholder: '分类（如：活动支出、物资采购）', text: this.newCategory })
            .width('100%').height(46)
            .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.newCategory = v })

          Column({ space: 6 }) {
            Text('凭证照片').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            if (this.newReceipt) {
              Stack({ alignContent: Alignment.TopEnd }) {
                Image(this.newReceipt).width('100%').height(120).borderRadius(AppRadius.MD).objectFit(ImageFit.Cover)
                Text('✕').fontSize(16).fontColor(Color.White)
                  .backgroundColor('#CC000000').borderRadius(12)
                  .width(24).height(24).textAlign(TextAlign.Center)
                  .margin({ top: 4, right: 4 })
                  .onClick(() => { this.newReceipt = '' })
              }.width('100%')
            } else {
              Row({ space: 8 }) {
                Text('📷').fontSize(22)
                Text('点击上传凭证照片').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_HINT)
              }
              .width('100%').height(80).justifyContent(FlexAlign.Center)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .border({ width: 1, color: AppColors.BORDER, style: BorderStyle.Dashed })
              .onClick(() => {
                const idx = Math.floor(Math.random() * this.receiptImages.length)
                this.newReceipt = this.receiptImages[idx]
                promptAction.showToast({ message: '凭证上传成功', duration: 1000 })
              })
            }
          }.width('100%')

          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(44).fontSize(AppFontSize.BODY)
              .fontColor(AppColors.TEXT_SECONDARY).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .onClick(() => { this.showAddDialog = false })
            Button('确认添加').layoutWeight(1).height(44).fontSize(AppFontSize.BODY)
              .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
              .onClick(() => { this.handleAddRecord() })
          }.width('100%')
        }
        .width('85%')
        .padding(24)
        .backgroundColor(Color.White)
        .borderRadius(AppRadius.XL)
        .position({ x: '7.5%', y: '20%' })
      }

      // 凭证预览弹窗
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
    }
    .width('100%').height('100%')
  }

  @Builder FinanceStat(label: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }
}
