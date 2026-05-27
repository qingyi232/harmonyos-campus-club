import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { FinanceStatistics, FinanceRecord } from '../models/FinanceModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct FinanceManagePage {
  @State private clubId: string = '';
  @State private statistics: FinanceStatistics | null = null;
  @State private isLoading: boolean = true;
  @State private currentTab: number = 0;
  @State private isAdminView: boolean = false;
  @State private allClubFinances: FinanceStatistics[] = [];

  async aboutToAppear(): Promise<void> {
    const params = RouterUtil.getParams() as ClubIdRouteParam;
    this.clubId = params?.clubId || userStore.clubId;

    if (userStore.isAdmin && !this.clubId) {
      this.isAdminView = true;
      await this.loadAdminData();
    } else if (this.clubId) {
      await this.loadData();
    }
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      const data = await MockDataService.getFinanceStatistics(this.clubId);
      this.statistics = data;
    } catch (error) {
      console.error('Load finance failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  async loadAdminData(): Promise<void> {
    this.isLoading = true;
    try {
      this.allClubFinances = await MockDataService.getAllFinanceOverview();
    } catch (error) {
      console.error('Load admin finance failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  @State private showAddDialog: boolean = false;
  @State private newType: string = 'expense';
  @State private newCategory: string = '';
  @State private newAmount: string = '';
  @State private newDescription: string = '';
  @State private newProofImage: string = '';
  @State private showProofPreview: boolean = false;
  @State private previewProofUrl: string = '';
  private proofSampleImages: string[] = [
    'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1572883454114-1cf0031ede2a?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&h=300&fit=crop'
  ];

  async addFinanceRecord(): Promise<void> {
    this.showAddDialog = true;
  }

  async handleSubmitRecord(): Promise<void> {
    if (!this.newAmount || !this.newDescription || !this.newCategory) {
      return;
    }
    const amount: number = parseFloat(this.newAmount);
    if (isNaN(amount) || amount <= 0) {
      return;
    }
    await MockDataService.addFinanceRecord(
      this.clubId,
      this.newType,
      this.newCategory,
      amount,
      this.newDescription,
      this.newProofImage
    );
    this.showAddDialog = false;
    this.newType = 'expense';
    this.newCategory = '';
    this.newAmount = '';
    this.newDescription = '';
    this.newProofImage = '';
    await this.loadData();
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image(IconUtil.ARROW_LEFT)
            .width(24)
            .height(24)
            .fillColor(AppTheme.TEXT_PRIMARY)
            .onClick(() => { RouterUtil.back(); })

        Text(this.isAdminView ? '经费监管' : '财务管理')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

          if (!this.isAdminView) {
            Image(IconUtil.ADD)
              .width(24)
              .height(24)
              .fillColor(AppTheme.PRIMARY_COLOR)
              .onClick(() => { this.addFinanceRecord(); })
          } else {
            Row().width(24).height(24)
          }
        }
        .width('100%')
        .height(90)
        .padding({ top: 36, left: 16, right: 16 })

        if (this.isLoading) {
          Row() {
            LoadingProgress().width(40).height(40).color(AppTheme.PRIMARY_COLOR)
          }
          .width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
        } else if (this.isAdminView) {
          Scroll() {
            Column({ space: 12 }) {
              Text('所有社团经费使用情况').fontSize(16).fontWeight(FontWeight.Bold)
                .fontColor(AppTheme.TEXT_PRIMARY).alignSelf(ItemAlign.Start).margin({ left: 16, top: 12 })
              ForEach(this.allClubFinances, (stat: FinanceStatistics) => {
                Column({ space: 8 }) {
                  Text(stat.clubName).fontSize(15).fontWeight(FontWeight.Medium).fontColor(AppTheme.TEXT_PRIMARY)
                  Row() {
                    Column({ space: 2 }) {
                      Text('总收入').fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
                      Text('¥' + stat.totalIncome.toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.SUCCESS)
                    }.layoutWeight(1)
                    Column({ space: 2 }) {
                      Text('总支出').fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
                      Text('¥' + stat.totalExpense.toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.ERROR)
                    }.layoutWeight(1)
                    Column({ space: 2 }) {
                      Text('余额').fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
                      Text('¥' + stat.balance.toString()).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppTheme.PRIMARY_COLOR)
                    }.layoutWeight(1)
                  }.width('100%')
                }
                .width('92%').padding(16).backgroundColor(AppTheme.BG_PRIMARY).borderRadius(12)
              })
            }.width('100%').padding({ bottom: 20 })
          }.layoutWeight(1).scrollBar(BarState.Off)
        } else if (this.statistics) {
          this.FinanceOverview()

          Tabs({ barPosition: BarPosition.Start }) {
            TabContent() {
              this.RecordList(this.statistics.incomeRecords, 'income')
            }.tabBar('收入')
            TabContent() {
              this.RecordList(this.statistics.expenseRecords, 'expense')
            }.tabBar('支出')
          }
          .width('100%').layoutWeight(1).barHeight(44).animationDuration(200)
        }
      }
      .width('100%').height('100%').backgroundColor(AppTheme.BG_SECONDARY)

      if (this.showAddDialog) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showAddDialog = false; })
          .position({ x: 0, y: 0 })

        Column({ space: 14 }) {
          Text('添加财务记录').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)

          Row({ space: 12 }) {
            Text('收入').fontSize(14)
              .fontColor(this.newType === 'income' ? '#FFFFFF' : AppTheme.SUCCESS)
              .backgroundColor(this.newType === 'income' ? AppTheme.SUCCESS : '#FFFFFF')
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(20).border({ width: 1, color: AppTheme.SUCCESS })
              .onClick(() => { this.newType = 'income'; })
            Text('支出').fontSize(14)
              .fontColor(this.newType === 'expense' ? '#FFFFFF' : AppTheme.ERROR)
              .backgroundColor(this.newType === 'expense' ? AppTheme.ERROR : '#FFFFFF')
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(20).border({ width: 1, color: AppTheme.ERROR })
              .onClick(() => { this.newType = 'expense'; })
          }

          TextInput({ placeholder: '金额', text: this.newAmount })
            .width('100%').height(46).type(InputType.Number)
            .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.newAmount = v; })
          TextInput({ placeholder: '分类（如：物资采购、活动经费）', text: this.newCategory })
            .width('100%').height(46)
            .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.newCategory = v; })
          TextInput({ placeholder: '用途说明', text: this.newDescription })
            .width('100%').height(46)
            .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.newDescription = v; })

          Column({ space: 6 }) {
            Text('凭证照片').fontSize(13).fontColor(AppTheme.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
            if (this.newProofImage) {
              Stack({ alignContent: Alignment.TopEnd }) {
                Image(this.newProofImage).width('100%').height(120).borderRadius(10).objectFit(ImageFit.Cover)
                Text('✕').fontSize(16).fontColor('#FFFFFF')
                  .backgroundColor('#CC000000').borderRadius(12)
                  .width(24).height(24).textAlign(TextAlign.Center)
                  .margin({ top: 4, right: 4 })
                  .onClick(() => { this.newProofImage = ''; })
              }.width('100%')
            } else {
              Row({ space: 8 }) {
                Text('📷').fontSize(22)
                Text('点击上传凭证照片').fontSize(13).fontColor(AppTheme.TEXT_TERTIARY)
              }
              .width('100%').height(80).justifyContent(FlexAlign.Center)
              .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .border({ width: 1, color: AppTheme.TEXT_TERTIARY, style: BorderStyle.Dashed })
              .onClick(() => {
                const idx: number = Math.floor(Math.random() * this.proofSampleImages.length);
                this.newProofImage = this.proofSampleImages[idx];
              })
            }
          }.width('100%')

          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(44).fontSize(14)
              .fontColor(AppTheme.TEXT_SECONDARY).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .onClick(() => { this.showAddDialog = false; })
            Button('确认添加').layoutWeight(1).height(44).fontSize(14)
              .fontColor('#FFFFFF').backgroundColor(AppTheme.PRIMARY_COLOR).borderRadius(10)
              .onClick(() => { this.handleSubmitRecord(); })
          }.width('100%')
        }
        .width('85%').padding(24).backgroundColor('#FFFFFF').borderRadius(16)
        .position({ x: '7.5%', y: '18%' })
      }

      if (this.showProofPreview) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showProofPreview = false; })
          .position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Row() {
            Text('凭证照片').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
            Blank()
            Text('✕').fontSize(20).fontColor(AppTheme.TEXT_SECONDARY)
              .onClick(() => { this.showProofPreview = false; })
          }.width('100%')
          Image(this.previewProofUrl).width('100%').height(250).borderRadius(10).objectFit(ImageFit.Contain)
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '25%' })
      }
    }
    .width('100%').height('100%')
  }

  @Builder
  FinanceOverview() {
    Column() {
      // 余额卡片
      Column() {
        Text('当前余额')
          .fontSize(14)
          .fontColor(AppTheme.TEXT_WHITE)
          .opacity(0.8)

        Text(CommonUtil.formatAmount(this.statistics?.balance || 0))
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppTheme.TEXT_WHITE)
          .margin({ top: 8 })

        Row() {
          Column() {
            Text('本月收入')
              .fontSize(12)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.8)

            Text(CommonUtil.formatAmount(this.statistics?.monthIncome || 0))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppTheme.TEXT_WHITE)
              .margin({ top: 4 })
          }
          .layoutWeight(1)

          Column() {
            Text('本月支出')
              .fontSize(12)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.8)

            Text(CommonUtil.formatAmount(this.statistics?.monthExpense || 0))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppTheme.TEXT_WHITE)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ top: 20 })
      }
      .width('100%')
      .padding(20)
      .backgroundColor(AppTheme.PRIMARY_COLOR)
      .borderRadius(16)
      .margin({ left: 16, right: 16, top: 8, bottom: 16 })

      // 统计数据
      Row() {
        this.StatCard('总收入', this.statistics?.totalIncome || 0, 'income')
        this.StatCard('总支出', this.statistics?.totalExpense || 0, 'expense')
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
  }

  @Builder
  StatCard(title: string, amount: number, type: string) {
    Column() {
      Text(title)
        .fontSize(13)
        .fontColor(AppTheme.TEXT_TERTIARY)

      Text(CommonUtil.formatAmount(amount))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(type === 'income' ? AppTheme.SUCCESS : AppTheme.ERROR)
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .height(80)
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  RecordList(records: FinanceRecord[], type: string) {
    if (records.length === 0) {
      Row() {
        Column() {
          Image(IconUtil.EMPTY)
            .width(60)
            .height(60)
            .fillColor(AppTheme.TEXT_TERTIARY)
            .margin({ bottom: 12 })

          Text('暂无记录')
            .fontSize(14)
            .fontColor(AppTheme.TEXT_TERTIARY)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 8 }) {
        ForEach(records, (record: FinanceRecord) => {
          ListItem() {
            this.RecordItem(record)
          }
        }, (record: FinanceRecord) => record.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })
    }
  }

  @Builder
  RecordItem(record: FinanceRecord) {
    Row() {
      Column() {
        Row({ space: 6 }) {
          Text(record.category)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
          if (record.proofImage) {
            Text('🧾').fontSize(14)
              .onClick(() => {
                this.previewProofUrl = record.proofImage;
                this.showProofPreview = true;
              })
          }
        }

        Text(record.description)
          .fontSize(13)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })

        Text(CommonUtil.formatTimestamp(record.createTime, 'MM-DD HH:mm'))
          .fontSize(12)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text(CommonUtil.formatAmount(record.amount))
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(record.type === 'income' ? AppTheme.SUCCESS : AppTheme.ERROR)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
  }
}
