// 数据服务 - 统一数据访问层
// 所有页面通过此服务获取数据，模拟真实的端云协同数据流
import {
  UserInfo, UserRole, ClubInfo, ActivityInfo, ClubMember,
  FinanceRecord, ClubApplication, JoinApplication, NoticeInfo,
  ActivityRegistration, ApprovalStatus, ActivityStatus,
  StatisticsData, CategoryStat, MonthlyStat,
  ActivityReview, CheckInRecord, RecruitmentInfo, AuthToken
} from '../model/DataModels'
import {
  SAMPLE_USERS, SAMPLE_CLUBS, SAMPLE_ACTIVITIES, SAMPLE_MEMBERS,
  SAMPLE_FINANCES, SAMPLE_CLUB_APPLICATIONS, SAMPLE_JOIN_APPLICATIONS,
  SAMPLE_NOTICES, SAMPLE_REGISTRATIONS, SAMPLE_REVIEWS, SAMPLE_CHECKINS,
  SAMPLE_RECRUITMENTS
} from './SampleData'

class DataService {
  private static instance: DataService
  private users: UserInfo[] = [...SAMPLE_USERS]
  private clubs: ClubInfo[] = [...SAMPLE_CLUBS]
  private activities: ActivityInfo[] = [...SAMPLE_ACTIVITIES]
  private members: ClubMember[] = [...SAMPLE_MEMBERS]
  private finances: FinanceRecord[] = [...SAMPLE_FINANCES]
  private clubApplications: ClubApplication[] = [...SAMPLE_CLUB_APPLICATIONS]
  private joinApplications: JoinApplication[] = [...SAMPLE_JOIN_APPLICATIONS]
  private notices: NoticeInfo[] = [...SAMPLE_NOTICES]
  private registrations: ActivityRegistration[] = [...SAMPLE_REGISTRATIONS]
  private reviews: ActivityReview[] = [...SAMPLE_REVIEWS]
  private checkIns: CheckInRecord[] = [...SAMPLE_CHECKINS]
  private recruitments: RecruitmentInfo[] = [...SAMPLE_RECRUITMENTS]
  private currentUser: UserInfo | null = null
  private authToken: AuthToken | null = null

  static getInstance(): DataService {
    if (!DataService.instance) {
      DataService.instance = new DataService()
    }
    return DataService.instance
  }

  // ========== 认证服务 ==========
  async login(username: string, password: string): Promise<UserInfo | null> {
    await this.simulateNetwork()
    const user = this.users.find(u => u.username === username && u.password === password)
    if (user) {
      this.currentUser = user
      // 模拟AGC认证服务生成Token
      this.authToken = {
        token: `agc_token_${user.id}_${Date.now()}`,
        userId: user.id,
        role: user.role,
        expireTime: Date.now() + 7200000, // 2小时过期
        refreshToken: `agc_refresh_${user.id}_${Date.now()}`
      }
      console.info(`[AGC Auth] 用户 ${user.realName} 登录成功，Token已下发，角色: ${user.role}`)
    }
    return user || null
  }

  async register(user: Partial<UserInfo>): Promise<boolean> {
    await this.simulateNetwork()
    const exists = this.users.find(u => u.username === user.username)
    if (exists) return false
    const newUser: UserInfo = {
      id: `u${Date.now()}`,
      username: user.username || '',
      password: user.password || '',
      realName: user.realName || '',
      studentId: user.studentId || '',
      phone: user.phone || '',
      email: user.email || '',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop',
      role: UserRole.STUDENT,
      college: user.college || '',
      major: user.major || '',
      grade: user.grade || '',
      createTime: Date.now()
    }
    this.users.push(newUser)
    return true
  }

  getCurrentUser(): UserInfo | null {
    return this.currentUser
  }

  setCurrentUser(user: UserInfo): void {
    this.currentUser = user
  }

  logout(): void {
    this.currentUser = null
    this.authToken = null
    console.info('[AGC Auth] 用户已登出，Token已清除')
  }

  // 获取当前认证Token
  getAuthToken(): AuthToken | null {
    if (this.authToken && this.authToken.expireTime > Date.now()) {
      return this.authToken
    }
    return null
  }

  // 验证权限（基于Token角色控制功能访问）
  hasPermission(requiredRole: UserRole): boolean {
    if (!this.authToken || this.authToken.expireTime < Date.now()) return false
    if (this.authToken.role === UserRole.ADMIN) return true
    if (requiredRole === UserRole.LEADER && this.authToken.role === UserRole.LEADER) return true
    if (requiredRole === UserRole.STUDENT) return true
    return false
  }

  // ========== 用户管理服务 ==========
  async getUsers(): Promise<UserInfo[]> {
    await this.simulateNetwork()
    return [...this.users]
  }

  async getUsersByRole(role: UserRole): Promise<UserInfo[]> {
    await this.simulateNetwork()
    return this.users.filter(u => u.role === role)
  }

  // ========== 社团服务 ==========
  async getClubs(category?: string): Promise<ClubInfo[]> {
    await this.simulateNetwork()
    let result = this.clubs.filter(c => c.status === ApprovalStatus.APPROVED)
    if (category && category !== '全部') {
      result = result.filter(c => c.category === category)
    }
    return result
  }

  async getAllClubs(): Promise<ClubInfo[]> {
    await this.simulateNetwork()
    return [...this.clubs]
  }

  async getClubById(id: string): Promise<ClubInfo | null> {
    await this.simulateNetwork()
    return this.clubs.find(c => c.id === id) || null
  }

  async getClubsByLeader(leaderId: string): Promise<ClubInfo[]> {
    await this.simulateNetwork()
    return this.clubs.filter(c => c.leaderId === leaderId)
  }

  async getMyClubs(userId: string): Promise<ClubInfo[]> {
    await this.simulateNetwork()
    const myMemberships = this.members.filter(m => m.userId === userId && m.status === 'active')
    const clubIds = myMemberships.map(m => m.clubId)
    return this.clubs.filter(c => clubIds.includes(c.id))
  }

  async searchClubs(keyword: string): Promise<ClubInfo[]> {
    await this.simulateNetwork()
    const kw = keyword.toLowerCase()
    return this.clubs.filter(c =>
      c.status === ApprovalStatus.APPROVED &&
      (c.name.toLowerCase().includes(kw) || c.description.toLowerCase().includes(kw) || c.category.toLowerCase().includes(kw))
    )
  }

  // ========== 活动服务 ==========
  async getActivities(status?: ActivityStatus): Promise<ActivityInfo[]> {
    await this.simulateNetwork()
    if (status) {
      return this.activities.filter(a => a.status === status)
    }
    return this.activities.filter(a => a.status === ActivityStatus.APPROVED || a.status === ActivityStatus.ONGOING)
  }

  async getActivityById(id: string): Promise<ActivityInfo | null> {
    await this.simulateNetwork()
    return this.activities.find(a => a.id === id) || null
  }

  async getActivitiesByClub(clubId: string): Promise<ActivityInfo[]> {
    await this.simulateNetwork()
    return this.activities.filter(a => a.clubId === clubId)
  }

  async getAllActivities(): Promise<ActivityInfo[]> {
    await this.simulateNetwork()
    return [...this.activities]
  }

  async createActivity(activity: Partial<ActivityInfo>): Promise<boolean> {
    await this.simulateNetwork()
    const newActivity: ActivityInfo = {
      id: `a${Date.now()}`,
      clubId: activity.clubId || '',
      clubName: activity.clubName || '',
      title: activity.title || '',
      description: activity.description || '',
      coverImage: activity.coverImage || 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=250&fit=crop',
      location: activity.location || '',
      startTime: activity.startTime || Date.now(),
      endTime: activity.endTime || Date.now(),
      maxParticipants: activity.maxParticipants || 50,
      currentParticipants: 0,
      status: ActivityStatus.PENDING,
      creatorId: activity.creatorId || '',
      creatorName: activity.creatorName || '',
      createTime: Date.now(),
      tags: activity.tags || [],
      summary: '',
      photos: []
    }
    this.activities.push(newActivity)
    return true
  }

  async approveActivity(id: string, approved: boolean): Promise<boolean> {
    await this.simulateNetwork()
    const activity = this.activities.find(a => a.id === id)
    if (activity) {
      activity.status = approved ? ActivityStatus.APPROVED : ActivityStatus.REJECTED
      // 自动生成通知
      if (approved) {
        this.notices.unshift({
          id: `n${Date.now()}`, title: `活动"${activity.title}"审核通过`,
          content: `活动"${activity.title}"已通过审核，现已开放报名。地点：${activity.location}`,
          type: 'activity', targetRole: 'all',
          senderId: this.currentUser?.id || '', senderName: this.currentUser?.realName || '系统',
          createTime: Date.now(), isRead: false
        })
      }
      return true
    }
    return false
  }

  async registerActivity(activityId: string, userId: string, userName: string): Promise<boolean> {
    await this.simulateNetwork()
    const exists = this.registrations.find(r => r.activityId === activityId && r.userId === userId)
    if (exists) return false
    const activity = this.activities.find(a => a.id === activityId)
    if (!activity || activity.currentParticipants >= activity.maxParticipants) return false
    this.registrations.push({
      id: `r${Date.now()}`,
      activityId,
      activityTitle: activity.title,
      userId,
      userName,
      registerTime: Date.now(),
      status: 'registered'
    })
    activity.currentParticipants++
    return true
  }

  async getMyRegistrations(userId: string): Promise<ActivityRegistration[]> {
    await this.simulateNetwork()
    return this.registrations.filter(r => r.userId === userId)
  }

  async isRegistered(activityId: string, userId: string): Promise<boolean> {
    return this.registrations.some(r => r.activityId === activityId && r.userId === userId)
  }

  // ========== 成员服务 ==========
  async getClubMembers(clubId: string): Promise<ClubMember[]> {
    await this.simulateNetwork()
    return this.members.filter(m => m.clubId === clubId && m.status === 'active')
  }

  async removeMember(memberId: string): Promise<boolean> {
    await this.simulateNetwork()
    const member = this.members.find(m => m.id === memberId)
    if (member) {
      member.status = 'removed'
      // 同步减少社团成员数
      const club = this.clubs.find(c => c.id === member.clubId)
      if (club && club.memberCount > 0) club.memberCount--
      return true
    }
    return false
  }

  // ========== 财务服务 ==========
  async getFinanceRecords(clubId: string): Promise<FinanceRecord[]> {
    await this.simulateNetwork()
    return this.finances.filter(f => f.clubId === clubId)
  }

  async getAllFinanceRecords(): Promise<FinanceRecord[]> {
    await this.simulateNetwork()
    return [...this.finances]
  }

  async addFinanceRecord(record: Partial<FinanceRecord>): Promise<boolean> {
    await this.simulateNetwork()
    const newRecord: FinanceRecord = {
      id: `f${Date.now()}`,
      clubId: record.clubId || '',
      clubName: record.clubName || '',
      type: record.type || 'expense',
      amount: record.amount || 0,
      description: record.description || '',
      category: record.category || '',
      receipt: record.receipt || '',
      operatorId: record.operatorId || '',
      operatorName: record.operatorName || '',
      createTime: Date.now()
    }
    this.finances.push(newRecord)
    return true
  }

  getClubBalance(clubId: string): number {
    const records = this.finances.filter(f => f.clubId === clubId)
    let balance = 0
    records.forEach(r => {
      if (r.type === 'income') balance += r.amount
      else balance -= r.amount
    })
    return balance
  }

  // ========== 申请服务 ==========
  async getClubApplications(status?: ApprovalStatus): Promise<ClubApplication[]> {
    await this.simulateNetwork()
    if (status) return this.clubApplications.filter(a => a.status === status)
    return [...this.clubApplications]
  }

  async approveClubApplication(id: string, approved: boolean, comment: string): Promise<boolean> {
    await this.simulateNetwork()
    const app = this.clubApplications.find(a => a.id === id)
    if (app && this.currentUser) {
      app.status = approved ? ApprovalStatus.APPROVED : ApprovalStatus.REJECTED
      app.reviewerId = this.currentUser.id
      app.reviewerName = this.currentUser.realName
      app.reviewComment = comment
      app.reviewTime = Date.now()
      if (approved) {
        const newClub: ClubInfo = {
          id: `c${Date.now()}`, name: app.clubName, description: app.description,
          category: app.category, logo: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=200&h=200&fit=crop',
          coverImage: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&h=300&fit=crop',
          leaderId: app.userId, leaderName: app.userName,
          memberCount: 1, maxMembers: 100, status: ApprovalStatus.APPROVED,
          createTime: Date.now(), slogan: '', contactInfo: '', tags: [app.category]
        }
        this.clubs.push(newClub)
        // 自动将社长加入成员表
        this.members.push({
          id: `m${Date.now()}`, clubId: newClub.id, clubName: newClub.name,
          userId: app.userId, userName: app.userName, studentId: '',
          role: 'leader', joinTime: Date.now(), status: 'active'
        })
        const user = this.users.find(u => u.id === app.userId)
        if (user) user.role = UserRole.LEADER
        // 自动生成通知
        this.notices.unshift({
          id: `n${Date.now()}`, title: `社团"${app.clubName}"审核通过`,
          content: `恭喜！您申请创建的社团"${app.clubName}"已通过管理员审核，现在可以开始管理社团了。`,
          type: 'system', targetRole: 'all',
          senderId: this.currentUser?.id || '', senderName: this.currentUser?.realName || '系统',
          createTime: Date.now(), isRead: false
        })
      }
      return true
    }
    return false
  }

  async getJoinApplications(clubId: string): Promise<JoinApplication[]> {
    await this.simulateNetwork()
    return this.joinApplications.filter(a => a.clubId === clubId)
  }

  async getPendingJoinApplications(clubId: string): Promise<JoinApplication[]> {
    await this.simulateNetwork()
    return this.joinApplications.filter(a => a.clubId === clubId && a.status === ApprovalStatus.PENDING)
  }

  async submitJoinApplication(app: Partial<JoinApplication>): Promise<boolean> {
    await this.simulateNetwork()
    const exists = this.joinApplications.find(a => a.clubId === app.clubId && a.userId === app.userId && a.status === ApprovalStatus.PENDING)
    if (exists) return false
    this.joinApplications.push({
      id: `ja${Date.now()}`, clubId: app.clubId || '', clubName: app.clubName || '',
      userId: app.userId || '', userName: app.userName || '', studentId: app.studentId || '',
      introduction: app.introduction || '', status: ApprovalStatus.PENDING,
      createTime: Date.now(), reviewTime: 0
    })
    return true
  }

  async approveJoinApplication(id: string, approved: boolean): Promise<boolean> {
    await this.simulateNetwork()
    const app = this.joinApplications.find(a => a.id === id)
    if (app) {
      app.status = approved ? ApprovalStatus.APPROVED : ApprovalStatus.REJECTED
      app.reviewTime = Date.now()
      if (approved) {
        this.members.push({
          id: `m${Date.now()}`, clubId: app.clubId, clubName: app.clubName,
          userId: app.userId, userName: app.userName, studentId: app.studentId,
          role: 'member', joinTime: Date.now(), status: 'active'
        })
        const club = this.clubs.find(c => c.id === app.clubId)
        if (club) club.memberCount++
        // 生成通知
        this.notices.unshift({
          id: `n${Date.now()}`, title: `入社申请已通过`,
          content: `恭喜！您加入"${app.clubName}"的申请已通过，欢迎成为社团一员！`,
          type: 'club', targetRole: 'student',
          senderId: '', senderName: app.clubName,
          createTime: Date.now(), isRead: false
        })
      }
      return true
    }
    return false
  }

  // ========== 通知服务 ==========
  async getNotices(role?: string): Promise<NoticeInfo[]> {
    await this.simulateNetwork()
    if (role) {
      return this.notices.filter(n => n.targetRole === 'all' || n.targetRole === role)
    }
    return [...this.notices]
  }

  // ========== 活动评价服务 ==========
  async getActivityReviews(activityId: string): Promise<ActivityReview[]> {
    await this.simulateNetwork()
    return this.reviews.filter(r => r.activityId === activityId)
  }

  async submitReview(review: Partial<ActivityReview>): Promise<boolean> {
    await this.simulateNetwork()
    const exists = this.reviews.find(r => r.activityId === review.activityId && r.userId === review.userId)
    if (exists) return false
    this.reviews.push({
      id: `rv${Date.now()}`,
      activityId: review.activityId || '',
      activityTitle: review.activityTitle || '',
      userId: review.userId || '',
      userName: review.userName || '',
      rating: review.rating || 5,
      content: review.content || '',
      createTime: Date.now()
    })
    return true
  }

  async getAverageRating(activityId: string): Promise<number> {
    const reviews = this.reviews.filter(r => r.activityId === activityId)
    if (reviews.length === 0) return 0
    return reviews.reduce((s, r) => s + r.rating, 0) / reviews.length
  }

  // ========== 签到考勤服务 ==========
  async checkIn(activityId: string, userId: string, userName: string): Promise<boolean> {
    await this.simulateNetwork()
    const exists = this.checkIns.find(c => c.activityId === activityId && c.userId === userId)
    if (exists) return false
    const activity = this.activities.find(a => a.id === activityId)
    this.checkIns.push({
      id: `ck${Date.now()}`,
      activityId,
      activityTitle: activity?.title || '',
      userId,
      userName,
      checkInTime: Date.now(),
      location: activity?.location || ''
    })
    // 更新报名状态为已签到
    const reg = this.registrations.find(r => r.activityId === activityId && r.userId === userId)
    if (reg) reg.status = 'checked_in'
    return true
  }

  async getCheckInRecords(activityId: string): Promise<CheckInRecord[]> {
    await this.simulateNetwork()
    return this.checkIns.filter(c => c.activityId === activityId)
  }

  async isCheckedIn(activityId: string, userId: string): Promise<boolean> {
    return this.checkIns.some(c => c.activityId === activityId && c.userId === userId)
  }

  // ========== 招新服务 ==========
  async getRecruitments(clubId?: string): Promise<RecruitmentInfo[]> {
    await this.simulateNetwork()
    if (clubId) return this.recruitments.filter(r => r.clubId === clubId)
    return this.recruitments.filter(r => r.status === 'active')
  }

  async createRecruitment(rec: Partial<RecruitmentInfo>): Promise<boolean> {
    await this.simulateNetwork()
    this.recruitments.push({
      id: `rec${Date.now()}`,
      clubId: rec.clubId || '',
      clubName: rec.clubName || '',
      title: rec.title || '',
      description: rec.description || '',
      requirements: rec.requirements || '',
      deadline: rec.deadline || Date.now() + 30 * 86400000,
      contactInfo: rec.contactInfo || '',
      posterImage: rec.posterImage || 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=400&h=250&fit=crop',
      status: 'active',
      createTime: Date.now()
    })
    return true
  }

  // ========== 社团编辑服务 ==========
  async updateClubInfo(clubId: string, updates: Partial<ClubInfo>): Promise<boolean> {
    await this.simulateNetwork()
    const club = this.clubs.find(c => c.id === clubId)
    if (club) {
      if (updates.description !== undefined) club.description = updates.description
      if (updates.slogan !== undefined) club.slogan = updates.slogan
      if (updates.contactInfo !== undefined) club.contactInfo = updates.contactInfo
      if (updates.logo !== undefined) club.logo = updates.logo
      if (updates.coverImage !== undefined) club.coverImage = updates.coverImage
      if (updates.tags !== undefined) club.tags = updates.tags
      return true
    }
    return false
  }

  // ========== 活动总结服务 ==========
  async updateActivitySummary(activityId: string, summary: string, photos: string[]): Promise<boolean> {
    await this.simulateNetwork()
    const activity = this.activities.find(a => a.id === activityId)
    if (activity) {
      activity.summary = summary
      activity.photos = photos
      activity.status = ActivityStatus.FINISHED
      return true
    }
    return false
  }

  // ========== 学生申请创建社团 ==========
  async submitClubApplication(app: Partial<ClubApplication>): Promise<boolean> {
    await this.simulateNetwork()
    this.clubApplications.push({
      id: `ca${Date.now()}`,
      userId: app.userId || '',
      userName: app.userName || '',
      clubName: app.clubName || '',
      description: app.description || '',
      category: app.category || '',
      reason: app.reason || '',
      status: ApprovalStatus.PENDING,
      reviewerId: '',
      reviewerName: '',
      reviewComment: '',
      createTime: Date.now(),
      reviewTime: 0
    })
    return true
  }

  // ========== 统计服务 ==========
  async getStatistics(): Promise<StatisticsData> {
    await this.simulateNetwork()
    const approvedClubs = this.clubs.filter(c => c.status === ApprovalStatus.APPROVED)
    const categoryMap = new Map<string, number>()
    approvedClubs.forEach(c => {
      categoryMap.set(c.category, (categoryMap.get(c.category) || 0) + 1)
    })
    const total = approvedClubs.length || 1
    const categoryStats: CategoryStat[] = []
    categoryMap.forEach((count, category) => {
      categoryStats.push({ category, count, percentage: Math.round(count / total * 100) })
    })
    const totalIncome = this.finances.filter(f => f.type === 'income').reduce((s, f) => s + f.amount, 0)
    const totalExpense = this.finances.filter(f => f.type === 'expense').reduce((s, f) => s + f.amount, 0)

    // 从真实活动数据计算月度统计
    const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
    const monthlyMap = new Map<string, number>()
    // 初始化最近6个月
    const now = new Date()
    for (let i = 5; i >= 0; i--) {
      const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
      const key = monthNames[d.getMonth()]
      monthlyMap.set(key, 0)
    }
    // 统计每个活动所在月份
    this.activities.forEach(a => {
      const d = new Date(a.createTime)
      const key = monthNames[d.getMonth()]
      if (monthlyMap.has(key)) {
        monthlyMap.set(key, (monthlyMap.get(key) || 0) + 1)
      }
    })
    const activityMonthlyStats: MonthlyStat[] = []
    monthlyMap.forEach((count, month) => {
      activityMonthlyStats.push({ month, count })
    })

    // 从真实数据计算本月新增
    const thisMonth = now.getMonth()
    const thisYear = now.getFullYear()
    const monthStart = new Date(thisYear, thisMonth, 1).getTime()
    const monthlyNewClubs = this.clubs.filter(c => c.createTime >= monthStart).length
    const monthlyNewMembers = this.members.filter(m => m.joinTime >= monthStart).length
    const monthlyActivities = this.activities.filter(a => a.createTime >= monthStart).length

    return {
      totalClubs: approvedClubs.length,
      totalStudents: this.users.filter(u => u.role === UserRole.STUDENT).length,
      totalActivities: this.activities.length,
      totalFinance: totalIncome - totalExpense,
      monthlyNewClubs,
      monthlyNewMembers,
      monthlyActivities,
      clubCategoryStats: categoryStats,
      activityMonthlyStats
    }
  }

  // 模拟网络延迟
  private simulateNetwork(): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, 100 + Math.random() * 200))
  }
}

export default DataService
