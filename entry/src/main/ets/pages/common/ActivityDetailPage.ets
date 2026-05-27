// 活动详情页面 - 含签到、评价、活动总结功能
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import { DateUtil } from '../../common/utils/DateUtil'
import DataService from '../../service/DataService'
import { ActivityInfo, ActivityStatus, UserInfo, UserRole, ActivityReview, CheckInRecord } from '../../model/DataModels'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ActivityDetailPage {
  @State activity: ActivityInfo | null = null
  @State currentUser: UserInfo | null = null
  @State isRegistered: boolean = false
  @State isCheckedIn: boolean = false
  @State isLoading: boolean = true
  @State reviews: ActivityReview[] = []
  @State checkIns: CheckInRecord[] = []
  @State averageRating: number = 0
  @State activeTab: number = 0
  // 评价表单
  @State showReviewDialog: boolean = false
  @State reviewRating: number = 5
  @State reviewContent: string = ''
  // 活动总结表单（负责人）
  @State showSummaryDialog: boolean = false
  @State summaryText: string = ''
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() {
    this.currentUser = this.dataService.getCurrentUser()
    const params = RouterUtil.getParams()
    if (params && params.activityId) {
      this.loadActivity(params.activityId as string)
    }
  }

  async loadActivity(activityId: string) {
    this.isLoading = true
    this.activity = await this.dataService.getActivityById(activityId)
    if (this.currentUser && this.activity) {
      this.isRegistered = await this.dataService.isRegistered(activityId, this.currentUser.id)
      this.isCheckedIn = await this.dataService.isCheckedIn(activityId, this.currentUser.id)
    }
    this.reviews = await this.dataService.getActivityReviews(activityId)
    this.checkIns = await this.dataService.getCheckInRecords(activityId)
    this.averageRating = await this.dataService.getAverageRating(activityId)
    if (this.activity?.summary) this.summaryText = this.activity.summary
    this.isLoading = false
  }

  async handleRegister() {
    if (!this.currentUser || !this.activity) return
    const success = await this.dataService.registerActivity(this.activity.id, this.currentUser.id, this.currentUser.realName)
    if (success) {
      this.isRegistered = true
      this.activity.currentParticipants++
      promptAction.showToast({ message: '报名成功！', duration: 1500 })
    } else {
      promptAction.showToast({ message: '报名失败，可能已报名或名额已满', duration: 2000 })
    }
  }

  async handleCheckIn() {
    if (!this.currentUser || !this.activity) return
    const success = await this.dataService.checkIn(this.activity.id, this.currentUser.id, this.currentUser.realName)
    if (success) {
      this.isCheckedIn = true
      this.checkIns = await this.dataService.getCheckInRecords(this.activity.id)
      promptAction.showToast({ message: '签到成功！', duration: 1500 })
    } else {
      promptAction.showToast({ message: '您已签到过', duration: 2000 })
    }
  }

  async handleSubmitReview() {
    if (!this.currentUser || !this.activity || !this.reviewContent) {
      promptAction.showToast({ message: '请填写评价内容', duration: 2000 })
      return
    }
    const success = await this.dataService.submitReview({
      activityId: this.activity.id, activityTitle: this.activity.title,
      userId: this.currentUser.id, userName: this.currentUser.realName,
      rating: this.reviewRating, content: this.reviewContent
    })
    if (success) {
      promptAction.showToast({ message: '评价提交成功', duration: 1500 })
      this.showReviewDialog = false
      this.reviewContent = ''
      this.reviews = await this.dataService.getActivityReviews(this.activity.id)
      this.averageRating = await this.dataService.getAverageRating(this.activity.id)
    } else {
      promptAction.showToast({ message: '您已评价过该活动', duration: 2000 })
    }
  }

  async handleSubmitSummary() {
    if (!this.activity || !this.summaryText) return
    const photos = [
      'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400&h=300&fit=crop'
    ]
    const success = await this.dataService.updateActivitySummary(this.activity.id, this.summaryText, photos)
    if (success) {
      promptAction.showToast({ message: '活动总结已保存', duration: 1500 })
      this.showSummaryDialog = false
      this.activity = await this.dataService.getActivityById(this.activity.id)
    }
  }

  getStatusText(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.APPROVED: return '报名中'
      case ActivityStatus.ONGOING: return '进行中'
      case ActivityStatus.FINISHED: return '已结束'
      case ActivityStatus.PENDING: return '待审核'
      default: return '未知'
    }
  }

  getStatusColor(status: ActivityStatus): string {
    switch (status) {
      case ActivityStatus.APPROVED: return AppColors.PRIMARY
      case ActivityStatus.ONGOING: return AppColors.WARNING
      case ActivityStatus.FINISHED: return AppColors.TEXT_HINT
      default: return AppColors.TEXT_SECONDARY
    }
  }

  renderStars(rating: number): string {
    return '★'.repeat(Math.round(rating)) + '☆'.repeat(5 - Math.round(rating))
  }

  build() {
    Stack() {
      Column() {
        if (this.isLoading || !this.activity) {
          Column() { LoadingProgress().width(40).height(40).color(AppColors.PRIMARY) }
            .width('100%').height('100%').justifyContent(FlexAlign.Center)
        } else {
          // 封面
          Stack({ alignContent: Alignment.TopStart }) {
            Image(this.activity.coverImage).width('100%').height(220).objectFit(ImageFit.Cover)
            Row() {
              Text('←').fontSize(24).fontColor(Color.White)
                .onClick(() => { RouterUtil.back() }).padding(10)
                .backgroundColor('#40000000').borderRadius(20)
            }.padding({ left: 12, top: 44 })
          }.width('100%')

          // Tab切换
          Row() {
            ForEach(['详情', '签到', '评价'], (tab: string, index: number) => {
              Text(tab).fontSize(AppFontSize.BODY)
                .fontColor(this.activeTab === index ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
                .fontWeight(this.activeTab === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 20, right: 20, top: 10, bottom: 10 })
                .border({ width: { bottom: 2 }, color: this.activeTab === index ? AppColors.PRIMARY : Color.Transparent })
                .onClick(() => { this.activeTab = index })
            })
          }.width('100%').backgroundColor(Color.White).justifyContent(FlexAlign.SpaceAround)

          Scroll() {
            Column() {
              if (this.activeTab === 0) { this.DetailTab() }
              else if (this.activeTab === 1) { this.CheckInTab() }
              else { this.ReviewTab() }
            }
          }.layoutWeight(1).scrollBar(BarState.Off)

          // 底部操作栏
          this.BottomBar()
        }
      }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)

      // 评价弹窗
      if (this.showReviewDialog) {
        Column().width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showReviewDialog = false }).position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Text('评价活动').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          Text('评分').fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
          Row({ space: 8 }) {
            ForEach([1, 2, 3, 4, 5], (star: number) => {
              Text(star <= this.reviewRating ? '★' : '☆')
                .fontSize(28).fontColor(star <= this.reviewRating ? '#F39C12' : AppColors.TEXT_HINT)
                .onClick(() => { this.reviewRating = star })
            })
          }
          TextArea({ placeholder: '请输入您的评价...', text: this.reviewContent })
            .width('100%').height(100).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.reviewContent = v })
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppColors.TEXT_SECONDARY)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .onClick(() => { this.showReviewDialog = false })
            Button('提交评价').layoutWeight(1).height(42).fontColor(Color.White)
              .backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
              .onClick(() => { this.handleSubmitReview() })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor(Color.White).borderRadius(AppRadius.XL)
          .position({ x: '7.5%', y: '25%' })
      }

      // 活动总结弹窗（负责人）
      if (this.showSummaryDialog) {
        Column().width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showSummaryDialog = false }).position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Text('活动总结').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          TextArea({ placeholder: '请输入活动总结...', text: this.summaryText })
            .width('100%').height(150).backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
            .onChange((v: string) => { this.summaryText = v })
          Text('提交后将自动附带活动照片，活动状态变为"已结束"')
            .fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppColors.TEXT_SECONDARY)
              .backgroundColor(AppColors.BG_INPUT).borderRadius(AppRadius.MD)
              .onClick(() => { this.showSummaryDialog = false })
            Button('提交总结').layoutWeight(1).height(42).fontColor(Color.White)
              .backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.MD)
              .onClick(() => { this.handleSubmitSummary() })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor(Color.White).borderRadius(AppRadius.XL)
          .position({ x: '7.5%', y: '20%' })
      }
    }.width('100%').height('100%')
  }

  // ========== 详情Tab ==========
  @Builder DetailTab() {
    Column({ space: 12 }) {
      Row() {
        Text(this.getStatusText(this.activity!.status)).fontSize(11).fontColor(Color.White)
          .backgroundColor(this.getStatusColor(this.activity!.status))
          .padding({ left: 10, right: 10, top: 4, bottom: 4 }).borderRadius(AppRadius.ROUND)
        Blank()
        Text(this.activity!.clubName).fontSize(AppFontSize.CAPTION).fontColor(AppColors.PRIMARY)
      }.width('100%')

      Text(this.activity!.title).fontSize(22).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      Text(this.activity!.description).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY).lineHeight(24)

      Divider().color(AppColors.DIVIDER)
      Column({ space: 10 }) {
        this.InfoRow('📍', '活动地点', this.activity!.location)
        this.InfoRow('📅', '开始时间', DateUtil.formatDateTime(this.activity!.startTime))
        this.InfoRow('⏰', '结束时间', DateUtil.formatDateTime(this.activity!.endTime))
        this.InfoRow('👤', '发起人', this.activity!.creatorName)
      }
      Divider().color(AppColors.DIVIDER)

      // 报名进度
      Column({ space: 8 }) {
        Row() {
          Text('报名情况').fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          Blank()
          Text(`${this.activity!.currentParticipants}/${this.activity!.maxParticipants}`).fontSize(AppFontSize.BODY).fontColor(AppColors.PRIMARY)
        }.width('100%')
        Progress({ value: this.activity!.currentParticipants, total: this.activity!.maxParticipants })
          .width('100%').height(8).color(AppColors.PRIMARY).backgroundColor(AppColors.PRIMARY_LIGHT).borderRadius(4)
      }

      // 评分
      if (this.averageRating > 0) {
        Row({ space: 8 }) {
          Text('活动评分:').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
          Text(this.renderStars(this.averageRating)).fontSize(18).fontColor('#F39C12')
          Text(`${this.averageRating.toFixed(1)}分`).fontSize(AppFontSize.BODY).fontColor(AppColors.WARNING)
          Text(`(${this.reviews.length}条评价)`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
        }.width('100%')
      }

      // 活动总结
      if (this.activity!.summary) {
        Divider().color(AppColors.DIVIDER)
        Column({ space: 8 }) {
          Text('📝 活动总结').fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          Text(this.activity!.summary).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY).lineHeight(22)
          if (this.activity!.photos.length > 0) {
            Text('📷 活动照片').fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY).margin({ top: 4 })
            Row({ space: 8 }) {
              ForEach(this.activity!.photos, (photo: string) => {
                Image(photo).width(120).height(90).borderRadius(AppRadius.SM).objectFit(ImageFit.Cover)
              })
            }
          }
        }
      }

      // 标签
      if (this.activity!.tags.length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.activity!.tags, (tag: string) => {
            Text(`#${tag}`).fontSize(AppFontSize.CAPTION).fontColor(AppColors.ACCENT)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
              .backgroundColor(AppColors.TAG_BLUE).borderRadius(AppRadius.ROUND)
              .margin({ right: 8, bottom: 8 })
          })
        }
      }
    }.width('100%').padding(20).backgroundColor(Color.White)
  }

  // ========== 签到Tab ==========
  @Builder CheckInTab() {
    Column({ space: 12 }) {
      Text(`已签到 ${this.checkIns.length} 人`).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY).alignSelf(ItemAlign.Start)

      if (this.checkIns.length === 0) {
        Text('暂无签到记录').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_HINT).padding(30)
      } else {
        ForEach(this.checkIns, (record: CheckInRecord) => {
          Row({ space: 12 }) {
            Text(record.userName.charAt(0)).fontSize(16).fontColor(Color.White)
              .textAlign(TextAlign.Center).width(38).height(38).borderRadius(19)
              .backgroundColor(AppColors.ACCENT)
            Column({ space: 3 }) {
              Text(record.userName).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
              Text(`签到时间: ${DateUtil.formatDateTime(record.checkInTime)}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
            }.layoutWeight(1).alignItems(HorizontalAlign.Start)
            Text('✅').fontSize(18)
          }.width('100%').padding(12).backgroundColor(Color.White).borderRadius(AppRadius.SM)
        })
      }
    }.width('100%').padding(16)
  }

  // ========== 评价Tab ==========
  @Builder ReviewTab() {
    Column({ space: 12 }) {
      Row() {
        Text(`活动评价 (${this.reviews.length})`).fontSize(AppFontSize.SUBTITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
        Blank()
        if (this.averageRating > 0) {
          Text(`${this.renderStars(this.averageRating)} ${this.averageRating.toFixed(1)}`).fontSize(AppFontSize.CAPTION).fontColor('#F39C12')
        }
      }.width('100%')

      if (this.reviews.length === 0) {
        Text('暂无评价，快来第一个评价吧！').fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_HINT).padding(30)
      } else {
        ForEach(this.reviews, (review: ActivityReview) => {
          Column({ space: 6 }) {
            Row({ space: 10 }) {
              Text(review.userName.charAt(0)).fontSize(14).fontColor(Color.White)
                .textAlign(TextAlign.Center).width(36).height(36).borderRadius(18)
                .backgroundColor(AppColors.PRIMARY)
              Column({ space: 2 }) {
                Text(review.userName).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY)
                Text(this.renderStars(review.rating)).fontSize(14).fontColor('#F39C12')
              }.layoutWeight(1).alignItems(HorizontalAlign.Start)
              Text(DateUtil.formatRelative(review.createTime)).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
            }.width('100%')
            Text(review.content).fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_SECONDARY).lineHeight(20)
          }.width('100%').padding(12).backgroundColor(Color.White).borderRadius(AppRadius.SM)
        })
      }
    }.width('100%').padding(16)
  }

  // ========== 底部操作栏 ==========
  @Builder BottomBar() {
    if (!this.activity) return

    Row({ space: 10 }) {
      // 学生端操作
      if (this.currentUser?.role === UserRole.STUDENT) {
        if (this.activity.status === ActivityStatus.APPROVED) {
          if (this.isRegistered) {
            Button('已报名 ✓').layoutWeight(1).height(44).fontColor(Color.White)
              .backgroundColor(AppColors.TEXT_HINT).borderRadius(AppRadius.LG).enabled(false)
          } else {
            Button('立即报名').layoutWeight(1).height(44).fontWeight(FontWeight.Medium)
              .fontColor(Color.White).backgroundColor(AppColors.PRIMARY).borderRadius(AppRadius.LG)
              .onClick(() => { this.handleRegister() })
          }
        }
        if (this.isRegistered && (this.activity.status === ActivityStatus.APPROVED || this.activity.status === ActivityStatus.ONGOING)) {
          if (this.isCheckedIn) {
            Button('已签到 ✓').layoutWeight(1).height(44).fontColor(Color.White)
              .backgroundColor(AppColors.TEXT_HINT).borderRadius(AppRadius.LG).enabled(false)
          } else {
            Button('签到').layoutWeight(1).height(44).fontColor(Color.White)
              .backgroundColor(AppColors.ACCENT).borderRadius(AppRadius.LG)
              .onClick(() => { this.handleCheckIn() })
          }
        }
        if (this.isRegistered) {
          Button('评价').layoutWeight(1).height(44).fontColor(AppColors.PRIMARY)
            .backgroundColor(Color.White).border({ width: 1, color: AppColors.PRIMARY })
            .borderRadius(AppRadius.LG)
            .onClick(() => { this.showReviewDialog = true })
        }
      }

      // 负责人端操作
      if (this.currentUser?.role === UserRole.LEADER && this.activity.creatorId === this.currentUser.id) {
        if (this.activity.status !== ActivityStatus.FINISHED) {
          Button('提交活动总结').layoutWeight(1).height(44).fontColor(Color.White)
            .backgroundColor(AppColors.WARNING).borderRadius(AppRadius.LG)
            .onClick(() => { this.showSummaryDialog = true })
        }
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: AppColors.BORDER_LIGHT })
  }

  @Builder InfoRow(icon: string, label: string, value: string) {
    Row({ space: 10 }) {
      Text(icon).fontSize(18)
      Text(label).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_SECONDARY).width(70)
      Text(value).fontSize(AppFontSize.BODY).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
    }.width('100%')
  }
}
