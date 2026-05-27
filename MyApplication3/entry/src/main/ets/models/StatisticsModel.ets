/**
 * 统计数据模型
 */
export interface SystemStatisticsInit {
  totalUsers?: number;
  activeUsers?: number;
  newUsersToday?: number;
  totalClubs?: number;
  activeClubs?: number;
  pendingClubs?: number;
  totalActivities?: number;
  ongoingActivities?: number;
  pendingActivities?: number;
  totalFinance?: number;
  monthIncome?: number;
  monthExpense?: number;
  userTrend?: TrendData[];
  activityTrend?: TrendData[];
  clubCategoryStats?: CategoryStat[];
}

export class SystemStatistics {
  totalUsers: number = 0;
  activeUsers: number = 0;
  newUsersToday: number = 0;
  totalClubs: number = 0;
  activeClubs: number = 0;
  pendingClubs: number = 0;
  totalActivities: number = 0;
  ongoingActivities: number = 0;
  pendingActivities: number = 0;
  totalFinance: number = 0;
  monthIncome: number = 0;
  monthExpense: number = 0;
  userTrend: TrendData[] = [];
  activityTrend: TrendData[] = [];
  clubCategoryStats: CategoryStat[] = [];

  constructor(data?: SystemStatisticsInit) {
    if (data) {
      if (data.totalUsers !== undefined) this.totalUsers = data.totalUsers;
      if (data.activeUsers !== undefined) this.activeUsers = data.activeUsers;
      if (data.newUsersToday !== undefined) this.newUsersToday = data.newUsersToday;
      if (data.totalClubs !== undefined) this.totalClubs = data.totalClubs;
      if (data.activeClubs !== undefined) this.activeClubs = data.activeClubs;
      if (data.pendingClubs !== undefined) this.pendingClubs = data.pendingClubs;
      if (data.totalActivities !== undefined) this.totalActivities = data.totalActivities;
      if (data.ongoingActivities !== undefined) this.ongoingActivities = data.ongoingActivities;
      if (data.pendingActivities !== undefined) this.pendingActivities = data.pendingActivities;
      if (data.totalFinance !== undefined) this.totalFinance = data.totalFinance;
      if (data.monthIncome !== undefined) this.monthIncome = data.monthIncome;
      if (data.monthExpense !== undefined) this.monthExpense = data.monthExpense;
      if (data.userTrend !== undefined) this.userTrend = data.userTrend;
      if (data.activityTrend !== undefined) this.activityTrend = data.activityTrend;
      if (data.clubCategoryStats !== undefined) this.clubCategoryStats = data.clubCategoryStats;
    }
  }
}

export interface TrendDataInit {
  date?: string;
  value?: number;
}

export class TrendData {
  date: string = '';
  value: number = 0;

  constructor(data?: TrendDataInit) {
    if (data) {
      if (data.date !== undefined) this.date = data.date;
      if (data.value !== undefined) this.value = data.value;
    }
  }
}

export interface CategoryStatInit {
  category?: string;
  count?: number;
  percentage?: number;
}

export class CategoryStat {
  category: string = '';
  count: number = 0;
  percentage: number = 0;

  constructor(data?: CategoryStatInit) {
    if (data) {
      if (data.category !== undefined) this.category = data.category;
      if (data.count !== undefined) this.count = data.count;
      if (data.percentage !== undefined) this.percentage = data.percentage;
    }
  }
}

export interface UserParticipationStatsInit {
  userId?: string;
  userName?: string;
  joinedClubs?: number;
  participatedActivities?: number;
  totalHours?: number;
  rank?: number;
}

export class UserParticipationStats {
  userId: string = '';
  userName: string = '';
  joinedClubs: number = 0;
  participatedActivities: number = 0;
  totalHours: number = 0;
  rank: number = 0;

  constructor(data?: UserParticipationStatsInit) {
    if (data) {
      if (data.userId !== undefined) this.userId = data.userId;
      if (data.userName !== undefined) this.userName = data.userName;
      if (data.joinedClubs !== undefined) this.joinedClubs = data.joinedClubs;
      if (data.participatedActivities !== undefined) this.participatedActivities = data.participatedActivities;
      if (data.totalHours !== undefined) this.totalHours = data.totalHours;
      if (data.rank !== undefined) this.rank = data.rank;
    }
  }
}

export interface ClubActivityStatsInit {
  clubId?: string;
  clubName?: string;
  memberCount?: number;
  activityCount?: number;
  totalParticipants?: number;
  avgRating?: number;
  rank?: number;
}

export class ClubActivityStats {
  clubId: string = '';
  clubName: string = '';
  memberCount: number = 0;
  activityCount: number = 0;
  totalParticipants: number = 0;
  avgRating: number = 0;
  rank: number = 0;

  constructor(data?: ClubActivityStatsInit) {
    if (data) {
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.memberCount !== undefined) this.memberCount = data.memberCount;
      if (data.activityCount !== undefined) this.activityCount = data.activityCount;
      if (data.totalParticipants !== undefined) this.totalParticipants = data.totalParticipants;
      if (data.avgRating !== undefined) this.avgRating = data.avgRating;
      if (data.rank !== undefined) this.rank = data.rank;
    }
  }
}
