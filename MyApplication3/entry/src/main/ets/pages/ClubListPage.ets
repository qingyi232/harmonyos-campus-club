import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ClubQueryParams } from '../services/MockDataService';
import { ClubInfo } from '../models/ClubModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ClubListPage {
  @State private clubs: ClubInfo[] = [];
  @State private filteredClubs: ClubInfo[] = [];
  @State private isLoading: boolean = true;
  @State private searchKeyword: string = '';
  @State private selectedCategory: string = '全部';
  @State private categories: string[] = ['全部'];

  private categoriesList: string[] = CommonUtil.getClubCategories();

  async aboutToAppear(): Promise<void> {
    this.categories = ['全部', ...this.categoriesList];
    await this.loadClubs();
  }

  async loadClubs(): Promise<void> {
    this.isLoading = true;
    try {
      const params = new ClubQueryParams();
      params.status = 'approved';
      const data = await MockDataService.getClubList(params);
      this.clubs = data;
      this.filterClubs();
    } catch (error) {
      console.error('Load clubs failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  filterClubs(): void {
    let result = this.clubs;

    // 分类筛选
    if (this.selectedCategory !== '全部') {
      result = result.filter(c => c.category === this.selectedCategory);
    }

    // 关键词搜索
    if (this.searchKeyword.trim()) {
      const keyword = this.searchKeyword.toLowerCase();
      result = result.filter(c => 
        c.name.toLowerCase().includes(keyword) || 
        c.description.toLowerCase().includes(keyword)
      );
    }

    this.filteredClubs = result;
  }

  onSearchChange(value: string): void {
    this.searchKeyword = value;
    this.filterClubs();
  }

  onCategorySelect(category: string): void {
    this.selectedCategory = category;
    this.filterClubs();
  }

  build() {
    Column() {
      // 顶部导航栏
      this.Header()

      // 分类标签
      this.CategoryTabs()

      // 社团列表
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
      } else if (this.filteredClubs.length === 0) {
        Row() {
          Column() {
            Image(IconUtil.EMPTY)
              .width(80)
              .height(80)
              .fillColor(AppTheme.TEXT_TERTIARY)
              .margin({ bottom: 16 })

            Text('暂无社团数据')
              .fontSize(16)
              .fontColor(AppTheme.TEXT_TERTIARY)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.filteredClubs, (club: ClubInfo) => {
            ListItem() {
              this.ClubListItem(club)
            }
          }, (club: ClubInfo) => club.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      }

      // 创建社团按钮（仅社长可见）
      if (userStore.isLeader || userStore.isAdmin) {
        Button('创建社团')
          .width('90%')
          .height(48)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .fontColor(AppTheme.TEXT_WHITE)
          .borderRadius(24)
          .margin({ bottom: 16 })
          .onClick(() => {
            RouterUtil.push(Constants.ROUTE_CLUB_APPLY);
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)
  }

  @Builder
  Header() {
    Column() {
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_PRIMARY)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('社团列表')
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

      // 搜索框
      Row() {
        Image(IconUtil.SEARCH)
          .width(20)
          .height(20)
          .fillColor(AppTheme.TEXT_TERTIARY)
          .margin({ right: 8 })

        TextInput({ placeholder: '搜索社团名称或描述', text: this.searchKeyword })
          .type(InputType.Normal)
          .placeholderColor(AppTheme.TEXT_TERTIARY)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .border({ width: 0 })
          .onChange((value: string) => {
            this.onSearchChange(value);
          })
      }
      .width('100%')
      .height(44)
      .padding({ left: 16, right: 16 })
      .backgroundColor(AppTheme.BG_TERTIARY)
      .borderRadius(22)
      .margin({ left: 16, right: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
  }

  @Builder
  CategoryTabs() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach(this.categories, (category: string) => {
          Text(category)
            .fontSize(14)
            .fontColor(this.selectedCategory === category ? AppTheme.TEXT_WHITE : AppTheme.TEXT_PRIMARY)
            .fontWeight(this.selectedCategory === category ? FontWeight.Medium : FontWeight.Normal)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor(this.selectedCategory === category ? AppTheme.PRIMARY_COLOR : AppTheme.BG_TERTIARY)
            .borderRadius(20)
            .onClick(() => {
              this.onCategorySelect(category);
            })
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height(50)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .margin({ bottom: 8 })
  }

  @Builder
  ClubListItem(club: ClubInfo) {
    Row() {
      Image(club.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=200&h=200&fit=crop')
        .width(70)
        .height(70)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)

      Column() {
        Text(club.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

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
        .margin({ top: 4 })

        Text(club.description)
          .fontSize(13)
          .fontColor(AppTheme.TEXT_SECONDARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })

      Image(IconUtil.ARROW_RIGHT)
        .width(20)
        .height(20)
        .fillColor(AppTheme.TEXT_TERTIARY)
        .margin({ left: 8 })
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
