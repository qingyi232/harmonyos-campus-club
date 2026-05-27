import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { ClubInfo } from '../models/ClubModel';
import { AppTheme } from '../theme/AppTheme';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { CommonUtil } from '../utils/CommonUtil';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct MyClubPage {
  @State private clubs: ClubInfo[] = [];
  @State private isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    await this.loadClubs();
  }

  async loadClubs(): Promise<void> {
    this.isLoading = true;
    try {
      // 如果是社长，获取管理的社团；如果是学生，获取加入的社团
      if (userStore.isLeader) {
        const data = await MockDataService.getUserClubs(userStore.userId);
        this.clubs = data;
      } else {
        // 获取用户加入的社团
        const data = await MockDataService.getUserJoinedClubs(userStore.userId);
        this.clubs = data;
      }
    } catch (error) {
      console.error('Load clubs failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
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

        Text(userStore.isLeader ? '我的社团' : '加入的社团')
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
            Image(IconUtil.EMPTY)
              .width(80)
              .height(80)
              .fillColor(AppTheme.TEXT_TERTIARY)
              .margin({ bottom: 16 })

            Text(userStore.isLeader ? '您还没有创建社团' : '您还没有加入社团')
              .fontSize(16)
              .fontColor(AppTheme.TEXT_TERTIARY)

            if (userStore.isLeader) {
              Button('创建社团')
                .fontSize(14)
                .backgroundColor(AppTheme.PRIMARY_COLOR)
                .fontColor(AppTheme.TEXT_WHITE)
                .margin({ top: 16 })
                .onClick(() => {
                  RouterUtil.push(Constants.ROUTE_CLUB_APPLY);
                })
            }
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.clubs, (club: ClubInfo) => {
            ListItem() {
              this.ClubCard(club)
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
  ClubCard(club: ClubInfo) {
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

          Row() {
            Text(club.category)
              .fontSize(12)
              .fontColor(AppTheme.PRIMARY_COLOR)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor(AppTheme.BG_TERTIARY)
              .borderRadius(4)

            Text(`· ${club.memberCount}人`)
              .fontSize(12)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .margin({ left: 8 })
          }
          .margin({ top: 6 })

          Text(CommonUtil.getStatusText(club.status, 'club'))
            .fontSize(12)
            .fontColor(CommonUtil.getStatusColor(club.status))
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(4)
            .margin({ top: 6 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 12 })

        Image(IconUtil.ARROW_RIGHT)
          .width(20)
          .height(20)
          .fillColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')

      // 快捷操作
      if (userStore.isLeader && club.leaderId === userStore.userId) {
        Row() {
          Button('成员管理')
            .fontSize(13)
            .backgroundColor(AppTheme.BG_TERTIARY)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .height(36)
            .layoutWeight(1)
            .margin({ right: 8 })
            .onClick(() => {
              RouterUtil.push(Constants.ROUTE_MEMBER_MANAGE, new ClubIdRouteParam(club.id));
            })

          Button('财务管理')
            .fontSize(13)
            .backgroundColor(AppTheme.BG_TERTIARY)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .height(36)
            .layoutWeight(1)
            .onClick(() => {
              RouterUtil.push(Constants.ROUTE_FINANCE_MANAGE, new ClubIdRouteParam(club.id));
            })
        }
        .width('100%')
        .margin({ top: 12 })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_CLUB_DETAIL, new ClubIdRouteParam(club.id));
    })
  }
}
