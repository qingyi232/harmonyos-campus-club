// 个人中心页面
import { AppColors, AppFontSize, AppRadius, OnlineImages } from '../../common/constants/AppConstants'
import { RouterUtil, PageRoutes } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { UserInfo, ActivityRegistration } from '../../model/DataModels'

@Entry
@Component
struct ProfilePage {
  @State currentUser: UserInfo | null = null
  @State registrations: ActivityRegistration[] = []
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    this.loadRegistrations()
  }

  async loadRegistrations() {
    if (this.currentUser) {
      this.registrations = await this.dataService.getMyRegistrations(this.currentUser.id)
    }
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
        Text('个人中心')
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

      Scroll() {
        Column({ space: 12 }) {
          // 用户信息卡片
          Column({ space: 12 }) {
            Row({ space: 16 }) {
              Image(this.currentUser?.avatar || OnlineImages.AVATAR_DEFAULT)
                .width(72)
                .height(72)
                .borderRadius(36)
                .border({ width: 3, color: AppColors.PRIMARY_LIGHT })

              Column({ space: 6 }) {
                Text(this.currentUser?.realName || '')
                  .fontSize(AppFontSize.TITLE)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(AppColors.TEXT_PRIMARY)
                Text(`学号: ${this.currentUser?.studentId || ''}`)
                  .fontSize(AppFontSize.CAPTION)
                  .fontColor(AppColors.TEXT_SECONDARY)
                Text(`${this.currentUser?.college || ''} · ${this.currentUser?.major || ''}`)
                  .fontSize(AppFontSize.CAPTION)
                  .fontColor(AppColors.TEXT_SECONDARY)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')

            Divider().color(AppColors.DIVIDER)

            Row() {
              this.InfoItem('📱', '手机', this.currentUser?.phone || '未设置')
              this.InfoItem('📧', '邮箱', this.currentUser?.email || '未设置')
              this.InfoItem('🎓', '年级', this.currentUser?.grade || '未设置')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
          }
          .width('92%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
          .margin({ top: 12 })

          // 我的报名
          Column({ space: 10 }) {
            Text('📋 我的活动报名')
              .fontSize(AppFontSize.SUBTITLE)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
              .alignSelf(ItemAlign.Start)

            if (this.registrations.length === 0) {
              Text('暂无报名记录')
                .fontSize(AppFontSize.BODY)
                .fontColor(AppColors.TEXT_HINT)
                .padding(20)
            } else {
              ForEach(this.registrations, (reg: ActivityRegistration) => {
                Row() {
                  Column({ space: 4 }) {
                    Text(reg.activityTitle)
                      .fontSize(AppFontSize.BODY)
                      .fontColor(AppColors.TEXT_PRIMARY)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(`报名时间: ${DateUtil.formatDateTime(reg.registerTime)}`)
                      .fontSize(AppFontSize.SMALL)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)

                  Text(reg.status === 'registered' ? '已报名' : reg.status === 'checked_in' ? '已签到' : '已取消')
                    .fontSize(AppFontSize.SMALL)
                    .fontColor(reg.status === 'registered' ? AppColors.PRIMARY : reg.status === 'checked_in' ? AppColors.SUCCESS : AppColors.TEXT_HINT)
                    .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                    .backgroundColor(reg.status === 'registered' ? AppColors.TAG_GREEN : reg.status === 'checked_in' ? AppColors.TAG_GREEN : AppColors.BG_INPUT)
                    .borderRadius(AppRadius.ROUND)
                }
                .width('100%')
                .padding(12)
                .backgroundColor(AppColors.BG_SECTION)
                .borderRadius(AppRadius.SM)
              })
            }
          }
          .width('92%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)

          // 功能菜单
          Column({ space: 0 }) {
            this.MenuItem('🏛', '我的社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_MY_CLUBS) })
            Divider().color(AppColors.DIVIDER).margin({ left: 44 })
            this.MenuItem('📅', '活动记录', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_ACTIVITIES) })
            Divider().color(AppColors.DIVIDER).margin({ left: 44 })
            this.MenuItem('📢', '社团招新', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_RECRUITMENT) })
            Divider().color(AppColors.DIVIDER).margin({ left: 44 })
            this.MenuItem('✏', '申请创建社团', () => { RouterUtil.pushUrl(PageRoutes.STUDENT_APPLY_CLUB) })
          }
          .width('92%')
          .backgroundColor(Color.White)
          .borderRadius(AppRadius.LG)
          .padding({ top: 4, bottom: 4 })

          // 退出登录
          Button('退出登录')
            .width('92%')
            .height(48)
            .fontSize(AppFontSize.BODY)
            .fontColor(AppColors.DANGER)
            .backgroundColor(Color.White)
            .borderRadius(AppRadius.LG)
            .border({ width: 1, color: AppColors.DANGER })
            .margin({ bottom: 30 })
            .onClick(() => {
              this.dataService.logout()
              RouterUtil.replaceUrl(PageRoutes.LOGIN)
            })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder InfoItem(icon: string, label: string, value: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(20)
      Text(label).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
      Text(value).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_PRIMARY).maxLines(1)
    }
  }

  @Builder MenuItem(icon: string, label: string, action: () => void) {
    Row() {
      Text(icon).fontSize(20).margin({ right: 12 })
      Text(label).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      Text('>').fontSize(16).fontColor(AppColors.TEXT_HINT)
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .onClick(action)
  }
}
