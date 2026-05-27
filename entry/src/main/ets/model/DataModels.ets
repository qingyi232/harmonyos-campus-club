// ==================== 数据模型定义 ====================

// 用户角色枚举
export enum UserRole {
  STUDENT = 'student',
  LEADER = 'leader',
  ADMIN = 'admin'
}

// 审批状态枚举
export enum ApprovalStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected'
}

// 活动状态枚举
export enum ActivityStatus {
  DRAFT = 'draft',
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
  ONGOING = 'ongoing',
  FINISHED = 'finished'
}

// 用户模型
export interface UserInfo {
  id: string
  username: string
  password: string
  realName: string
  studentId: string
  phone: string
  email: string
  avatar: string
  role: UserRole
  college: string
  major: string
  grade: string
  createTime: number
}

// 社团模型
export interface ClubInfo {
  id: string
  name: string
  description: string
  category: string
  logo: string
  coverImage: string
  leaderId: string
  leaderName: string
  memberCount: number
  maxMembers: number
  status: ApprovalStatus
  createTime: number
  slogan: string
  contactInfo: string
  tags: string[]
}

// 社团成员模型
export interface ClubMember {
  id: string
  clubId: string
  clubName: string
  userId: string
  userName: string
  studentId: string
  role: string // 'member' | 'vice_leader' | 'leader'
  joinTime: number
  status: string
}

// 活动模型
export interface ActivityInfo {
  id: string
  clubId: string
  clubName: string
  title: string
  description: string
  coverImage: string
  location: string
  startTime: number
  endTime: number
  maxParticipants: number
  currentParticipants: number
  status: ActivityStatus
  creatorId: string
  creatorName: string
  createTime: number
  tags: string[]
  summary: string
  photos: string[]
}

// 活动报名模型
export interface ActivityRegistration {
  id: string
  activityId: string
  activityTitle: string
  userId: string
  userName: string
  registerTime: number
  status: string // 'registered' | 'checked_in' | 'cancelled'
}

// 财务记录模型
export interface FinanceRecord {
  id: string
  clubId: string
  clubName: string
  type: string // 'income' | 'expense'
  amount: number
  description: string
  category: string
  receipt: string
  operatorId: string
  operatorName: string
  createTime: number
}

// 社团申请模型
export interface ClubApplication {
  id: string
  userId: string
  userName: string
  clubName: string
  description: string
  category: string
  reason: string
  status: ApprovalStatus
  reviewerId: string
  reviewerName: string
  reviewComment: string
  createTime: number
  reviewTime: number
}

// 入社申请模型
export interface JoinApplication {
  id: string
  clubId: string
  clubName: string
  userId: string
  userName: string
  studentId: string
  introduction: string
  status: ApprovalStatus
  createTime: number
  reviewTime: number
}

// 通知消息模型
export interface NoticeInfo {
  id: string
  title: string
  content: string
  type: string // 'system' | 'club' | 'activity'
  targetRole: string
  senderId: string
  senderName: string
  createTime: number
  isRead: boolean
}

// 统计数据模型
export interface StatisticsData {
  totalClubs: number
  totalStudents: number
  totalActivities: number
  totalFinance: number
  monthlyNewClubs: number
  monthlyNewMembers: number
  monthlyActivities: number
  clubCategoryStats: CategoryStat[]
  activityMonthlyStats: MonthlyStat[]
}

export interface CategoryStat {
  category: string
  count: number
  percentage: number
}

export interface MonthlyStat {
  month: string
  count: number
}

// 活动评价模型
export interface ActivityReview {
  id: string
  activityId: string
  activityTitle: string
  userId: string
  userName: string
  rating: number // 1-5星
  content: string
  createTime: number
}

// 签到记录模型
export interface CheckInRecord {
  id: string
  activityId: string
  activityTitle: string
  userId: string
  userName: string
  checkInTime: number
  location: string
}

// 招新信息模型
export interface RecruitmentInfo {
  id: string
  clubId: string
  clubName: string
  title: string
  description: string
  requirements: string
  deadline: number
  contactInfo: string
  posterImage: string
  status: string // 'active' | 'closed'
  createTime: number
}

// AGC认证Token模型
export interface AuthToken {
  token: string
  userId: string
  role: UserRole
  expireTime: number
  refreshToken: string
}
