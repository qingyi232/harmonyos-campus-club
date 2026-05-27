import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { ClubInfo, ClubMember } from '../models/ClubModel';
import { FinanceRecord } from '../models/FinanceModel';
import { AppTheme } from '../theme/AppTheme';
import { CommonUtil } from '../utils/CommonUtil';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct ClubDetailPage {
  @State private clubId: string = '';
  @State private club: ClubInfo | null = null;
  @State private members: ClubMember[] = [];
  @State private isLoading: boolean = true;
  @State private isJoined: boolean = false;
  @State private showEditDialog: boolean = false;
  @State private editDescription: string = '';
  @State private editContact: string = '';
  @State private showFinanceDialog: boolean = false;
  @State private financeRecords: FinanceRecord[] = [];

  async aboutToAppear(): Promise<void> {
    const params = RouterUtil.getParams() as ClubIdRouteParam;
    this.clubId = params.clubId || '';
    
    if (this.clubId) {
      await this.loadData();
    }
  }

  async loadData(): Promise<void> {
    this.isLoading = true;
    try {
      const results = await Promise.all([
        MockDataService.getClubDetail(this.clubId),
        MockDataService.getClubMembers(this.clubId)
      ]);
      this.club = results[0];
      this.members = results[1];
      
      // 检查是否已加入
      this.isJoined = results[1].some(m => m.userId === userStore.userId);
    } catch (error) {
      console.error('Load club detail failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  // 加入/退出社团处理
  async handleJoinOrLeave(): Promise<void> {
    try {
      if (this.isJoined) {
        // 退出社团
        await MockDataService.leaveClub(userStore.userId, this.clubId);
        this.isJoined = false;
      } else {
        // 加入社团
        await MockDataService.joinClub(userStore.userId, userStore.userName, userStore.userAvatar, this.clubId);
        this.isJoined = true;
      }
      // 重新加载数据
      await this.loadData();
    } catch (error) {
      console.error('Join/Leave club failed:', JSON.stringify(error));
      // 显示错误提示
      this.showErrorToast(error.message || '操作失败，请重试');
    }
  }

  showErrorToast(message: string): void {
    console.error('Error:', message);
  }

  async handleEditClub(): Promise<void> {
    if (!this.editDescription.trim()) return;
    try {
      await MockDataService.updateClubInfo(this.clubId, this.editDescription, this.editContact);
      this.showEditDialog = false;
      await this.loadData();
    } catch (error) {
      console.error('Update club failed:', JSON.stringify(error));
    }
  }

  async loadFinanceForStudent(): Promise<void> {
    try {
      const data = await MockDataService.getFinanceStatistics(this.clubId);
      this.financeRecords = [];
      if (data) {
        data.incomeRecords.forEach((r: FinanceRecord) => { this.financeRecords.push(r); });
        data.expenseRecords.forEach((r: FinanceRecord) => { this.financeRecords.push(r); });
      }
      this.showFinanceDialog = true;
    } catch (error) {
      console.error('Load finance failed:', JSON.stringify(error));
    }
  }

  build() {
    Stack() {
      Column() {
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
        } else if (this.club) {
          Scroll() {
            Column() {
              this.ClubHeader()
              this.ClubDescription()
              if (this.club.tags && this.club.tags.length > 0) {
                this.ClubTags()
              }
              if (this.club.images && this.club.images.length > 0) {
                this.ClubImages()
              }
              this.MembersSection()
              this.ActionButtons()
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(AppTheme.BG_SECONDARY)

      if (this.showEditDialog) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showEditDialog = false; })
          .position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Text('编辑社团信息').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
          Text('社团简介').fontSize(13).fontColor(AppTheme.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
          TextArea({ placeholder: '请输入社团简介...', text: this.editDescription })
            .width('100%').height(120).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.editDescription = v; })
          Text('联系方式').fontSize(13).fontColor(AppTheme.TEXT_SECONDARY).alignSelf(ItemAlign.Start)
          TextInput({ placeholder: '联系方式（如QQ群、微信等）', text: this.editContact })
            .width('100%').height(46).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.editContact = v; })
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppTheme.TEXT_SECONDARY)
              .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .onClick(() => { this.showEditDialog = false; })
            Button('保存').layoutWeight(1).height(42).fontColor('#FFFFFF')
              .backgroundColor(AppTheme.PRIMARY_COLOR).borderRadius(10)
              .onClick(() => { this.handleEditClub(); })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '25%' })
      }

      if (this.showFinanceDialog) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showFinanceDialog = false; })
          .position({ x: 0, y: 0 })
        Column({ space: 12 }) {
          Row() {
            Text('经费明细').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
            Blank()
            Text('✕').fontSize(20).fontColor(AppTheme.TEXT_SECONDARY)
              .onClick(() => { this.showFinanceDialog = false; })
          }.width('100%')
          Text('以下为本社团公开的经费收支明细，操作人信息已隐藏。').fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
          Scroll() {
            Column({ space: 8 }) {
              ForEach(this.financeRecords as FinanceRecord[], (record: FinanceRecord) => {
                Row({ space: 10 }) {
                  Text(record.type === 'income' ? '📈' : '📉').fontSize(20)
                  Column({ space: 2 }) {
                    Text(record.description).fontSize(14).fontColor(AppTheme.TEXT_PRIMARY)
                    Text(record.category + ' · ' + CommonUtil.formatTimestamp(record.createTime, 'MM-DD'))
                      .fontSize(12).fontColor(AppTheme.TEXT_TERTIARY)
                  }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                  Text((record.type === 'income' ? '+' : '-') + '¥' + record.amount.toString())
                    .fontSize(14).fontWeight(FontWeight.Bold)
                    .fontColor(record.type === 'income' ? AppTheme.SUCCESS : AppTheme.ERROR)
                }.width('100%').padding(10).backgroundColor(AppTheme.BG_TERTIARY).borderRadius(10)
              })
            }
          }.height(300)
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '15%' })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ClubHeader() {
    Column() {
      // 顶部导航
      Row() {
        Image(IconUtil.ARROW_LEFT)
          .width(24)
          .height(24)
          .fillColor(AppTheme.TEXT_WHITE)
          .onClick(() => {
            RouterUtil.back();
          })

        Text('社团详情')
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

      // 社团基本信息
      Row() {
        Image(this.club?.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=200&h=200&fit=crop')
          .width(80)
          .height(80)
          .objectFit(ImageFit.Cover)
          .borderRadius(16)
          .border({ width: 3, color: AppTheme.TEXT_WHITE })

        Column() {
          Text(this.club?.name || '')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppTheme.TEXT_WHITE)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Row() {
            Text(this.club?.category || '')
              .fontSize(13)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.9)

            Text(`· ${this.club?.memberCount || 0}人`)
              .fontSize(13)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.9)
              .margin({ left: 8 })
          }
          .margin({ top: 6 })

          Row() {
            Image(IconUtil.PERSON)
              .width(14)
              .height(14)
              .fillColor(AppTheme.TEXT_WHITE)
              .opacity(0.8)

            Text(`社长：${this.club?.leaderName || ''}`)
              .fontSize(13)
              .fontColor(AppTheme.TEXT_WHITE)
              .opacity(0.9)
              .margin({ left: 4 })
          }
          .margin({ top: 6 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 20 })
    }
    .width('100%')
    .backgroundColor(AppTheme.PRIMARY_COLOR)
    .borderRadius({ bottomLeft: 24, bottomRight: 24 })
  }

  @Builder
  ClubDescription() {
    Column() {
      Text('社团简介')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Text(this.club?.description || '')
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
  ClubTags() {
    Column() {
      Text('社团标签')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.club?.tags || [], (tag: string) => {
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
  ClubImages() {
    Column() {
      Text('社团风采')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .width('100%')
        .margin({ bottom: 12 })

      Swiper() {
        ForEach(this.club?.images || [], (image: string) => {
          Image(image)
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Cover)
            .borderRadius(12)
        })
      }
      .width('100%')
      .height(200)
      .loop(true)
      .autoPlay(true)
      .interval(3000)
      .indicator(true)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(16)
    .margin({ left: 16, right: 16, top: 16 })
  }

  @Builder
  MembersSection() {
    Column() {
      Row() {
        Text('社团成员')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)

        Text(`共${this.members.length}人`)
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
      }
      .width('100%')
      .margin({ bottom: 12 })

      if (this.members.length === 0) {
        Text('暂无成员')
          .fontSize(14)
          .fontColor(AppTheme.TEXT_TERTIARY)
          .width('100%')
          .height(60)
          .textAlign(TextAlign.Center)
      } else {
        Column() {
          ForEach(this.members.slice(0, 10), (member: ClubMember) => {
            Row() {
              Image(member.userAvatar || 'https://i.pravatar.cc/150')
                .width(40)
                .height(40)
                .objectFit(ImageFit.Cover)
                .borderRadius(20)

              Column() {
                Text(member.userName)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppTheme.TEXT_PRIMARY)

                Text(member.role === 'leader' ? '社长' : member.role === 'vice_leader' ? '副社长' : '成员')
                  .fontSize(12)
                  .fontColor(member.role === 'leader' ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)
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
  ActionButtons() {
    Column({ space: 10 }) {
      if (this.club?.leaderId === userStore.userId) {
        Row({ space: 10 }) {
          Button('管理社团').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.BG_TERTIARY).fontColor(AppTheme.TEXT_PRIMARY).borderRadius(22)
            .onClick(() => { RouterUtil.push(Constants.ROUTE_MEMBER_MANAGE, new ClubIdRouteParam(this.clubId)); })
          Button('编辑信息').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.BG_TERTIARY).fontColor(AppTheme.TEXT_PRIMARY).borderRadius(22)
            .onClick(() => {
              this.editDescription = this.club?.description || '';
              this.editContact = this.club?.contactInfo || '';
              this.showEditDialog = true;
            })
          Button('经费管理').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
            .backgroundColor(AppTheme.BG_TERTIARY).fontColor(AppTheme.TEXT_PRIMARY).borderRadius(22)
            .onClick(() => { RouterUtil.push(Constants.ROUTE_FINANCE_MANAGE, new ClubIdRouteParam(this.clubId)); })
        }.width('100%')
      }

      Row({ space: 10 }) {
        if (this.isJoined) {
          Button('查看经费').layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
            .fontColor(AppTheme.PRIMARY_COLOR).backgroundColor('#FFFFFF')
            .border({ width: 1, color: AppTheme.PRIMARY_COLOR }).borderRadius(22)
            .onClick(() => { this.loadFinanceForStudent(); })
        }
        Button(this.isJoined ? '退出社团' : '加入社团')
          .layoutWeight(1).height(44).fontSize(14).fontWeight(FontWeight.Medium)
          .backgroundColor(this.isJoined ? AppTheme.BG_TERTIARY : AppTheme.PRIMARY_COLOR)
          .fontColor(this.isJoined ? AppTheme.TEXT_PRIMARY : '#FFFFFF').borderRadius(22)
          .onClick(async () => { await this.handleJoinOrLeave(); })
      }.width('100%')
    }
    .width('100%').padding({ left: 16, right: 16, bottom: 16 })
  }
}
