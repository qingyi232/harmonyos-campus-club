import { userStore } from '../store/UserStore';
import { RouterUtil } from '../utils/RouterUtil';
import { Constants } from '../common/Constants';
import { AppTheme } from '../theme/AppTheme';
import { MockDataService, ClubQueryParams, ActivityQueryParams } from '../services/MockDataService';
import { ClubInfo } from '../models/ClubModel';
import { ActivityInfo } from '../models/ActivityModel';
import { CommonUtil } from '../utils/CommonUtil';
import { TabItem } from '../models/ViewModel';
import { ClubIdRouteParam, ActivityIdRouteParam } from '../models/RouteParams';
import { ImageUrls } from '../utils/ImageUrls';
import { UserParticipationStats } from '../models/StatisticsModel';

@Entry
@Component
struct HomePage {
  @State private currentTab: number = 0;
  @State private hotClubs: ClubInfo[] = [];
  @State private upcomingActivities: ActivityInfo[] = [];
  @State private tabClubs: ClubInfo[] = [];
  @State private tabActivities: ActivityInfo[] = [];
  @State private profileStats: UserParticipationStats | null = null;
  @State private isLoading: boolean = true;

  private tabs: TabItem[] = [
    new TabItem('首页', '', '', '🏠'),
    new TabItem('社团', '', '', '👥'),
    new TabItem('活动', '', '', '📅'),
    new TabItem('我的', '', '', '👤')
  ];

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      const clubParams: ClubQueryParams = new ClubQueryParams();
      clubParams.status = 'approved';
      const activityParams: ActivityQueryParams = new ActivityQueryParams();
      activityParams.status = 'approved';
      const results = await Promise.all([
        MockDataService.getClubList(clubParams),
        MockDataService.getActivityList(activityParams)
      ]);
      this.tabClubs = results[0];
      this.tabActivities = results[1];
      this.hotClubs = results[0].slice(0, 6);
      this.upcomingActivities = results[1].filter((activity: ActivityInfo) => activity.startTime > Date.now()).slice(0, 5);
      try {
        this.profileStats = await MockDataService.getUserParticipationStats(userStore.userId);
      } catch {
        this.profileStats = null;
      }
    } catch (error) {
      console.error('Load data failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        this.HomeTabContent();
      }
      .tabBar(this.TabBarItem(0))

      TabContent() {
        this.ClubTabContent();
      }
      .tabBar(this.TabBarItem(1))

      TabContent() {
        this.ActivityTabContent();
      }
      .tabBar(this.TabBarItem(2))

      TabContent() {
        this.ProfileTabContent();
      }
      .tabBar(this.TabBarItem(3))
    }
    .width('100%')
    .height('100%')
    .barBackgroundColor(AppTheme.BG_PRIMARY)
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentTab = index;
    })
  }

  @Builder
  TabBarItem(index: number) {
    Column() {
      Text(this.tabs[index].glyph.length > 0 ? this.tabs[index].glyph : '·')
        .fontSize(22)
        .fontColor(this.currentTab === index ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)

      Text(this.tabs[index].title)
        .fontSize(12)
        .fontColor(this.currentTab === index ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)
        .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)
        .margin({ top: 2 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  HomeTabContent() {
    Scroll() {
      Column() {
        this.HeaderSection();
        this.QuickActions();
        this.HotClubsSection();
        this.UpcomingActivitiesSection();
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
    .scrollBar(BarState.Off)
  }

  @Builder
  HeaderSection() {
    Column() {
      Row() {
        Column() {
          Text(`你好，${userStore.userName}`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.TEXT_PRIMARY)

          Text(userStore.isLeader ? '管理你的社团' : '发现精彩社团活动')
            .fontSize(14)
            .fontColor(AppTheme.TEXT_SECONDARY)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image(userStore.userAvatar && userStore.userAvatar.length > 0 ? userStore.userAvatar : ImageUrls.userFace(userStore.userId))
          .width(48)
          .height(48)
          .borderRadius(24)
          .backgroundColor(AppTheme.BG_TERTIARY)
          .objectFit(ImageFit.Cover)
          .border({ width: 2, color: AppTheme.PRIMARY_COLOR })
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_PROFILE);
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 60, bottom: 20 })
    }
    .width('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius({ bottomLeft: 20, bottomRight: 20 })
    .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder
  QuickActions() {
    Column() {
      Row() {
        this.ActionItem('全部社团', '🏢', () => {
          RouterUtil.push(Constants.ROUTE_CLUB_LIST);
        })
        this.ActionItem('全部活动', '📆', () => {
          RouterUtil.push(Constants.ROUTE_ACTIVITY_LIST);
        })
        this.ActionItem('我的社团', '👥', () => {
          RouterUtil.push(Constants.ROUTE_MY_CLUB);
        })
        this.ActionItem('我的活动', '📋', () => {
          RouterUtil.push(Constants.ROUTE_MY_ACTIVITY);
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 16, bottom: 8 })

      Row() {
        if (userStore.isAdmin) {
          this.ActionItem('社团审核', '✅', () => {
            RouterUtil.push(Constants.ROUTE_AUDIT_CLUB);
          })
          this.ActionItem('活动审核', '📌', () => {
            RouterUtil.push(Constants.ROUTE_AUDIT_ACTIVITY);
          })
          this.ActionItem('数据统计', '📊', () => {
            RouterUtil.push(Constants.ROUTE_STATISTICS);
          })
          this.ActionItem('经费监管', '💰', () => {
            RouterUtil.push(Constants.ROUTE_FINANCE_MANAGE);
          })
        } else {
          this.ActionItem('创建社团', '➕', () => {
            RouterUtil.push(Constants.ROUTE_CLUB_APPLY);
          })
          if (userStore.isLeader) {
            this.ActionItem('发起活动', '✨', () => {
              RouterUtil.push(Constants.ROUTE_ACTIVITY_APPLY);
            })
          }
          this.ActionItem('个人中心', '👤', () => {
            RouterUtil.push(Constants.ROUTE_PROFILE);
          })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 4, bottom: 16 })
    }
    .width('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  ActionItem(title: string, glyph: string, onClick: () => void) {
    Column() {
      Text(glyph)
        .fontSize(26)
        .margin({ bottom: 6 })

      Text(title)
        .fontSize(12)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .textAlign(TextAlign.Center)
        .maxLines(2)
    }
    .width(72)
    .height(86)
    .justifyContent(FlexAlign.Center)
    .onClick(onClick)
  }

  @Builder
  HotClubsSection() {
    Column() {
      Row() {
        Text('热门社团')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('查看全部')
          .fontSize(14)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_CLUB_LIST);
          })
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(30)
            .height(30)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .height(150)
        .justifyContent(FlexAlign.Center)
      } else {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          ForEach(this.hotClubs, (club: ClubInfo) => {
            this.ClubCard(club);
          }, (club: ClubInfo) => club.id)
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  ClubCard(club: ClubInfo) {
    Column() {
      Image(club.logo && club.logo.length > 0 ? club.logo : ImageUrls.clubCover(club.id))
        .width('100%')
        .height(100)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 12, topRight: 12 })

      Text(club.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ top: 8, left: 8, right: 8 })

      Row() {
        Text(club.category)
          .fontSize(10)
          .fontColor(AppTheme.TEXT_WHITE)
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .borderRadius(4)

        Text(`${club.memberCount}人`)
          .fontSize(10)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ left: 4 })
      }
      .width('100%')
      .padding({ left: 8, right: 8, bottom: 8 })
    }
    .width('48%')
    .backgroundColor(AppTheme.BG_TERTIARY)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_CLUB_DETAIL, new ClubIdRouteParam(club.id));
    })
  }

  @Builder
  UpcomingActivitiesSection() {
    Column() {
      Row() {
        Text('即将开始')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('查看全部')
          .fontSize(14)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_ACTIVITY_LIST);
          })
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(30)
            .height(30)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .height(150)
        .justifyContent(FlexAlign.Center)
      } else if (this.upcomingActivities.length === 0) {
        Row() {
          Text('暂无即将开始的活动')
            .fontSize(14)
            .fontColor(AppTheme.TEXT_TERTIARY)
        }
        .width('100%')
        .height(100)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          ForEach(this.upcomingActivities, (activity: ActivityInfo) => {
            this.ActivityCard(activity);
          }, (activity: ActivityInfo) => activity.id)
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16, bottom: 16 })
  }

  @Builder
  ActivityCard(activity: ActivityInfo) {
    Row() {
      Image(activity.coverImage && activity.coverImage.length > 0 ? activity.coverImage : ImageUrls.activityCover(activity.id))
        .width(80)
        .height(80)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)

      Column() {
        Text(activity.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row() {
          Text('🕐')
            .fontSize(12)
            .margin({ right: 4 })

          Text(CommonUtil.formatTimestamp(activity.startTime, 'MM-DD HH:mm'))
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
        }
        .margin({ top: 4 })

        Row() {
          Text('📍')
            .fontSize(12)
            .margin({ right: 4 })

          Text(activity.location)
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
        .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.BG_TERTIARY)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_ACTIVITY_DETAIL, new ActivityIdRouteParam(activity.id));
    })
  }

  @Builder
  ClubTabContent() {
    Column() {
      Row() {
        Text('社团')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_CLUB_LIST);
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 48, bottom: 12 })

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(36)
            .height(36)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.tabClubs, (club: ClubInfo) => {
            ListItem() {
              this.ClubRowItem(club);
            }
          }, (club: ClubInfo) => club.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, bottom: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  ClubRowItem(club: ClubInfo) {
    Row() {
      Image(club.logo && club.logo.length > 0 ? club.logo : ImageUrls.clubCover(club.id))
        .width(72)
        .height(72)
        .objectFit(ImageFit.Cover)
        .borderRadius(10)

      Column() {
        Text(club.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(club.category)
          .fontSize(12)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .margin({ top: 4 })

        Text(club.description)
          .fontSize(12)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .margin({ top: 6 })

        Text(`${club.memberCount} 人`)
          .fontSize(11)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_CLUB_DETAIL, new ClubIdRouteParam(club.id));
    })
  }

  @Builder
  ActivityTabContent() {
    Column() {
      Row() {
        Text('活动')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('更多')
          .fontSize(14)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_ACTIVITY_LIST);
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 48, bottom: 12 })

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(36)
            .height(36)
            .color(AppTheme.PRIMARY_COLOR)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.tabActivities, (activity: ActivityInfo) => {
            ListItem() {
              this.ActivityRowItem(activity);
            }
          }, (activity: ActivityInfo) => activity.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, bottom: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  ActivityRowItem(activity: ActivityInfo) {
    Row() {
      Image(activity.coverImage && activity.coverImage.length > 0 ? activity.coverImage : ImageUrls.activityCover(activity.id))
        .width(88)
        .height(88)
        .objectFit(ImageFit.Cover)
        .borderRadius(10)

      Column() {
        Text(activity.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(CommonUtil.formatTimestamp(activity.startTime, 'MM-DD HH:mm') + ' · ' + activity.location)
          .fontSize(12)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .maxLines(2)
          .margin({ top: 8 })
          .width('100%')

        Text(activity.clubName)
          .fontSize(12)
          .fontColor(AppTheme.PRIMARY_COLOR)
          .margin({ top: 6 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .onClick(() => {
      RouterUtil.push(Constants.ROUTE_ACTIVITY_DETAIL, new ActivityIdRouteParam(activity.id));
    })
  }

  @Builder
  ProfileTabContent() {
    Column() {
      Scroll() {
        Column() {
          Column().width('100%').height(80).backgroundColor(AppTheme.PRIMARY_COLOR)
          Column() {
            Row() {
              Image(userStore.userAvatar && userStore.userAvatar.length > 0 ? userStore.userAvatar : ImageUrls.userFace(userStore.userId))
                .width(64)
                .height(64)
                .objectFit(ImageFit.Cover)
                .backgroundColor('rgba(255,255,255,0.25)')
                .borderRadius(32)
                .border({ width: 2, color: AppTheme.TEXT_WHITE })

              Column() {
                Text(userStore.userName || '用户')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(AppTheme.TEXT_WHITE)

                Text(CommonUtil.getRoleText(userStore.userInfo?.role || 'student'))
                  .fontSize(13)
                  .fontColor(AppTheme.TEXT_WHITE)
                  .opacity(0.9)
                  .margin({ top: 6 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 16 })
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 16, bottom: 20 })
          }
          .width('100%')
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .borderRadius({ bottomLeft: 20, bottomRight: 20 })

          if (this.profileStats) {
            Row() {
              this.ProfileStatChip('加入社团', `${this.profileStats.joinedClubs}个`);
              this.ProfileStatChip('参与活动', `${this.profileStats.participatedActivities}次`);
              this.ProfileStatChip('时长', `${this.profileStats.totalHours}h`);
            }
            .width('100%')
            .padding(16)
            .justifyContent(FlexAlign.SpaceBetween)
            .backgroundColor(AppTheme.BG_PRIMARY)
            .borderRadius(16)
            .margin({ left: 16, right: 16, top: 16 })
          }

          Text('快捷功能')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .width('100%')
            .padding({ left: 20, top: 20, bottom: 8 })

          this.ProfileQuickRow('我的社团', '👥', () => {
            RouterUtil.push(Constants.ROUTE_MY_CLUB);
          })
          this.ProfileQuickRow('我的活动', '📅', () => {
            RouterUtil.push(Constants.ROUTE_MY_ACTIVITY);
          })

          if (userStore.isLeader) {
            this.ProfileQuickRow('成员管理', '🧑‍🤝‍🧑', () => {
              RouterUtil.push(Constants.ROUTE_MEMBER_MANAGE, new ClubIdRouteParam(userStore.clubId ?? ''));
            })
            this.ProfileQuickRow('财务管理', '💳', () => {
              RouterUtil.push(Constants.ROUTE_FINANCE_MANAGE, new ClubIdRouteParam(userStore.clubId ?? ''));
            })
          }

          if (userStore.isAdmin) {
            this.ProfileQuickRow('社团审核', '✅', () => {
              RouterUtil.push(Constants.ROUTE_AUDIT_CLUB);
            })
            this.ProfileQuickRow('活动审核', '📌', () => {
              RouterUtil.push(Constants.ROUTE_AUDIT_ACTIVITY);
            })
            this.ProfileQuickRow('数据统计', '📊', () => {
              RouterUtil.push(Constants.ROUTE_STATISTICS);
            })
          }

          Button('进入完整个人中心')
            .width('90%')
            .height(48)
            .fontSize(15)
            .backgroundColor(AppTheme.PRIMARY_COLOR)
            .fontColor(AppTheme.TEXT_WHITE)
            .borderRadius(24)
            .margin({ top: 24, bottom: 32 })
            .onClick(() => {
              RouterUtil.push(Constants.ROUTE_PROFILE);
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  ProfileStatChip(label: string, value: string) {
    Column() {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppTheme.PRIMARY_COLOR)
      Text(label)
        .fontSize(11)
        .fontColor(AppTheme.TEXT_TERTIARY)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Center)
    .layoutWeight(1)
  }

  @Builder
  ProfileQuickRow(title: string, glyph: string, onTap: () => void) {
    Row() {
      Text(glyph)
        .fontSize(20)
        .width(28)
        .textAlign(TextAlign.Center)

      Text(title)
        .fontSize(15)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .layoutWeight(1)
        .margin({ left: 8 })

      Text('›')
        .fontSize(22)
        .fontColor(AppTheme.TEXT_TERTIARY)
        .opacity(0.6)
    }
    .width('100%')
    .height(52)
    .padding({ left: 20, right: 20 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 8 })
    .onClick(onTap)
  }
}