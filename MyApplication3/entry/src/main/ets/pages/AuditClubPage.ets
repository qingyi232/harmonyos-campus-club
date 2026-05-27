import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ClubQueryParams } from '../services/MockDataService';
import { ClubInfo } from '../models/ClubModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct AuditClubPage {
  @State private clubs: ClubInfo[] = [];
  @State private isLoading: boolean = true;
  @State private selectedTab: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadClubs();
  }

  async loadClubs(): Promise<void> {
    this.isLoading = true;
    try {
      const params = new ClubQueryParams();
      params.status = 'pending';
      const data = await MockDataService.getClubList(params);
      this.clubs = data;
    } catch (error) {
      console.error('Load clubs failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  async handleAudit(clubId: string, status: string): Promise<void> {
    try {
      await MockDataService.auditClub(clubId, status);
      // 重新加载数据
      await this.loadClubs();
    } catch (error) {
      console.error('Audit failed:', JSON.stringify(error));
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_PRIMARY)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('社团审核')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text(`${this.clubs.length}`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')
      .height(90)
      .padding({ left: 16, right: 16, top: 36 })

      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.clubs.length === 0) {
        Row() {
          Column() {
            Image(IconUtil.OK)
              .width(80)
              .height(80)
              .fillColor(AppTheme.PRIMARY_COLOR)
              .margin({ bottom: 16 })

            Text('暂无待审核的社团')
              .fontSize(16)
              .fontColor(AppTheme.TEXT_TERTIARY)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.clubs, (club: ClubInfo) => {
            ListItem() {
              this.AuditCard(club)
            }
          }, (club: ClubInfo) => club.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  AuditCard(club: ClubInfo) {
    Column() {
      Row() {
        Image(club.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=100&h=100&fit=crop')
          .width(60)
          .height(60)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)

        Column() {
          Text(club.name)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)

          Text(club.category)
            .fontSize(13)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })

          Text(`申请人：${club.leaderName}`)
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })
      }
      .width('100%')

      Text(club.description)
        .fontSize(14)
        .fontColor(AppTheme.TEXT_SECONDARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ top: 12 })

      Row() {
        Button('拒绝')
          .width('48%')
          .height(40)
          .fontSize(14)
          .backgroundColor(AppTheme.BG_TERTIARY)
          .fontColor(AppTheme.ERROR)
          .borderRadius(8)
          .onClick(() => {
            this.handleAudit(club.id, 'rejected');
          })

        Button('通过')
          .width('48%')
          .height(40)
          .fontSize(14)
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .fontColor(AppTheme.TEXT_WHITE)
          .borderRadius(8)
          .onClick(() => {
            this.handleAudit(club.id, 'approved');
          })
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
  }
}
