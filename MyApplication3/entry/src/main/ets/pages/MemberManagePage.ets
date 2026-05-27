import { RouterUtil } from '../utils/RouterUtil';
import { MockDataService } from '../services/MockDataService';
import { ClubMember, ClubInfo } from '../models/ClubModel';
import { AppTheme } from '../theme/AppTheme';
import { Constants } from '../common/Constants';
import { userStore } from '../store/UserStore';
import { ClubIdRouteParam } from '../models/RouteParams';
import { IconUtil } from '../utils/IconUtil';

@Entry
@Component
struct MemberManagePage {
  @State private clubId: string = '';
  @State private club: ClubInfo | null = null;
  @State private members: ClubMember[] = [];
  @State private isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const params = RouterUtil.getParams() as ClubIdRouteParam;
    this.clubId = params.clubId || userStore.clubId;
    
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
    } catch (error) {
      console.error('Load members failed:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  async removeMember(member: ClubMember): Promise<void> {
    try {
      await MockDataService.removeClubMember(this.clubId, member.id);
      // 重新加载数据
      await this.loadData();
    } catch (error) {
      console.error('Remove member failed:', JSON.stringify(error));
    }
  }

  @State private showAddMemberDialog: boolean = false;
  @State private newMemberName: string = '';
  @State private newMemberStudentId: string = '';

  async addMember(): Promise<void> {
    this.showAddMemberDialog = true;
  }

  async handleAddMember(): Promise<void> {
    if (!this.newMemberName.trim() || !this.newMemberStudentId.trim()) return;
    try {
      await MockDataService.addClubMember(
        this.clubId,
        this.club?.name || '',
        this.newMemberName,
        this.newMemberStudentId
      );
      this.showAddMemberDialog = false;
      this.newMemberName = '';
      this.newMemberStudentId = '';
      await this.loadData();
    } catch (error) {
      console.error('Add member failed:', JSON.stringify(error));
    }
  }

  build() {
    Stack() {
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

        Text('成员管理')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Image(IconUtil.ADD)
          .width(24)
          .height(24)
          .fillColor(AppTheme.PRIMARY_COLOR)
          .onClick(() => {
            this.addMember();
          })
      }
      .width('100%')
      .height(90)
      .padding({ left: 16, right: 16, top: 36 })

      // 社团信息
      if (this.club) {
        Row() {
          Image(this.club.logo || 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=100&h=100&fit=crop')
            .width(50)
            .height(50)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)

          Column() {
            Text(this.club.name)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppTheme.TEXT_PRIMARY)

            Text(`共 ${this.members.length} 名成员`)
              .fontSize(13)
              .fontColor(AppTheme.TEXT_TERTIARY)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(AppTheme.BG_PRIMARY)
        .margin({ left: 16, right: 16, top: 8, bottom: 8 })
      }

      // 成员列表
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
      } else if (this.members.length === 0) {
        Row() {
          Column() {
            Image(IconUtil.EMPTY)
              .width(80)
              .height(80)
              .fillColor(AppTheme.TEXT_TERTIARY)
              .margin({ bottom: 16 })

            Text('暂无成员')
              .fontSize(16)
              .fontColor(AppTheme.TEXT_TERTIARY)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.members, (member: ClubMember) => {
            ListItem() {
              this.MemberItem(member)
            }
          }, (member: ClubMember) => member.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BG_SECONDARY)

      if (this.showAddMemberDialog) {
        Column()
          .width('100%').height('100%').backgroundColor('#80000000')
          .onClick(() => { this.showAddMemberDialog = false; })
          .position({ x: 0, y: 0 })
        Column({ space: 14 }) {
          Text('添加成员').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppTheme.TEXT_PRIMARY)
          TextInput({ placeholder: '成员姓名', text: this.newMemberName })
            .width('100%').height(46).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.newMemberName = v; })
          TextInput({ placeholder: '学号', text: this.newMemberStudentId })
            .width('100%').height(46).backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
            .onChange((v: string) => { this.newMemberStudentId = v; })
          Row({ space: 12 }) {
            Button('取消').layoutWeight(1).height(42).fontColor(AppTheme.TEXT_SECONDARY)
              .backgroundColor(AppTheme.BG_SECONDARY).borderRadius(10)
              .onClick(() => { this.showAddMemberDialog = false; })
            Button('添加').layoutWeight(1).height(42).fontColor('#FFFFFF')
              .backgroundColor(AppTheme.PRIMARY_COLOR).borderRadius(10)
              .onClick(() => { this.handleAddMember(); })
          }.width('100%')
        }.width('85%').padding(20).backgroundColor('#FFFFFF').borderRadius(16)
          .position({ x: '7.5%', y: '30%' })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  MemberItem(member: ClubMember) {
    Row() {
      Image(member.userAvatar || 'https://i.pravatar.cc/150')
        .width(50)
        .height(50)
        .objectFit(ImageFit.Cover)
        .borderRadius(25)

      Column() {
        Text(member.userName)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppTheme.TEXT_PRIMARY)

        Row() {
          Text(member.role === 'leader' ? '社长' : member.role === 'vice_leader' ? '副社长' : '成员')
            .fontSize(12)
            .fontColor(member.role === 'leader' ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_TERTIARY)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(AppTheme.BG_TERTIARY)
            .borderRadius(4)

          Text(member.studentId)
            .fontSize(12)
            .fontColor(AppTheme.TEXT_TERTIARY)
            .margin({ left: 8 })
        }
        .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })

      if (member.role !== 'leader') {
        Image(IconUtil.DELETE)
          .width(24)
          .height(24)
          .fillColor(AppTheme.ERROR)
          .onClick(() => {
            this.removeMember(member);
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(AppTheme.BG_PRIMARY)
    .borderRadius(12)
  }
}
