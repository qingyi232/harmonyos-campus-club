// 社团列表页面 - 学生端
import { AppColors, AppFontSize, AppRadius, ClubCategories } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { ClubInfo } from '../../model/DataModels'

@Entry
@Component
struct ClubListPage {
  @State clubs: ClubInfo[] = []
  @State filteredClubs: ClubInfo[] = []
  @State selectedCategory: string = '全部'
  @State searchKeyword: string = ''
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()
  private categories: string[] = ['全部', ...ClubCategories.ALL]

  aboutToAppear() {
    this.loadClubs()
  }

  async loadClubs() {
    this.isLoading = true
    this.clubs = await this.dataService.getClubs()
    this.filteredClubs = [...this.clubs]
    this.isLoading = false
  }

  filterClubs() {
    let result = [...this.clubs]
    if (this.selectedCategory !== '全部') {
      result = result.filter(c => c.category === this.selectedCategory)
    }
    if (this.searchKeyword) {
      const kw = this.searchKeyword.toLowerCase()
      result = result.filter(c => c.name.toLowerCase().includes(kw) || c.description.toLowerCase().includes(kw))
    }
    this.filteredClubs = result
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() })
          .padding(10)
        Text('全部社团')
          .fontSize(AppFontSize.TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('').width(44)
      }
      .width('100%')
      .height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor(Color.White)

      // 搜索栏
      Row() {
        Text('🔍')
          .fontSize(16)
          .margin({ right: 8 })
        TextInput({ placeholder: '搜索社团名称...', text: this.searchKeyword })
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .fontSize(AppFontSize.BODY)
          .onChange((val: string) => {
            this.searchKeyword = val
            this.filterClubs()
          })
      }
      .width('92%')
      .height(44)
      .padding({ left: 14, right: 14 })
      .backgroundColor(Color.White)
      .borderRadius(AppRadius.ROUND)
      .margin({ top: 12 })
      .border({ width: 1, color: AppColors.BORDER })

      // 分类标签
      Scroll() {
        Row({ space: 8 }) {
          ForEach(this.categories, (cat: string) => {
            Text(cat)
              .fontSize(AppFontSize.CAPTION)
              .fontColor(this.selectedCategory === cat ? Color.White : AppColors.TEXT_PRIMARY)
              .backgroundColor(this.selectedCategory === cat ? AppColors.PRIMARY : AppColors.BG_CARD)
              .padding({ left: 14, right: 14, top: 7, bottom: 7 })
              .borderRadius(AppRadius.ROUND)
              .border({ width: 1, color: this.selectedCategory === cat ? AppColors.PRIMARY : AppColors.BORDER })
              .onClick(() => {
                this.selectedCategory = cat
                this.filterClubs()
              })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(50)
      .margin({ top: 8 })

      // 社团列表
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color(AppColors.PRIMARY)
          Text('加载中...')
            .fontSize(AppFontSize.CAPTION)
            .fontColor(AppColors.TEXT_HINT)
            .margin({ top: 8 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.filteredClubs.length === 0) {
        Column({ space: 12 }) {
          Text('😔')
            .fontSize(48)
          Text('暂无相关社团')
            .fontSize(AppFontSize.BODY)
            .fontColor(AppColors.TEXT_SECONDARY)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.filteredClubs, (club: ClubInfo) => {
            ListItem() {
              Row({ space: 14 }) {
                Image(club.logo)
                  .width(70)
                  .height(70)
                  .borderRadius(AppRadius.MD)
                  .objectFit(ImageFit.Cover)

                Column({ space: 5 }) {
                  Text(club.name)
                    .fontSize(AppFontSize.SUBTITLE)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)
                  Text(club.description)
                    .fontSize(AppFontSize.CAPTION)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row({ space: 8 }) {
                    Text(club.category)
                      .fontSize(10)
                      .fontColor(AppColors.PRIMARY_DARK)
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor(AppColors.TAG_GREEN)
                      .borderRadius(AppRadius.ROUND)
                    Text(`👥 ${club.memberCount}人`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                    Text(`负责人: ${club.leaderName}`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(AppRadius.LG)
              .onClick(() => {
                RouterUtil.pushUrl(PageRoutes.CLUB_DETAIL, { clubId: club.id } as Record<string, Object>)
              })
            }
          })
        }
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 4 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}
