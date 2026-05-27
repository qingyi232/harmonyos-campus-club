import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { ActivityInfo, ActivityRegistration, ActivityReview } from '../models/ActivityModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { ActivityIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ActivityDetailPage {
  @State private activityId: string = '';
  @State private activity: ActivityInfo | null = null;
  @State private registrations: ActivityRegistration[] = [];
  @State private reviews: ActivityReview[] = [];
  @State private isLoading: boolean = true;
  @State private isRegistered: boolean = false;
  @State private isCheckedIn: boolean = false;
  @State private canRegister: boolean = true;
  @State private showReviewDialog: boolean = false;
  @State private reviewRating: number = 5;
  @State private reviewContent: string = '';
  @State private showSummaryDialog: boolean = false;
  @State private summaryText: string = '';

  async aboutToAppear(): Promise<void> {
    const params = RouterUtil.getParams() as ActivityIdRouteParam;
    this.activityId = params.activityId || '';
    
    if (this.activityId) {
      await this.loadData();
    }
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      const results = await Promise.all([
        MockDataService.getActivityDetail(this.activityId),
        MockDataService.getActivityRegistrations(this.activityId)
      ]);
      this.activity = results[0];
      this.registrations = results[1];
      
      this.isRegistered = results[1].some((r: ActivityRegistration) => r.userId === userStore.userId);
      const myReg: ActivityRegistration | undefined = results[1].find((r: ActivityRegistration) => r.userId === userStore.userId);
      this.isCheckedIn = myReg !== undefined && (myReg.checkInTime ?? 0) > 0;
      
      const now = Date.now();
      this.canRegister = !this.isRegistered && 
                        this.activity?.status === 'approved' && 
                        this.activity?.currentParticipants < this.activity?.maxParticipants &&
                        this.activity?.startTime > now;

      try {
        this.reviews = await MockDataService.getActivityReviews(this.activityId);
      } catch { this.reviews = []; }
    } catch (error) {
      console.error('Load activity detail failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  async handleRegister(): Promise<void> {
    if (!this.canRegister || !this.activity) return;
    try {
      await MockDataService.registerActivity(userStore.userId, userStore.userName, userStore.userAvatar, this.activityId);
      await this.loadData();
    } catch (error) {
      console.error('Register failed:', JSON.stringify(error));
    }
  }

  async handleCheckIn(): Promise<void> {
    if (!this.isRegistered || this.isCheckedIn) return;
    try {
      await MockDataService.checkInActivity(userStore.userId, this.activityId);
      this.isCheckedIn = true;
      await this.loadData();
    } catch (error) {
      console.error('CheckIn failed:', JSON.stringify(error));
    }
  }

  async handleSubmitReview(): Promise<void> {
    if (!this.reviewContent.trim()) return;
    try {
      await MockDataService.submitActivityReview(this.activityId, userStore.userId, userStore.userName, this.reviewRating, this.reviewContent);
      this.showReviewDialog = false;
      this.reviewContent = '';
      this.reviewRating = 5;
      await this.loadData();
    } catch (error) {
      console.error('Submit review failed:', JSON.stringify(error));
    }
  }

  async handleSubmitSummary(): Promise<void> {
    if (!this.summaryText.trim() || !this.activity) return;
    try {
      await MockDataService.submitActivitySummary(this.activityId, this.summaryText);
      this.showSummaryDialog = false;
      await this.loadData();
    } catch (error) {
      console.error('Submit summary failed:', JSON.stringify(error));
    }
  }

  getAvgRating(): number {
    if (this.reviews.length === 0) return 0;
    return this.reviews.reduce((s: number, r: ActivityReview) => s + r.rating, 0) / this.reviews.length;
  }

  renderStars(rating: number): string {
    return '★'.repeat(Math.round(rating)) + '☆'.repeat(5 - Math.round(rating));
  }

  build() {
    Stack() {
      Column() {
        if (this.isLoading) {
          Row() {
            LoadingProgress().width(40).height(40).color(AppTheme.PRIMARY_COLOR)
          }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
        } else if (this.activity) {
          Scroll() {
            Column() {
              this.ActivityCover()
              this.ActivityInfo()
              this.ActivityDescription()
              if (this.activity.tags && this.activity.tags.length > 0) { this.ActivityTags() }
              if (this.activity.summary) { this.SummarySection() }
              this.ReviewsSection()
              this.RegistrationsSection()
            }.width('100%')
          }.width('100%').layoutWeight(1).scrollBar(BarState.Off)
          this.ActionBar()
        }
      }.width('100%').height('100%').backgroundColor(AppTheme.BG_SECONDARY)

      if (this.showReviewDialog) {
        Column().width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showReviewDialog = false; }).position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Text('评价活动').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
          Text('评分').fontSize(13).fontColor(AppTheme.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
          Row({ space: 8 }) {
            ForEach([1, 2, 3, 4, 5], (star: number) => {
              Text(star <= this.reviewRating ? '★' : '☆')
                .fontSize(28).fontColor(star <= this.reviewRating ? '#F39C12' : AppTheme.TEXT_TERTIARY)
                .onClick(() => { this.reviewRating = star; })
            })
          }
          TextArea({ placeholder: '请输入您的评价...', text: this.reviewContent })
            .width('100%').height(100).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.reviewContent = v; })
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppTheme.TEXT_SECONDARY)
              .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .onClick(() => { this.showReviewDialog = false; })
            Button('提交评价').layoutWeight(1).height(42).fontColor('#FFFFFF')
              .backgroundColor(AppTheme.PRIMARY_COLOR).borderRadius(10)
              .onClick(() => { this.handleSubmitReview(); })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '25%' })
      }

      if (this.showSummaryDialog) {
        Column().width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showSummaryDialog = false; }).position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Text('活动总结').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
          TextArea({ placeholder: '请输入活动总结...', text: this.summaryText })
            .width('100%').height(150).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.summaryText = v; })
          Text('提交后活动状态变为"已结束"').fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppTheme.TEXT_SECONDARY)
              .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .onClick(() => { this.showSummaryDialog = false; })
            Button('提交总结').layoutWeight(1).height(42).fontColor('#FFFFFF')
              .backgroundColor(AppTheme.PRIMARY_COLOR).borderRadius(10)
              .onClick(() => { this.handleSubmitSummary(); })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '20%' })
      }
    }.width('100%').height('100%')
  }

  @Builder
  ActivityCover() {
    Stack() {
      Image(this.activity?.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop')
        .width('100%')
        .height(240)
        .objectFit(ImageFit.Cover)

      // 顶部导航
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_WHITE)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('活动详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_WHITE)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(24)
          .height(24)
      }
      .width('100%')
      .height(90)
      .padding({ left: 16, right: 16, top: 36 })
      .position({ x: 0, y: 0 })

      // 状态标签
      if (this.activity?.status === 'ongoing') {
        Text('进行中')
          .fontSize(14)
          .fontColor(AppTheme.TEXT_WHITE)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(AppTheme.PRIMARY_COLOR)
          .borderRadius(16)
          .position({ x: 16, y: 200 })
      }
    }
    .width('100%')
    .height(240)
  }

  @Builder
  ActivityInfo() {
    Column() {
      Text(this.activity?.title || '')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')

      Row() {
        Image(IconUtil.COMMUNITY)
          .width(16)
          .height(16)
          .fillColor(AppTheme.TEXT_TERTIARY)

        Text(this.activity?.clubName || '')
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .margin({ left: 4 })
      }
      .margin({ top: 8 })

      Row() {
        Row() {
          Image(IconUtil.TIME)
            .width(16)
            .height(16)
            .fillColor(AppTheme.TEXT_TERTIARY)

          Text(CommonUtil.formatTimestamp(this.activity?.startTime || 0, 'YYYY-MM-DD HH:mm'))
            .fontSize(14)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .margin({ left: 4 })
        }

        Row() {
          Image(IconUtil.LOCATION)
            .width(16)
            .height(16)
            .fillColor(AppTheme.TEXT_TERTIARY)

          Text(this.activity?.location || '')
            .fontSize(14)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .margin({ left: 4 })
        }
        .margin({ left: 24 })
      }
      .margin({ top: 12 })

      Row() {
        Text(`报名人数：${this.activity?.currentParticipants || 0}/${this.activity?.maxParticipants || 0}`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)

        Blank()

        Text(`创建者：${this.activity?.creatorName || ''}`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: -20 })
  }

  @Builder
  ActivityDescription() {
    Column() {
      Text('活动详情')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Text(this.activity?.description || '')
        .fontSize(14)
        .fontColor(AppTheme.TEXT_SECONDARY)
        .lineHeight(24)
        .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  ActivityTags() {
    Column() {
      Text('活动标签')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.activity?.tags || [], (tag: string) => {
          Text(tag)
            .fontSize(13)
            .fontColor(AppTheme.PRIMARY_COLOR)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(16)
            .margin({ right: 8, bottom: 8 })
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
  RegistrationsSection() {
    Column() {
      Row() {
        Text('报名人员')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text(`${this.registrations.length}人`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.registrations.length === 0) {
        Text('暂无报名人员')
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .width('100%')
          .height(60)
          .textAlign(TextAlign.Center)
      } else {
        Column() {
          ForEach(this.registrations.slice(0, 20), (reg: ActivityRegistration) => {
            Row() {
              Image(reg.userAvatar || 'https://i.pravatar.cc/150')
                .width(40)
                .height(40)
                .objectFit(ImageFit.Cover)
                .borderRadius(20)

              Column() {
                Text(reg.userName)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppTheme.TEXT_PRIMARY)

                Text(CommonUtil.formatTimestamp(reg.registerTime, 'MM-DD HH:mm'))
                  .fontSize(12)
                  .fontColor(AppTheme.TEXT_TERTIARY)
                  .margin({ top: 2 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(12)
            .margin({ bottom: 8 })
          })
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16, bottom: 16 })
  }

  @Builder
  SummarySection() {
    Column() {
      Text('📝 活动总结').fontSize(16).fontWeight(FontWeight.Medium).fontColor(AppTheme.TEXT_PRIMARY).width('100%').margin({ bottom: 12 })
      Text(this.activity?.summary || '').fontSize(14).fontColor(AppTheme.TEXT_SECONDARY).lineHeight(22).width('100%')
    }
    .width('100%').padding(16).backgroundColor(AppTheme.BG_PRIMARY).borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  ReviewsSection() {
    Column() {
      Row() {
        Text(`活动评价 (${this.reviews.length})`).fontSize(16).fontWeight(FontWeight.Medium).fontColor(AppTheme.TEXT_PRIMARY).layoutWeight(1)
        if (this.reviews.length > 0) {
          Text(`${this.renderStars(this.getAvgRating())} ${this.getAvgRating().toFixed(1)}`).fontSize(13).fontColor('#F39C12')
        }
      }.width('100%').margin({ bottom: 12 })

      if (this.reviews.length === 0) {
        Text('暂无评价').fontSize(14).fontColor(AppTheme.TEXT_TERTIARY).width('100%').height(40).textAlign(TextAlign.Center)
      } else {
        ForEach(this.reviews.slice(0, 10), (review: ActivityReview) => {
          Column({ space: 4 }) {
            Row({ space: 8 }) {
              Text(review.userName.charAt(0)).fontSize(14).fontColor('#FFFFFF')
                .textAlign(TextAlign.Center).width(32).height(32).borderRadius(16)
                .backgroundColor(AppTheme.PRIMARY_COLOR)
              Column({ space: 2 }) {
                Text(review.userName).fontSize(14).fontColor(AppTheme.TEXT_PRIMARY)
                Text(this.renderStars(review.rating)).fontSize(12).fontColor('#F39C12')
              }.layoutWeight(1).alignItems(HorizontalAlign.Start)
              Text(CommonUtil.formatTimestamp(review.createTime, 'MM-DD')).fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
            }.width('100%')
            Text(review.content).fontSize(13).fontColor(AppTheme.TEXT_SECONDARY).lineHeight(20).width('100%')
          }.width('100%').padding(12).backgroundColor(AppTheme.BG_TERTIARY).borderRadius(10).margin({ bottom: 8 })
        })
      }
    }
    .width('100%').padding(16).backgroundColor(AppTheme.BG_PRIMARY).borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  ActionBar() {
    Row({ space: 10 }) {
      if (userStore.isLeader && this.activity?.creatorId === userStore.userId && this.activity?.status !== 'finished') {
        Button('提交活动总结').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF').backgroundColor('#F39C12').borderRadius(22)
          .onClick(() => { this.summaryText = this.activity?.summary || ''; this.showSummaryDialog = true; })
      }

      if (!this.isRegistered && this.canRegister) {
        Button('立即报名').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
          .backgroundColor(AppTheme.PRIMARY_COLOR).fontColor('#FFFFFF').borderRadius(22)
          .onClick(() => { this.handleRegister(); })
      }

      if (this.isRegistered && !this.isCheckedIn) {
        Button('签到').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
          .backgroundColor(AppTheme.SUCCESS).fontColor('#FFFFFF').borderRadius(22)
          .onClick(() => { this.handleCheckIn(); })
      }

      if (this.isRegistered && this.isCheckedIn) {
        Button('已签到 ✓').layoutWeight(1).height(44).fontSize(14)
          .backgroundColor(AppTheme.BG_TERTIARY).fontColor(AppTheme.TEXT_TERTIARY).borderRadius(22).enabled(false)
      }

      if (this.isRegistered) {
        Button('评价').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.PRIMARY_COLOR).backgroundColor('#FFFFFF')
          .border({ width: 1, color: AppTheme.PRIMARY_COLOR }).borderRadius(22)
          .onClick(() => { this.showReviewDialog = true; })
      }

      if (!this.isRegistered && !this.canRegister && !userStore.isLeader) {
        Button('报名已截止').layoutWeight(1).height(44).fontSize(14)
          .backgroundColor(AppTheme.BG_TERTIARY).fontColor(AppTheme.TEXT_TERTIARY).borderRadius(22).enabled(false)
      }
    }
    .width('100%').padding({ left: 16, right: 16, top: 12, bottom: 16 })
    .backgroundColor(AppTheme.BG_PRIMARY)
    .shadow({ radius: 8, color: 'rgba(0,0,0,0.08)', offsetY: -2 })
  }
}
