// 数据统计页面 - 管理员端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { StatisticsData, CategoryStat, MonthlyStat } from '../../model/DataModels'

@Entry
@Component
struct StatisticsPage {
  @State stats: StatisticsData | null = null
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    this.stats = await this.dataService.getStatistics()
    this.isLoading = false
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('数据统计').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      if (this.isLoading) {
        Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
          .layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.stats) {
        Scroll() {
          Column({ space: 12 }) {
            // 核心数据
            Column({ space: 12 }) {
              Text('📊 核心数据概览')
                .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

              Grid() {
                GridItem() { this.DataCard('🏛', '社团总数', `${this.stats.totalClubs}`, AppColors.TAG_GREEN) }
                GridItem() { this.DataCard('👥', '学生总数', `${this.stats.totalStudents}`, AppColors.TAG_BLUE) }
                GridItem() { this.DataCard('📅', '活动总数', `${this.stats.totalActivities}`, AppColors.TAG_ORANGE) }
                GridItem() { this.DataCard('💰', '经费余额', `¥${this.stats.totalFinance}`, AppColors.TAG_PURPLE) }
              }
              .columnsTemplate('1fr 1fr')
              .rowsGap(10).columnsGap(10)
              .width('100%').height(180)
            }
            .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ top: 12 })

            // 本月数据
            Column({ space: 12 }) {
              Text('📈 本月新增')
                .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

              Row() {
                this.MonthStat('新增社团', `${this.stats.monthlyNewClubs}`, AppColors.PRIMARY)
                Divider().vertical(true).height(40).color(AppColors.DIVIDER)
                this.MonthStat('新增成员', `${this.stats.monthlyNewMembers}`, AppColors.ACCENT)
                Divider().vertical(true).height(40).color(AppColors.DIVIDER)
                this.MonthStat('举办活动', `${this.stats.monthlyActivities}`, AppColors.WARNING)
              }.width('100%').justifyContent(FlexAlign.SpaceAround)
            }
            .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)

            // 社团分类分布
            Column({ space: 12 }) {
              Text('🏛 社团分类分布')
                .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

              ForEach(this.stats.clubCategoryStats, (stat: CategoryStat) => {
                Column({ space: 6 }) {
                  Row() {
                    Text(stat.category).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                    Blank()
                    Text(`${stat.count}个 (${stat.percentage}%)`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_HINT)
                  }.width('100%')
                  Progress({ value: stat.percentage, total: 100 })
                    .width('100%').height(10).color(AppColors.PRIMARY)
                    .backgroundColor(AppColors.PRIMARY_LIGHT).borderRadius(5)
                }.width('100%')
              })
            }
            .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG)

            // 活动月度趋势
            Column({ space: 12 }) {
              Text('📅 活动月度趋势')
                .fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
                .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

              Row() {
                ForEach(this.stats.activityMonthlyStats, (stat: MonthlyStat) => {
                  Column({ space: 4 }) {
                    Text(`${stat.count}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.PRIMARY)
                    Column()
                      .width(30)
                      .height(stat.count * 15)
                      .backgroundColor(AppColors.PRIMARY)
                      .borderRadius({ topLeft: 4, topRight: 4 })
                    Text(stat.month).fontSize(10).fontColor(AppColors.TEXT_HINT)
                  }.alignItems(HorizontalAlign.Center)
                })
              }
              .width('100%').justifyContent(FlexAlign.SpaceAround).alignItems(VerticalAlign.Bottom).height(150)
            }
            .width('92%').padding(16).backgroundColor(Color.White).borderRadius(AppRadius.LG).margin({ bottom: 20 })
          }
        }.layoutWeight(1).scrollBar(BarState.Off)
      }
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }

  @Builder DataCard(icon: string, label: string, value: string, bgColor: string) {
    Column({ space: 6 }) {
      Text(icon).fontSize(28)
      Text(value).fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      Text(label).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY)
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(bgColor).borderRadius(AppRadius.LG)
  }

  @Builder MonthStat(label: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
    }
  }
}
