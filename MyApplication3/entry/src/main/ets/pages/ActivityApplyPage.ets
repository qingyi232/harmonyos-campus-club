import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService, ClubQueryParams } from '../services/MockDataService';
import { ActivityApplyRequest } from '../models/ActivityModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { userStore } from '../store/UserStore';
import { ClubInfo } from '../models/ClubModel';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ActivityApplyPage {
  @State private clubs: ClubInfo[] = [];
  @State private selectedClubId: string = '';
  @State private title: string = '';
  @State private description: string = '';
  @State private location: string = '';
  @State private startTime: number = 0;
  @State private endTime: number = 0;
  @State private maxParticipants: number = 50;
  @State private coverImage: string = '';
  @State private tags: string[] = [];
  @State private tagInput: string = '';
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';
  @State private showStartTimePicker: boolean = false;
  @State private showEndTimePicker: boolean = false;

  async aboutToAppear(): Promise<void> {
    // 获取用户管理的社团
    if (userStore.isLeader && userStore.clubId) {
      this.selectedClubId = userStore.clubId;
    }
    
    // 加载社团列表
    try {
      const params = new ClubQueryParams();
      params.status = 'approved';
      const data = await MockDataService.getClubList(params);
      this.clubs = data;
    } catch (error) {
      console.error('Load clubs failed:', JSON.stringify(error));
    }
  }

  async handleApply(): Promise<void> {
    // 表单验证
    if (!this.selectedClubId) {
      this.errorMessage = '请选择所属社团';
      return;
    }
    if (!this.title.trim()) {
      this.errorMessage = '请输入活动标题';
      return;
    }
    if (!this.description.trim()) {
      this.errorMessage = '请输入活动描述';
      return;
    }
    if (this.description.length < 20) {
      this.errorMessage = '活动描述至少20个字符';
      return;
    }
    if (!this.location.trim()) {
      this.errorMessage = '请输入活动地点';
      return;
    }
    if (this.startTime === 0) {
      this.errorMessage = '请选择开始时间';
      return;
    }
    if (this.endTime === 0) {
      this.errorMessage = '请选择结束时间';
      return;
    }
    if (this.endTime <= this.startTime) {
      this.errorMessage = '结束时间必须晚于开始时间';
      return;
    }
    if (this.maxParticipants < 1) {
      this.errorMessage = '参与人数至少为1';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      const request: ActivityApplyRequest = new ActivityApplyRequest();
      request.clubId = this.selectedClubId;
      request.title = this.title;
      request.description = this.description;
      request.coverImage = this.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop';
      request.location = this.location;
      request.startTime = this.startTime;
      request.endTime = this.endTime;
      request.maxParticipants = this.maxParticipants;
      request.tags = this.tags;

      await MockDataService.applyActivity(userStore.userId, userStore.userName, request);

      // 申请成功，返回上一页
      await RouterUtil.back();
    } catch (error) {
      this.errorMessage = error.message || '申请失败，请重试';
    } finally {
      this.isLoading = false;
    }
  }

  addTag(): void {
    const tag = this.tagInput.trim();
    if (tag && !this.tags.includes(tag)) {
      if (this.tags.length >= 5) {
        this.errorMessage = '最多添加5个标签';
        return;
      }
      this.tags.push(tag);
      this.tagInput = '';
      this.errorMessage = '';
    }
  }

  removeTag(index: number): void {
    this.tags.splice(index, 1);
  }

  selectStartTime(): void {
    // 简化实现：默认设置为7天后
    this.startTime = Date.now() + 7 * 24 * 60 * 60 * 1000;
    this.errorMessage = '';
  }

  selectEndTime(): void {
    // 简化实现：默认设置为开始时间后2小时
    if (this.startTime > 0) {
      this.endTime = this.startTime + 2 * 60 * 60 * 1000;
      this.errorMessage = '';
    }
  }

  build() {
    Scroll() {
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

          Text('创建活动')
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

        // 表单内容
        Column() {
          // 所属社团
          Column() {
            Text('所属社团')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            if (this.clubs.length > 0) {
              Column() {
                ForEach(this.clubs, (club: ClubInfo) => {
                  Row() {
                    Image(club.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=50&h=50&fit=crop')
                      .width(40)
                      .height(40)
                      .objectFit(ImageFit.Cover)
                      .borderRadius(8)

                    Text(club.name)
                      .fontSize(15)
                      .fontColor(AppTheme.TEXT_PRIMARY)
                      .layoutWeight(1)
                      .margin({ left: 12 })

                    if (this.selectedClubId === club.id) {
                      Image(IconUtil.OK)
                        .width(20)
                        .height(20)
                        .fillColor(AppTheme.PRIMARY_COLOR)
                    }
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor(this.selectedClubId === club.id ? AppTheme.BG_TERTIARY : Color.Transparent)
                  .borderRadius(8)
                  .onClick(() => {
                    this.selectedClubId = club.id;
                    this.errorMessage = '';
                  })
                })
              }
              .width('100%')
            }
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 活动标题
          this.InputField('活动标题', '请输入活动标题', this.title, (value: string) => {
            this.title = value;
            this.errorMessage = '';
          })

          // 活动描述
          Column() {
            Text('活动描述')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            TextArea({ placeholder: '请输入活动描述（至少20个字符）', text: this.description })
              .placeholderColor(AppTheme.TEXT_TERTIARY)
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .backgroundColor(AppTheme.BG_TERTIARY)
              .borderRadius(12)
              .height(120)
              .padding(12)
              .onChange((value: string) => {
                this.description = value;
                this.errorMessage = '';
              })

            Text(`${this.description.length}/500`)
              .fontSize(12)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .width('100%')
              .textAlign(TextAlign.End)
              .margin({ top: 4 })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 活动地点
          this.InputField('活动地点', '请输入活动地点', this.location, (value: string) => {
            this.location = value;
            this.errorMessage = '';
          })

          // 时间选择
          Row() {
            Column() {
              Text('开始时间')
                .fontSize(14)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .width('100%')
                .margin({ bottom: 8 })

              Row() {
                Text(this.startTime > 0 ? CommonUtil.formatTimestamp(this.startTime, 'MM-DD HH:mm') : '请选择开始时间')
                  .fontSize(14)
                  .fontColor(this.startTime > 0 ? AppTheme.TEXT_PRIMARY : AppTheme.TEXT_TERTIARY)
                  .layoutWeight(1)

                Image(IconUtil.ARROW_RIGHT)
                  .width(16)
                  .height(16)
                  .fillColor(AppTheme.TEXT_TERTIARY)
              }
              .width('100%')
              .height(50)
              .padding({ left: 16, right: 16 })
              .backgroundColor(AppTheme.BG_TERTIARY)
              .borderRadius(12)
              .onClick(() => {
                this.selectStartTime();
              })
            }
            .layoutWeight(1)
            .margin({ right: 8 })

            Column() {
              Text('结束时间')
                .fontSize(14)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .width('100%')
                .margin({ bottom: 8 })

              Row() {
                Text(this.endTime > 0 ? CommonUtil.formatTimestamp(this.endTime, 'MM-DD HH:mm') : '请选择结束时间')
                  .fontSize(14)
                  .fontColor(this.endTime > 0 ? AppTheme.TEXT_PRIMARY : AppTheme.TEXT_TERTIARY)
                  .layoutWeight(1)

                Image(IconUtil.ARROW_RIGHT)
                  .width(16)
                  .height(16)
                  .fillColor(AppTheme.TEXT_TERTIARY)
              }
              .width('100%')
              .height(50)
              .padding({ left: 16, right: 16 })
              .backgroundColor(AppTheme.BG_TERTIARY)
              .borderRadius(12)
              .onClick(() => {
                this.selectEndTime();
              })
            }
            .layoutWeight(1)
            .margin({ left: 8 })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 参与人数
          Column() {
            Row() {
              Text('参与人数')
                .fontSize(14)
                .fontColor(AppTheme.TEXT_PRIMARY)

              Blank()

              Row() {
                Button('-')
                  .width(36)
                  .height(36)
                  .fontSize(18)
                  .backgroundColor(AppTheme.BG_TERTIARY)
                  .fontColor(AppTheme.TEXT_PRIMARY)
                  .onClick(() => {
                    if (this.maxParticipants > 1) {
                      this.maxParticipants--;
                    }
                  })

                Text(`${this.maxParticipants}`)
                  .fontSize(16)
                  .fontColor(AppTheme.TEXT_PRIMARY)
                  .width(60)
                  .textAlign(TextAlign.Center)

                Button('+')
                  .width(36)
                  .height(36)
                  .fontSize(18)
                  .backgroundColor(AppTheme.BG_TERTIARY)
                  .fontColor(AppTheme.TEXT_PRIMARY)
                  .onClick(() => {
                    if (this.maxParticipants < 500) {
                      this.maxParticipants++;
                    }
                  })
              }
            }
            .width('100%')
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 活动标签
          Column() {
            Text('活动标签')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            // 已添加的标签
            if (this.tags.length > 0) {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.tags, (tag: string, index: number) => {
                  Row() {
                    Text(tag)
                      .fontSize(13)
                      .fontColor(AppTheme.TEXT_PRIMARY)

                    Image(IconUtil.CANCEL)
                      .width(16)
                      .height(16)
                      .fillColor(AppTheme.TEXT_TERTIARY)
                      .margin({ left: 4 })
                      .onClick(() => {
                        this.removeTag(index);
                      })
                  }
                  .padding({ left: 10, right: 10, top: 6, bottom: 6 })
                  .backgroundColor(AppTheme.BG_TERTIARY)
                  .borderRadius(16)
                  .margin({ right: 8, bottom: 8 })
                })
              }
              .width('100%')
              .margin({ bottom: 8 })
            }

            // 添加标签输入框
            Row() {
              TextInput({ placeholder: '输入标签', text: this.tagInput })
                .type(InputType.Normal)
                .placeholderColor(AppTheme.TEXT_TERTIARY)
                .fontSize(14)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .backgroundColor(AppTheme.BG_TERTIARY)
                .borderRadius(20)
                .layoutWeight(1)
                .height(40)
                .padding({ left: 16, right: 16 })
                .onChange((value: string) => {
                  this.tagInput = value;
                })

              Button('添加')
                .fontSize(14)
                .backgroundColor(AppTheme.PRIMARY_COLOR)
                .fontColor(AppTheme.TEXT_WHITE)
                .height(40)
                .padding({ left: 16, right: 16 })
                .borderRadius(20)
                .margin({ left: 8 })
                .onClick(() => {
                  this.addTag();
                })
            }
            .width('100%')
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 错误提示
          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(12)
              .fontColor(AppTheme.ERROR)
              .width('100%')
              .margin({ bottom: 16 })
          }

          // 提交按钮
          Button(this.isLoading ? '提交中...' : '提交申请')
            .width('100%')
            .height(50)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.PRIMARY_COLOR)
            .fontColor(AppTheme.TEXT_WHITE)
            .borderRadius(12)
            .enabled(!this.isLoading)
            .opacity(this.isLoading ? 0.6 : 1)
            .onClick(() => {
              this.handleApply();
            })

          // 提示信息
          Text('提交后需要等待管理员审核，审核通过后活动将正式发布')
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 16 })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 20, bottom: 20 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_PRIMARY)
  }

  @Builder
  InputField(label: string, placeholder: string, value: string, onChange: (value: string) => void) {
    Column() {
      Text(label)
        .fontSize(14)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 8 })

      TextInput({ placeholder: placeholder, text: value })
        .type(InputType.Normal)
        .placeholderColor(AppTheme.TEXT_TERTIARY)
        .fontSize(16)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .backgroundColor(AppTheme.BG_TERTIARY)
        .borderRadius(12)
        .height(50)
        .padding({ left: 16, right: 16 })
        .onChange(onChange)
    }
    .width('100%')
    .margin({ bottom: 16 })
  }
}
