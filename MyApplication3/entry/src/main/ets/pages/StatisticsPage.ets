import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { SystemStatistics, ClubActivityStats, CategoryStat } from '../models/StatisticsModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { LabelValueItem } from '../models/ViewModel';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct StatisticsPage {
  @State private statistics: SystemStatistics | null = null;
  @State private clubRanking: ClubActivityStats[] = [];
  @State private isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      const results = await Promise.all([
        MockDataService.getSystemStatistics(),
        MockDataService.getClubActivityRanking()
      ]);
      this.statistics = results[0];
      this.clubRanking = results[1];
    } catch (error) {
      console.error('Load statistics failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Image(IconUtil.ARROW_LEFT)
            .width(24)
            .height(24)
            .onClick(() => {
              RouterUtil.back();
            })

          Text('数据统计')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Row()
            .width(24)
            .height(24)
        }
        .width('100%')
        .height(90)
        .padding({ top: 36, left: 16, right: 16 })

        if (this.isLoading) {
          Row() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color(AppTheme.PRIMARY_COLOR)
          }
          .width('100%')
          .height(400)
          .justifyContent(FlexAlign.Center)
        } else if (this.statistics) {
          this.StatCard('用户统计', [
            new LabelValueItem('总用户数', `${this.statistics.totalUsers}人`),
            new LabelValueItem('活跃用户', `${this.statistics.activeUsers}人`),
            new LabelValueItem('今日新增', `${this.statistics.newUsersToday}人`)
          ]);

          this.StatCard('社团统计', [
            new LabelValueItem('总社团数', `${this.statistics.totalClubs}个`),
            new LabelValueItem('活跃社团', `${this.statistics.activeClubs}个`),
            new LabelValueItem('待审核', `${this.statistics.pendingClubs}个`)
          ]);

          this.StatCard('活动统计', [
            new LabelValueItem('总活动数', `${this.statistics.totalActivities}场`),
            new LabelValueItem('进行中', `${this.statistics.ongoingActivities}场`),
            new LabelValueItem('待审核', `${this.statistics.pendingActivities}场`)
          ]);

          this.FinanceCard();

          if (this.statistics.clubCategoryStats.length > 0) {
            this.CategoryChart();
          }

          if (this.clubRanking.length > 0) {
            this.RankingList();
          }
        }
      }
      .width('100%')
      .padding({ bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  StatCard(title: string, items: LabelValueItem[]) {
    Column() {
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Row() {
        ForEach(items, (item: LabelValueItem) => {
          Column() {
            Text(item.value)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppTheme.PRIMARY_COLOR)

            Text(item.label)
              .fontSize(13)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  FinanceCard() {
    Column() {
      Text('财务统计')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Row() {
        Column() {
          Text(CommonUtil.formatAmount(this.statistics?.monthIncome || 0))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.SUCCESS)

          Text('本月收入')
            .fontSize(13)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text(CommonUtil.formatAmount(this.statistics?.monthExpense || 0))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.ERROR)

          Text('本月支出')
            .fontSize(13)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text(CommonUtil.formatAmount(this.statistics?.totalFinance || 0))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.PRIMARY_COLOR)

          Text('总财务')
            .fontSize(13)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  CategoryChart() {
    Column() {
      Text('社团分类分布')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Column() {
        ForEach(this.statistics?.clubCategoryStats || [], (stat: CategoryStat) => {
          Column() {
            Row() {
              Text(stat.category)
                .fontSize(14)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .layoutWeight(1)

              Text(`${stat.count}个 (${stat.percentage}%)`)
                .fontSize(14)
                .fontColor(AppTheme.TEXT_TERTIARY)
            }
            .width('100%')
            .margin({ bottom: 6 })

            Row() {
              Row()
                .width(`${stat.percentage}%`)
                .height(8)
                .backgroundColor(AppTheme.PRIMARY_COLOR)
                .borderRadius(4)
            }
            .width('100%')
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(4)
          }
          .width('100%')
          .margin({ bottom: 12 })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  RankingList() {
    Column() {
      Text('社团活跃度排行')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Column() {
        ForEach(this.clubRanking.slice(0, 10), (club: ClubActivityStats, index: number) => {
          Row() {
            Text(`${index + 1}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(index < 3 ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)
              .width(30)

            Text(club.clubName)
              .fontSize(15)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(`${club.activityCount}场`)
              .fontSize(14)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .margin({ right: 8 })

            Text(`${club.avgRating.toFixed(1)}分`)
              .fontSize(14)
              .fontColor(AppTheme.ACCENT_COLOR)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(index < 3 ? AppTheme.BG_TERTIARY : Color.Transparent)
          .borderRadius(8)
          .margin({ bottom: 6 })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }
}