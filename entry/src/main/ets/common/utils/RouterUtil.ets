// 路由工具类
import { router } from '@kit.ArkUI'

export class RouterUtil {
  static pushUrl(url: string, params?: Record<string, Object>): void {
    router.pushUrl({
      url: url,
      params: params
    }).catch((err: Error) => {
      console.error(`[Router] 跳转失败: ${err.message}`)
    })
  }

  static back(): void {
    router.back()
  }

  static replaceUrl(url: string, params?: Record<string, Object>): void {
    router.replaceUrl({
      url: url,
      params: params
    }).catch((err: Error) => {
      console.error(`[Router] 替换失败: ${err.message}`)
    })
  }

  static getParams(): Record<string, Object> {
    return router.getParams() as Record<string, Object> || {}
  }
}

// 页面路由常量
export class PageRoutes {
  // 认证
  static readonly LOGIN: string = 'pages/auth/LoginPage'
  static readonly REGISTER: string = 'pages/auth/RegisterPage'
  // 学生端
  static readonly STUDENT_HOME: string = 'pages/student/StudentHomePage'
  static readonly STUDENT_CLUBS: string = 'pages/student/ClubListPage'
  static readonly STUDENT_ACTIVITIES: string = 'pages/student/ActivityListPage'
  static readonly STUDENT_MY_CLUBS: string = 'pages/student/MyClubsPage'
  static readonly STUDENT_PROFILE: string = 'pages/student/ProfilePage'
  static readonly STUDENT_RECRUITMENT: string = 'pages/student/RecruitmentPage'
  static readonly STUDENT_APPLY_CLUB: string = 'pages/student/ApplyClubPage'
  static readonly STUDENT_CLUB_FINANCE: string = 'pages/student/ClubFinanceViewPage'
  static readonly CLUB_DETAIL: string = 'pages/common/ClubDetailPage'
  static readonly ACTIVITY_DETAIL: string = 'pages/common/ActivityDetailPage'
  // 社团负责人端
  static readonly LEADER_HOME: string = 'pages/leader/LeaderHomePage'
  static readonly LEADER_CLUB_MANAGE: string = 'pages/leader/ClubManagePage'
  static readonly LEADER_ACTIVITY_MANAGE: string = 'pages/leader/ActivityManagePage'
  static readonly LEADER_MEMBER_MANAGE: string = 'pages/leader/MemberManagePage'
  static readonly LEADER_FINANCE: string = 'pages/leader/FinancePage'
  static readonly LEADER_CREATE_ACTIVITY: string = 'pages/leader/CreateActivityPage'
  static readonly LEADER_EDIT_CLUB: string = 'pages/leader/EditClubPage'
  static readonly LEADER_RECRUIT_MANAGE: string = 'pages/leader/RecruitManagePage'
  // 管理员端
  static readonly ADMIN_HOME: string = 'pages/admin/AdminHomePage'
  static readonly ADMIN_CLUB_APPROVAL: string = 'pages/admin/ClubApprovalPage'
  static readonly ADMIN_ACTIVITY_APPROVAL: string = 'pages/admin/ActivityApprovalPage'
  static readonly ADMIN_FINANCE_OVERVIEW: string = 'pages/admin/FinanceOverviewPage'
  static readonly ADMIN_STATISTICS: string = 'pages/admin/StatisticsPage'
  static readonly ADMIN_USER_MANAGE: string = 'pages/admin/UserManagePage'
}
