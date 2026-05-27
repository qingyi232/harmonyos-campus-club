// 用户管理页面 - 管理员端
import { AppColors, AppFontSize, AppRadius } from '../../common/constants/AppConstants'
import { RouterUtil } from '../../common/utils/RouterUtil'
import DataService from '../../service/DataService'
import { UserInfo, UserRole } from '../../model/DataModels'

@Entry
@Component
struct UserManagePage {
  @State users: UserInfo[] = []
  @State filteredUsers: UserInfo[] = []
  @State selectedRole: string = '全部'
  @State searchKeyword: string = ''
  @State isLoading: boolean = true
  private dataService: DataService = DataService.getInstance()

  aboutToAppear() { this.loadData() }

  async loadData() {
    this.isLoading = true
    // 从数据服务获取所有用户（真实从后端获取）
    this.users = await this.dataService.getUsers()
    this.filteredUsers = [...this.users]
    this.isLoading = false
  }

  filterUsers() {
    let result = [...this.users]
    if (this.selectedRole !== '全部') {
      const roleMap: Record<string, UserRole> = { '学生': UserRole.STUDENT, '社团负责人': UserRole.LEADER, '管理员': UserRole.ADMIN }
      const role = roleMap[this.selectedRole]
      if (role) result = result.filter(u => u.role === role)
    }
    if (this.searchKeyword) {
      const kw = this.searchKeyword.toLowerCase()
      result = result.filter(u => u.realName.toLowerCase().includes(kw) || u.studentId.includes(kw) || u.username.toLowerCase().includes(kw))
    }
    this.filteredUsers = result
  }

  getRoleText(role: UserRole): string {
    switch (role) {
      case UserRole.ADMIN: return '管理员'
      case UserRole.LEADER: return '社团负责人'
      default: return '学生'
    }
  }

  getRoleColor(role: UserRole): string {
    switch (role) {
      case UserRole.ADMIN: return AppColors.DANGER
      case UserRole.LEADER: return AppColors.WARNING
      default: return AppColors.PRIMARY
    }
  }

  build() {
    Column() {
      Row() {
        Text('←').fontSize(24).fontColor(AppColors.TEXT_PRIMARY)
          .onClick(() => { RouterUtil.back() }).padding(10)
        Text('用户管理').fontSize(AppFontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
        Text('').width(44)
      }.width('100%').height(56).padding({ left: 12, right: 12 }).backgroundColor(Color.White)

      // 搜索
      Row() {
        Text('🔍').fontSize(16).margin({ right: 8 })
        TextInput({ placeholder: '搜索姓名/学号/用户名', text: this.searchKeyword })
          .layoutWeight(1).backgroundColor(Color.Transparent).fontSize(AppFontSize.BODY)
          .onChange((val: string) => { this.searchKeyword = val; this.filterUsers() })
      }
      .width('92%').height(44).padding({ left: 14, right: 14 })
      .backgroundColor(Color.White).borderRadius(AppRadius.ROUND)
      .margin({ top: 12 }).border({ width: 1, color: AppColors.BORDER })

      // 角色筛选
      Row({ space: 8 }) {
        ForEach(['全部', '学生', '社团负责人', '管理员'], (role: string) => {
          Text(role).fontSize(AppFontSize.CAPTION)
            .fontColor(this.selectedRole === role ? Color.White : AppColors.TEXT_PRIMARY)
            .backgroundColor(this.selectedRole === role ? AppColors.PRIMARY : Color.White)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(AppRadius.ROUND).border({ width: 1, color: this.selectedRole === role ? AppColors.PRIMARY : AppColors.BORDER })
            .onClick(() => { this.selectedRole = role; this.filterUsers() })
        })
      }.width('92%').margin({ top: 10 })

      // 统计
      Text(`共 ${this.filteredUsers.length} 名用户`)
        .fontSize(AppFontSize.CAPTION).fontColor(AppColors.TEXT_HINT)
        .alignSelf(ItemAlign.Start).margin({ left: 20, top: 10 })

      // 用户列表
      List({ space: 8 }) {
        ForEach(this.filteredUsers, (user: UserInfo) => {
          ListItem() {
            Row({ space: 12 }) {
              Image(user.avatar).width(48).height(48).borderRadius(24).objectFit(ImageFit.Cover)
              Column({ space: 3 }) {
                Row({ space: 8 }) {
                  Text(user.realName).fontSize(AppFontSize.BODY).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Text(this.getRoleText(user.role)).fontSize(10).fontColor(Color.White)
                    .backgroundColor(this.getRoleColor(user.role))
                    .padding({ left: 8, right: 8, top: 2, bottom: 2 }).borderRadius(AppRadius.ROUND)
                }
                Text(`学号: ${user.studentId} · ${user.college}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
                Text(`${user.major} · ${user.grade}`).fontSize(AppFontSize.SMALL).fontColor(AppColors.TEXT_HINT)
              }.layoutWeight(1).alignItems(HorizontalAlign.Start)
            }
            .width('100%').padding(14).backgroundColor(Color.White).borderRadius(AppRadius.MD)
          }
        })
      }.layoutWeight(1).padding({ left: 16, right: 16, top: 8 }).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor(AppColors.BG_PAGE)
  }
}
