/**
 * 应用常量定义
 */
export class Constants {
  // 存储键
  static readonly KEY_USER_INFO = 'user_info';
  static readonly KEY_TOKEN = 'token';
  static readonly KEY_IS_LOGIN = 'is_login';
  
  // 用户角色
  static readonly ROLE_STUDENT = 'student';
  static readonly ROLE_LEADER = 'leader';
  static readonly ROLE_ADMIN = 'admin';
  
  // 社团状态
  static readonly CLUB_STATUS_PENDING = 'pending';
  static readonly CLUB_STATUS_APPROVED = 'approved';
  static readonly CLUB_STATUS_REJECTED = 'rejected';
  
  // 活动状态
  static readonly ACTIVITY_STATUS_DRAFT = 'draft';
  static readonly ACTIVITY_STATUS_PENDING = 'pending';
  static readonly ACTIVITY_STATUS_APPROVED = 'approved';
  static readonly ACTIVITY_STATUS_REJECTED = 'rejected';
  static readonly ACTIVITY_STATUS_ONGOING = 'ongoing';
  static readonly ACTIVITY_STATUS_COMPLETED = 'completed';
  static readonly ACTIVITY_STATUS_CANCELLED = 'cancelled';
  
  // 申请状态
  static readonly APPLY_STATUS_PENDING = 'pending';
  static readonly APPLY_STATUS_APPROVED = 'approved';
  static readonly APPLY_STATUS_REJECTED = 'rejected';
  
  // 财务类型
  static readonly FINANCE_TYPE_INCOME = 'income';
  static readonly FINANCE_TYPE_EXPENSE = 'expense';
  
  // 页面路由
  static readonly ROUTE_LOGIN = 'pages/LoginPage';
  static readonly ROUTE_REGISTER = 'pages/RegisterPage';
  static readonly ROUTE_HOME = 'pages/HomePage';
  static readonly ROUTE_CLUB_LIST = 'pages/ClubListPage';
  static readonly ROUTE_CLUB_DETAIL = 'pages/ClubDetailPage';
  static readonly ROUTE_CLUB_APPLY = 'pages/ClubApplyPage';
  static readonly ROUTE_ACTIVITY_LIST = 'pages/ActivityListPage';
  static readonly ROUTE_ACTIVITY_DETAIL = 'pages/ActivityDetailPage';
  static readonly ROUTE_ACTIVITY_APPLY = 'pages/ActivityApplyPage';
  static readonly ROUTE_MEMBER_MANAGE = 'pages/MemberManagePage';
  static readonly ROUTE_FINANCE_MANAGE = 'pages/FinanceManagePage';
  static readonly ROUTE_PROFILE = 'pages/ProfilePage';
  static readonly ROUTE_STATISTICS = 'pages/StatisticsPage';
  static readonly ROUTE_MY_CLUB = 'pages/MyClubPage';
  static readonly ROUTE_MY_ACTIVITY = 'pages/MyActivityPage';
  static readonly ROUTE_AUDIT_CLUB = 'pages/AuditClubPage';
  static readonly ROUTE_AUDIT_ACTIVITY = 'pages/AuditActivityPage';
}
