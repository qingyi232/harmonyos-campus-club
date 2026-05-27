import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { ClubApplyRequest } from '../models/ClubModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { userStore } from '../store/UserStore';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ClubApplyPage {
  @State private name: string = '';
  @State private category: string = '';
  @State private description: string = '';
  @State private logo: string = '';
  @State private tags: string[] = [];
  @State private tagInput: string = '';
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';

  private categories: string[] = CommonUtil.getClubCategories();

  async handleApply(): Promise<void> {
    // 表单验证
    if (!this.name.trim()) {
      this.errorMessage = '请输入社团名称';
      return;
    }
    if (!this.category) {
      this.errorMessage = '请选择社团分类';
      return;
    }
    if (!this.description.trim()) {
      this.errorMessage = '请输入社团简介';
      return;
    }
    if (this.description.length < 20) {
      this.errorMessage = '社团简介至少20个字符';
      return;
    }
    if (this.tags.length === 0) {
      this.errorMessage = '请至少添加一个标签';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      const request: ClubApplyRequest = new ClubApplyRequest();
      request.name = this.name;
      request.category = this.category;
      request.description = this.description;
      request.logo = this.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=200&h=200&fit=crop';
      request.tags = this.tags;

      await MockDataService.applyClub(userStore.userId, request);

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

          Text('创建社团')
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
          // 社团名称
          this.InputField('社团名称', '请输入社团名称', this.name, (value: string) => {
            this.name = value;
            this.errorMessage = '';
          })

          // 社团分类
          Column() {
            Text('社团分类')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            Grid() {
              ForEach(this.categories, (cat: string) => {
                GridItem() {
                  Text(cat)
                    .fontSize(14)
                    .fontColor(this.category === cat ? AppTheme.TEXT_WHITE : AppTheme.TEXT_PRIMARY)
                    .padding({ left: 16, right: 16, top: 10, bottom: 10 })
                    .backgroundColor(this.category === cat ? AppTheme.PRIMARY_COLOR : AppTheme.BG_TERTIARY)
                    .borderRadius(8)
                    .textAlign(TextAlign.Center)
                    .onClick(() => {
                      this.category = cat;
                      this.errorMessage = '';
                    })
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(8)
            .columnsGap(8)
            .width('100%')
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 社团简介
          Column() {
            Text('社团简介')
              .fontSize(14)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .width('100%')
              .margin({ bottom: 8 })

            TextArea({ placeholder: '请输入社团简介（至少20个字符）', text: this.description })
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

            Text(`${this.description.length}/200`)
              .fontSize(12)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .width('100%')
              .textAlign(TextAlign.End)
              .margin({ top: 4 })
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 社团标签
          Column() {
            Text('社团标签')
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
          Text('提交后需要等待管理员审核，审核通过后社团将正式成立')
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
