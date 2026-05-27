import { UserInfo, LoginRequest, LoginResponse, RegisterRequest, UserInfoInit } from '../models/UserModel';
import { ClubInfo, ClubApplyRequest, ClubMember } from '../models/ClubModel';
import { ActivityInfo, ActivityApplyRequest, ActivityRegistration, ActivityReview } from '../models/ActivityModel';
import { FinanceRecord, FinanceStatistics } from '../models/FinanceModel';
import { SystemStatistics, UserParticipationStats, ClubActivityStats, TrendData, CategoryStat } from '../models/StatisticsModel';
import { CommonUtil } from '../utils/CommonUtil';

export class ClubQueryParams {
  category?: string;
  status?: string;
  keyword?: string;
}

export class ActivityQueryParams {
  clubId?: string;
  status?: string;
  keyword?: string;
}

class MockDatabase {
  users: UserInfo[] = [];
  clubs: ClubInfo[] = [];
  members: ClubMember[] = [];
  activities: ActivityInfo[] = [];
  registrations: ActivityRegistration[] = [];
  financeRecords: FinanceRecord[] = [];
  reviews: ActivityReview[] = [];
}

export class MockDataService {
  private static database: MockDatabase = MockDataService.createDatabase();

  private static delay(ms: number = 120): Promise<void> {
    return new Promise((resolve: () => void) => {
      setTimeout(() => resolve(), ms);
    });
  }

  private static createDatabase(): MockDatabase {
    const db: MockDatabase = new MockDatabase();
    const now: number = Date.now();

    const admin: UserInfo = new UserInfo({
      id: 'user_admin',
      username: 'admin',
      password: '123456',
      realName: '系统管理员',
      studentId: 'A0001',
      phone: '13800000001',
      email: 'admin@campus.com',
      avatar: 'https://i.pravatar.cc/200?img=1',
      role: 'admin',
      createTime: now,
      updateTime: now
    });

    const leader: UserInfo = new UserInfo({
      id: 'user_leader1',
      username: 'leader1',
      password: '123456',
      realName: '张社长',
      studentId: '20230001',
      phone: '13800000002',
      email: 'leader1@campus.com',
      avatar: 'https://i.pravatar.cc/200?img=2',
      role: 'leader',
      clubId: 'club_tech',
      clubName: '科技创新协会',
      createTime: now,
      updateTime: now
    });

    const student1: UserInfo = new UserInfo({
      id: 'user_student1',
      username: 'student1',
      password: '123456',
      realName: '李同学',
      studentId: '20231001',
      phone: '13800000003',
      email: 'student1@campus.com',
      avatar: 'https://i.pravatar.cc/200?img=3',
      role: 'student',
      createTime: now,
      updateTime: now
    });

    const student2: UserInfo = new UserInfo({
      id: 'user_student2',
      username: 'student2',
      password: '123456',
      realName: '王同学',
      studentId: '20231002',
      phone: '13800000004',
      email: 'student2@campus.com',
      avatar: 'https://i.pravatar.cc/200?img=4',
      role: 'student',
      createTime: now,
      updateTime: now
    });

    db.users = [admin, leader, student1, student2];

    const club1: ClubInfo = new ClubInfo({
      id: 'club_tech',
      name: '科技创新协会',
      logo: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop',
      category: '科技类',
      description: '聚焦编程、人工智能和创新实践的综合性学生社团。',
      leaderId: leader.id,
      leaderName: leader.realName,
      memberCount: 18,
      maxMembers: 100,
      status: 'approved',
      createTime: now - 90 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['编程', 'AI', '竞赛'],
      images: [
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&h=500&fit=crop',
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&h=500&fit=crop'
      ]
    });

    const club2: ClubInfo = new ClubInfo({
      id: 'club_music',
      name: '校园音乐社',
      logo: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=300&fit=crop',
      category: '文艺类',
      description: '热爱音乐的同学们一起排练、演出和创作。',
      leaderId: 'user_music_leader',
      leaderName: '陈同学',
      memberCount: 26,
      maxMembers: 120,
      status: 'approved',
      createTime: now - 120 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['乐队', '演出', '声乐'],
      images: []
    });

    const club3: ClubInfo = new ClubInfo({
      id: 'club_sport',
      name: '羽毛球协会',
      logo: 'https://images.unsplash.com/photo-1461896836934-bd45ba7a7e3e?w=400&h=300&fit=crop',
      category: '体育类',
      description: '组织训练、校内比赛和联谊活动。',
      leaderId: 'user_sport_leader',
      leaderName: '赵同学',
      memberCount: 32,
      maxMembers: 150,
      status: 'approved',
      createTime: now - 60 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['运动', '比赛'],
      images: []
    });

    const club4: ClubInfo = new ClubInfo({
      id: 'club_pending',
      name: '青年公益社',
      logo: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&h=300&fit=crop',
      category: '公益类',
      description: '策划志愿服务与公益实践。',
      leaderId: student2.id,
      leaderName: student2.realName,
      memberCount: 1,
      maxMembers: 80,
      status: 'pending',
      createTime: now - 10 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['公益', '志愿'],
      images: []
    });

    db.clubs = [club1, club2, club3, club4];

    db.members = [
      new ClubMember({
        id: 'member_1',
        clubId: club1.id,
        userId: leader.id,
        userName: leader.realName,
        userAvatar: leader.avatar,
        studentId: leader.studentId,
        phone: leader.phone,
        role: 'leader',
        status: 'active',
        joinTime: now - 80 * 24 * 3600 * 1000
      }),
      new ClubMember({
        id: 'member_2',
        clubId: club1.id,
        userId: student1.id,
        userName: student1.realName,
        userAvatar: student1.avatar,
        studentId: student1.studentId,
        phone: student1.phone,
        role: 'member',
        status: 'active',
        joinTime: now - 20 * 24 * 3600 * 1000
      }),
      new ClubMember({
        id: 'member_3',
        clubId: club2.id,
        userId: student2.id,
        userName: student2.realName,
        userAvatar: student2.avatar,
        studentId: student2.studentId,
        phone: student2.phone,
        role: 'member',
        status: 'active',
        joinTime: now - 15 * 24 * 3600 * 1000
      })
    ];

    const activity1: ActivityInfo = new ActivityInfo({
      id: 'activity_1',
      clubId: club1.id,
      clubName: club1.name,
      title: 'HarmonyOS 实战工作坊',
      description: '面向新成员的 ArkTS 与应用开发训练营。',
      coverImage: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=800&h=500&fit=crop',
      location: '信息楼 301',
      startTime: now + 2 * 24 * 3600 * 1000,
      endTime: now + 2 * 24 * 3600 * 1000 + 2 * 3600 * 1000,
      maxParticipants: 60,
      currentParticipants: 22,
      status: 'approved',
      creatorId: leader.id,
      creatorName: leader.realName,
      createTime: now - 5 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['技术分享', 'HarmonyOS'],
      images: []
    });

    const activity2: ActivityInfo = new ActivityInfo({
      id: 'activity_2',
      clubId: club2.id,
      clubName: club2.name,
      title: '校园十佳歌手海选',
      description: '音乐社组织的校园歌手比赛海选活动。',
      coverImage: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=500&fit=crop',
      location: '大学生活动中心',
      startTime: now + 5 * 24 * 3600 * 1000,
      endTime: now + 5 * 24 * 3600 * 1000 + 3 * 3600 * 1000,
      maxParticipants: 80,
      currentParticipants: 36,
      status: 'approved',
      creatorId: 'user_music_leader',
      creatorName: '陈同学',
      createTime: now - 2 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['比赛', '音乐'],
      images: []
    });

    const activity3: ActivityInfo = new ActivityInfo({
      id: 'activity_3',
      clubId: club1.id,
      clubName: club1.name,
      title: '创新项目路演',
      description: '展示社团成员的创新项目成果。',
      coverImage: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&h=500&fit=crop',
      location: '图书馆报告厅',
      startTime: now - 24 * 3600 * 1000,
      endTime: now + 3600 * 1000,
      maxParticipants: 120,
      currentParticipants: 86,
      status: 'ongoing',
      creatorId: leader.id,
      creatorName: leader.realName,
      createTime: now - 7 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['路演', '项目'],
      images: []
    });

    const activity4: ActivityInfo = new ActivityInfo({
      id: 'activity_4',
      clubId: club3.id,
      clubName: club3.name,
      title: '校际羽毛球交流赛',
      description: '与兄弟院校开展友谊交流赛。',
      coverImage: 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?w=800&h=500&fit=crop',
      location: '体育馆',
      startTime: now - 8 * 24 * 3600 * 1000,
      endTime: now - 8 * 24 * 3600 * 1000 + 4 * 3600 * 1000,
      maxParticipants: 50,
      currentParticipants: 44,
      status: 'completed',
      creatorId: 'user_sport_leader',
      creatorName: '赵同学',
      createTime: now - 20 * 24 * 3600 * 1000,
      updateTime: now,
      tags: ['比赛', '体育'],
      images: []
    });

    const activity5: ActivityInfo = new ActivityInfo({
      id: 'activity_5',
      clubId: club4.id,
      clubName: club4.name,
      title: '公益宣讲会',
      description: '公益社发起的志愿者招募宣讲。',
      coverImage: 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=800&h=500&fit=crop',
      location: '教学楼 A101',
      startTime: now + 7 * 24 * 3600 * 1000,
      endTime: now + 7 * 24 * 3600 * 1000 + 2 * 3600 * 1000,
      maxParticipants: 100,
      currentParticipants: 0,
      status: 'pending',
      creatorId: student2.id,
      creatorName: student2.realName,
      createTime: now - 24 * 3600 * 1000,
      updateTime: now,
      tags: ['公益'],
      images: []
    });

    db.activities = [activity1, activity2, activity3, activity4, activity5];

    db.registrations = [
      new ActivityRegistration({
        id: 'reg_1',
        activityId: activity1.id,
        activityTitle: activity1.title,
        userId: student1.id,
        userName: student1.realName,
        userAvatar: student1.avatar,
        studentId: student1.studentId,
        phone: student1.phone,
        status: 'registered',
        registerTime: now - 2 * 24 * 3600 * 1000
      }),
      new ActivityRegistration({
        id: 'reg_2',
        activityId: activity3.id,
        activityTitle: activity3.title,
        userId: student2.id,
        userName: student2.realName,
        userAvatar: student2.avatar,
        studentId: student2.studentId,
        phone: student2.phone,
        status: 'attended',
        registerTime: now - 6 * 24 * 3600 * 1000,
        checkInTime: now - 24 * 3600 * 1000
      })
    ];

    db.financeRecords = [
      new FinanceRecord({
        id: 'finance_1',
        clubId: club1.id,
        clubName: club1.name,
        type: 'income',
        category: '会费收入',
        amount: 3200,
        description: '本学期会费汇总',
        proofImage: '',
        operatorId: leader.id,
        operatorName: leader.realName,
        createTime: now - 18 * 24 * 3600 * 1000,
        updateTime: now - 18 * 24 * 3600 * 1000
      }),
      new FinanceRecord({
        id: 'finance_2',
        clubId: club1.id,
        clubName: club1.name,
        type: 'expense',
        category: '物资采购',
        amount: 980,
        description: '工作坊资料与横幅制作',
        proofImage: 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
        operatorId: leader.id,
        operatorName: leader.realName,
        createTime: now - 6 * 24 * 3600 * 1000,
        updateTime: now - 6 * 24 * 3600 * 1000
      }),
      new FinanceRecord({
        id: 'finance_3',
        clubId: club1.id,
        clubName: club1.name,
        type: 'income',
        category: '赞助收入',
        amount: 2000,
        description: '企业赞助支持',
        proofImage: '',
        operatorId: leader.id,
        operatorName: leader.realName,
        createTime: now - 3 * 24 * 3600 * 1000,
        updateTime: now - 3 * 24 * 3600 * 1000
      })
    ];

    return db;
  }

  private static buildLoginResponse(user: UserInfo): LoginResponse {
    return new LoginResponse({
      token: 'mock_token_' + user.id + '_' + Date.now().toString(),
      userInfo: user
    });
  }

  private static copyUser(user: UserInfo): UserInfo {
    const u: UserInfo = new UserInfo();
    u.id = user.id;
    u.username = user.username;
    u.password = user.password;
    u.realName = user.realName;
    u.studentId = user.studentId;
    u.phone = user.phone;
    u.email = user.email;
    u.avatar = user.avatar;
    u.role = user.role;
    u.clubId = user.clubId;
    u.clubName = user.clubName;
    u.createTime = user.createTime;
    u.updateTime = user.updateTime;
    return u;
  }

  private static copyClub(club: ClubInfo): ClubInfo {
    const c: ClubInfo = new ClubInfo();
    c.id = club.id;
    c.name = club.name;
    c.logo = club.logo;
    c.category = club.category;
    c.description = club.description;
    c.leaderId = club.leaderId;
    c.leaderName = club.leaderName;
    c.memberCount = club.memberCount;
    c.maxMembers = club.maxMembers;
    c.status = club.status;
    c.createTime = club.createTime;
    c.updateTime = club.updateTime;
    c.tags = club.tags.slice();
    c.images = club.images.slice();
    return c;
  }

  private static copyMember(member: ClubMember): ClubMember {
    const m: ClubMember = new ClubMember();
    m.id = member.id;
    m.clubId = member.clubId;
    m.userId = member.userId;
    m.userName = member.userName;
    m.userAvatar = member.userAvatar;
    m.studentId = member.studentId;
    m.phone = member.phone;
    m.role = member.role;
    m.status = member.status;
    m.joinTime = member.joinTime;
    return m;
  }

  private static copyActivity(activity: ActivityInfo): ActivityInfo {
    const a: ActivityInfo = new ActivityInfo();
    a.id = activity.id;
    a.clubId = activity.clubId;
    a.clubName = activity.clubName;
    a.title = activity.title;
    a.description = activity.description;
    a.coverImage = activity.coverImage;
    a.location = activity.location;
    a.startTime = activity.startTime;
    a.endTime = activity.endTime;
    a.maxParticipants = activity.maxParticipants;
    a.currentParticipants = activity.currentParticipants;
    a.status = activity.status;
    a.creatorId = activity.creatorId;
    a.creatorName = activity.creatorName;
    a.createTime = activity.createTime;
    a.updateTime = activity.updateTime;
    a.tags = activity.tags.slice();
    a.images = activity.images.slice();
    return a;
  }

  private static copyRegistration(registration: ActivityRegistration): ActivityRegistration {
    const r: ActivityRegistration = new ActivityRegistration();
    r.id = registration.id;
    r.activityId = registration.activityId;
    r.activityTitle = registration.activityTitle;
    r.userId = registration.userId;
    r.userName = registration.userName;
    r.userAvatar = registration.userAvatar;
    r.studentId = registration.studentId;
    r.phone = registration.phone;
    r.status = registration.status;
    r.registerTime = registration.registerTime;
    r.checkInTime = registration.checkInTime;
    return r;
  }

  private static copyFinanceRecord(record: FinanceRecord): FinanceRecord {
    const f: FinanceRecord = new FinanceRecord();
    f.id = record.id;
    f.clubId = record.clubId;
    f.clubName = record.clubName;
    f.type = record.type;
    f.category = record.category;
    f.amount = record.amount;
    f.description = record.description;
    f.proofImage = record.proofImage;
    f.operatorId = record.operatorId;
    f.operatorName = record.operatorName;
    f.createTime = record.createTime;
    f.updateTime = record.updateTime;
    return f;
  }

  static async login(request: LoginRequest): Promise<LoginResponse> {
    await MockDataService.delay();
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => {
      return item.username === request.username && item.password === request.password;
    });
    if (!user) {
      throw new Error('用户名或密码错误');
    }
    return MockDataService.buildLoginResponse(MockDataService.copyUser(user));
  }

  static async register(request: RegisterRequest): Promise<UserInfo> {
    await MockDataService.delay();
    const exists: boolean = MockDataService.database.users.some((item: UserInfo) => item.username === request.username);
    if (exists) {
      throw new Error('用户名已存在');
    }

    const now: number = Date.now();
    const user: UserInfo = new UserInfo({
      id: CommonUtil.generateId(),
      username: request.username,
      password: request.password,
      realName: request.realName,
      studentId: request.studentId,
      phone: request.phone,
      email: request.email,
      avatar: 'https://i.pravatar.cc/200?u=' + request.username,
      role: 'student',
      createTime: now,
      updateTime: now
    });

    MockDataService.database.users.push(user);
    return MockDataService.copyUser(user);
  }

  static async getUserInfo(userId: string): Promise<UserInfo> {
    await MockDataService.delay();
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    if (!user) {
      throw new Error('用户不存在');
    }
    return MockDataService.copyUser(user);
  }

  static async updateUserInfo(userId: string, data: UserInfoInit): Promise<UserInfo> {
    await MockDataService.delay();
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    if (!user) {
      throw new Error('用户不存在');
    }

    if (data.realName !== undefined) user.realName = data.realName;
    if (data.phone !== undefined) user.phone = data.phone;
    if (data.email !== undefined) user.email = data.email;
    if (data.avatar !== undefined) user.avatar = data.avatar;
    if (data.clubId !== undefined) user.clubId = data.clubId;
    if (data.clubName !== undefined) user.clubName = data.clubName;
    user.updateTime = Date.now();
    return MockDataService.copyUser(user);
  }

  static async getClubList(params?: ClubQueryParams): Promise<ClubInfo[]> {
    await MockDataService.delay();
    let clubs: ClubInfo[] = MockDataService.database.clubs.map((club: ClubInfo) => MockDataService.copyClub(club));
    if (params && params.category !== undefined && params.category !== '') {
      clubs = clubs.filter((club: ClubInfo) => club.category === params.category);
    }
    if (params && params.status !== undefined && params.status !== '') {
      clubs = clubs.filter((club: ClubInfo) => club.status === params.status);
    }
    if (params && params.keyword !== undefined && params.keyword !== '') {
      const keyword: string = params.keyword.toLowerCase();
      clubs = clubs.filter((club: ClubInfo) => {
        return club.name.toLowerCase().includes(keyword) || club.description.toLowerCase().includes(keyword);
      });
    }
    return clubs;
  }

  static async getClubDetail(clubId: string): Promise<ClubInfo> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (!club) {
      throw new Error('社团不存在');
    }
    return MockDataService.copyClub(club);
  }

  static async applyClub(userId: string, request: ClubApplyRequest): Promise<ClubInfo> {
    await MockDataService.delay();
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    const now: number = Date.now();
    const newClub: ClubInfo = new ClubInfo({
      id: CommonUtil.generateId(),
      name: request.name,
      logo: request.logo ? request.logo : 'https://picsum.photos/seed/' + request.name + '/200/200',
      category: request.category,
      description: request.description,
      leaderId: userId,
      leaderName: user ? user.realName : '',
      memberCount: 1,
      maxMembers: 100,
      status: 'pending',
      createTime: now,
      updateTime: now,
      tags: request.tags,
      images: []
    });
    MockDataService.database.clubs.push(newClub);
    return MockDataService.copyClub(newClub);
  }

  static async auditClub(clubId: string, status: string, reason?: string): Promise<ClubInfo> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (!club) {
      throw new Error('社团不存在');
    }
    club.status = status;
    club.updateTime = Date.now();
    if (reason !== undefined && reason.length > 0) {
      club.description = club.description + '\n审核说明：' + reason;
    }
    return MockDataService.copyClub(club);
  }

  static async getClubMembers(clubId: string): Promise<ClubMember[]> {
    await MockDataService.delay();
    return MockDataService.database.members
      .filter((item: ClubMember) => item.clubId === clubId)
      .map((item: ClubMember) => MockDataService.copyMember(item));
  }

  static async removeMember(memberId: string): Promise<boolean> {
    await MockDataService.delay();
    const before: number = MockDataService.database.members.length;
    MockDataService.database.members = MockDataService.database.members.filter((item: ClubMember) => item.id !== memberId);
    return before !== MockDataService.database.members.length;
  }

  static async removeClubMember(clubId: string, memberId: string): Promise<boolean> {
    await MockDataService.delay();
    const before: number = MockDataService.database.members.length;
    MockDataService.database.members = MockDataService.database.members.filter((item: ClubMember) => {
      return !(item.clubId === clubId && item.id === memberId);
    });
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (club) {
      club.memberCount = MockDataService.database.members.filter((item: ClubMember) => item.clubId === clubId).length;
      club.updateTime = Date.now();
    }
    return before !== MockDataService.database.members.length;
  }

  static async addClubMember(clubId: string, clubName: string, userName: string, studentId: string): Promise<boolean> {
    await MockDataService.delay();
    const now: number = Date.now();
    const member: ClubMember = new ClubMember({
      id: 'member_' + now.toString(),
      clubId: clubId,
      userId: 'u_manual_' + now.toString(),
      userName: userName,
      userAvatar: 'https://i.pravatar.cc/150?u=' + now.toString(),
      studentId: studentId,
      role: 'member',
      joinTime: now
    });
    MockDataService.database.members.push(member);
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (club) {
      club.memberCount = MockDataService.database.members.filter((item: ClubMember) => item.clubId === clubId).length;
      club.updateTime = now;
    }
    return true;
  }

  static async getUserClubs(userId: string): Promise<ClubInfo[]> {
    await MockDataService.delay();
    return MockDataService.database.clubs
      .filter((item: ClubInfo) => item.leaderId === userId)
      .map((item: ClubInfo) => MockDataService.copyClub(item));
  }

  static async getUserJoinedClubs(userId: string): Promise<ClubInfo[]> {
    await MockDataService.delay();
    const clubIds: string[] = MockDataService.database.members
      .filter((item: ClubMember) => item.userId === userId)
      .map((item: ClubMember) => item.clubId);
    return MockDataService.database.clubs
      .filter((item: ClubInfo) => clubIds.indexOf(item.id) >= 0)
      .map((item: ClubInfo) => MockDataService.copyClub(item));
  }

  static async joinClub(userId: string, userName: string, userAvatar: string, clubId: string): Promise<boolean> {
    await MockDataService.delay();
    const exists: boolean = MockDataService.database.members.some((item: ClubMember) => item.clubId === clubId && item.userId === userId);
    if (exists) {
      return true;
    }
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (!club) {
      throw new Error('社团不存在');
    }
    const member: ClubMember = new ClubMember({
      id: CommonUtil.generateId(),
      clubId: clubId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      studentId: user ? user.studentId : '',
      phone: user ? user.phone : '',
      role: 'member',
      status: 'active',
      joinTime: Date.now()
    });
    MockDataService.database.members.push(member);
    club.memberCount = MockDataService.database.members.filter((item: ClubMember) => item.clubId === clubId).length;
    club.updateTime = Date.now();
    return true;
  }

  static async leaveClub(userId: string, clubId: string): Promise<boolean> {
    await MockDataService.delay();
    MockDataService.database.members = MockDataService.database.members.filter((item: ClubMember) => {
      return !(item.userId === userId && item.clubId === clubId);
    });
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    if (club) {
      club.memberCount = MockDataService.database.members.filter((item: ClubMember) => item.clubId === clubId).length;
      club.updateTime = Date.now();
    }
    return true;
  }

  static async getActivityList(params?: ActivityQueryParams): Promise<ActivityInfo[]> {
    await MockDataService.delay();
    let activities: ActivityInfo[] = MockDataService.database.activities.map((activity: ActivityInfo) => MockDataService.copyActivity(activity));
    if (params && params.clubId !== undefined && params.clubId !== '') {
      activities = activities.filter((activity: ActivityInfo) => activity.clubId === params.clubId);
    }
    if (params && params.status !== undefined && params.status !== '') {
      activities = activities.filter((activity: ActivityInfo) => activity.status === params.status);
    }
    if (params && params.keyword !== undefined && params.keyword !== '') {
      const keyword: string = params.keyword.toLowerCase();
      activities = activities.filter((activity: ActivityInfo) => {
        return activity.title.toLowerCase().includes(keyword) || activity.description.toLowerCase().includes(keyword);
      });
    }
    return activities;
  }

  static async getActivityDetail(activityId: string): Promise<ActivityInfo> {
    await MockDataService.delay();
    const activity: ActivityInfo | undefined = MockDataService.database.activities.find((item: ActivityInfo) => item.id === activityId);
    if (!activity) {
      throw new Error('活动不存在');
    }
    return MockDataService.copyActivity(activity);
  }

  static async applyActivity(userId: string, userName: string, request: ActivityApplyRequest): Promise<ActivityInfo> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === request.clubId);
    const now: number = Date.now();
    const activity: ActivityInfo = new ActivityInfo({
      id: CommonUtil.generateId(),
      clubId: request.clubId,
      clubName: club ? club.name : '',
      title: request.title,
      description: request.description,
      coverImage: request.coverImage ? request.coverImage : 'https://picsum.photos/seed/' + request.title + '/400/300',
      location: request.location,
      startTime: request.startTime,
      endTime: request.endTime,
      maxParticipants: request.maxParticipants,
      currentParticipants: 0,
      status: 'pending',
      creatorId: userId,
      creatorName: userName,
      createTime: now,
      updateTime: now,
      tags: request.tags,
      images: []
    });
    MockDataService.database.activities.push(activity);
    return MockDataService.copyActivity(activity);
  }

  static async auditActivity(activityId: string, status: string, reason?: string): Promise<ActivityInfo> {
    await MockDataService.delay();
    const activity: ActivityInfo | undefined = MockDataService.database.activities.find((item: ActivityInfo) => item.id === activityId);
    if (!activity) {
      throw new Error('活动不存在');
    }
    activity.status = status;
    activity.updateTime = Date.now();
    if (reason !== undefined && reason.length > 0) {
      activity.description = activity.description + '\n审核说明：' + reason;
    }
    return MockDataService.copyActivity(activity);
  }

  static async getActivityRegistrations(activityId: string): Promise<ActivityRegistration[]> {
    await MockDataService.delay();
    return MockDataService.database.registrations
      .filter((item: ActivityRegistration) => item.activityId === activityId)
      .map((item: ActivityRegistration) => MockDataService.copyRegistration(item));
  }

  static async registerActivity(userId: string, userName: string, userAvatar: string, activityId: string): Promise<boolean> {
    await MockDataService.delay();
    const exists: boolean = MockDataService.database.registrations.some((item: ActivityRegistration) => {
      return item.activityId === activityId && item.userId === userId;
    });
    if (exists) {
      return true;
    }
    const activity: ActivityInfo | undefined = MockDataService.database.activities.find((item: ActivityInfo) => item.id === activityId);
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    if (!activity) {
      throw new Error('活动不存在');
    }
    const registration: ActivityRegistration = new ActivityRegistration({
      id: CommonUtil.generateId(),
      activityId: activityId,
      activityTitle: activity.title,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      studentId: user ? user.studentId : '',
      phone: user ? user.phone : '',
      status: 'registered',
      registerTime: Date.now()
    });
    MockDataService.database.registrations.push(registration);
    activity.currentParticipants = MockDataService.database.registrations.filter((item: ActivityRegistration) => item.activityId === activityId).length;
    activity.updateTime = Date.now();
    return true;
  }

  static async getUserRegistrations(userId: string): Promise<ActivityRegistration[]> {
    await MockDataService.delay();
    return MockDataService.database.registrations
      .filter((item: ActivityRegistration) => item.userId === userId)
      .map((item: ActivityRegistration) => MockDataService.copyRegistration(item));
  }

  static async getFinanceStatistics(clubId: string): Promise<FinanceStatistics> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    const records: FinanceRecord[] = MockDataService.database.financeRecords.filter((item: FinanceRecord) => item.clubId === clubId);
    const incomeRecords: FinanceRecord[] = records.filter((item: FinanceRecord) => item.type === 'income');
    const expenseRecords: FinanceRecord[] = records.filter((item: FinanceRecord) => item.type === 'expense');
    const totalIncome: number = incomeRecords.reduce((sum: number, item: FinanceRecord) => sum + item.amount, 0);
    const totalExpense: number = expenseRecords.reduce((sum: number, item: FinanceRecord) => sum + item.amount, 0);
    const monthIncome: number = incomeRecords.slice(0, 10).reduce((sum: number, item: FinanceRecord) => sum + item.amount, 0);
    const monthExpense: number = expenseRecords.slice(0, 10).reduce((sum: number, item: FinanceRecord) => sum + item.amount, 0);

    return new FinanceStatistics({
      clubId: clubId,
      clubName: club ? club.name : '',
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
      incomeRecords: incomeRecords.map((item: FinanceRecord) => MockDataService.copyFinanceRecord(item)),
      expenseRecords: expenseRecords.map((item: FinanceRecord) => MockDataService.copyFinanceRecord(item)),
      monthIncome: monthIncome,
      monthExpense: monthExpense
    });
  }

  static async checkInActivity(userId: string, activityId: string): Promise<boolean> {
    await MockDataService.delay();
    const reg: ActivityRegistration | undefined = MockDataService.database.registrations.find(
      (r: ActivityRegistration) => r.userId === userId && r.activityId === activityId
    );
    if (reg) {
      reg.checkInTime = Date.now();
      return true;
    }
    return false;
  }

  static async getActivityReviews(activityId: string): Promise<ActivityReview[]> {
    await MockDataService.delay();
    return MockDataService.database.reviews.filter((r: ActivityReview) => r.activityId === activityId);
  }

  static async submitActivityReview(activityId: string, userId: string, userName: string, rating: number, content: string): Promise<boolean> {
    await MockDataService.delay();
    const exists: boolean = MockDataService.database.reviews.some(
      (r: ActivityReview) => r.activityId === activityId && r.userId === userId
    );
    if (exists) return false;
    MockDataService.database.reviews.push(new ActivityReview({
      id: 'review_' + Date.now().toString(),
      activityId: activityId,
      userId: userId,
      userName: userName,
      rating: rating,
      content: content,
      createTime: Date.now()
    }));
    return true;
  }

  static async submitActivitySummary(activityId: string, summary: string): Promise<boolean> {
    await MockDataService.delay();
    const activity: ActivityInfo | undefined = MockDataService.database.activities.find(
      (a: ActivityInfo) => a.id === activityId
    );
    if (activity) {
      activity.summary = summary;
      activity.status = 'finished';
      return true;
    }
    return false;
  }

  static async updateClubInfo(clubId: string, description: string, contactInfo: string): Promise<boolean> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find(
      (c: ClubInfo) => c.id === clubId
    );
    if (club) {
      if (description) club.description = description;
      if (contactInfo) club.contactInfo = contactInfo;
      return true;
    }
    return false;
  }

  static async getAllFinanceOverview(): Promise<FinanceStatistics[]> {
    await MockDataService.delay();
    const clubMap: Map<string, FinanceStatistics> = new Map();
    MockDataService.database.financeRecords.forEach((r: FinanceRecord) => {
      if (!clubMap.has(r.clubId)) {
        clubMap.set(r.clubId, new FinanceStatistics({
          clubId: r.clubId,
          clubName: r.clubName,
          totalIncome: 0,
          totalExpense: 0,
          balance: 0,
          incomeRecords: [],
          expenseRecords: []
        }));
      }
      const stat: FinanceStatistics = clubMap.get(r.clubId)!;
      if (r.type === 'income') {
        stat.totalIncome += r.amount;
        stat.incomeRecords.push(r);
      } else {
        stat.totalExpense += r.amount;
        stat.expenseRecords.push(r);
      }
      stat.balance = stat.totalIncome - stat.totalExpense;
    });
    const result: FinanceStatistics[] = [];
    clubMap.forEach((v: FinanceStatistics) => { result.push(v); });
    return result;
  }

  static async addFinanceRecord(clubId: string, type: string, category: string, amount: number, description: string, proofImage: string): Promise<boolean> {
    await MockDataService.delay();
    const club: ClubInfo | undefined = MockDataService.database.clubs.find((item: ClubInfo) => item.id === clubId);
    const user = MockDataService.database.users.find((item: UserInfo) => item.role === 'leader');
    const now: number = Date.now();
    const record: FinanceRecord = new FinanceRecord({
      id: 'finance_' + now.toString(),
      clubId: clubId,
      clubName: club ? club.name : '',
      type: type,
      category: category,
      amount: amount,
      description: description,
      proofImage: proofImage,
      operatorId: user ? user.id : '',
      operatorName: user ? user.realName : '',
      createTime: now,
      updateTime: now
    });
    MockDataService.database.financeRecords.push(record);
    return true;
  }

  static async getUserParticipationStats(userId: string): Promise<UserParticipationStats> {
    await MockDataService.delay();
    const user: UserInfo | undefined = MockDataService.database.users.find((item: UserInfo) => item.id === userId);
    const joinedClubs: number = MockDataService.database.members.filter((item: ClubMember) => item.userId === userId).length;
    const registrations: ActivityRegistration[] = MockDataService.database.registrations.filter((item: ActivityRegistration) => item.userId === userId);
    return new UserParticipationStats({
      userId: userId,
      userName: user ? user.realName : '',
      joinedClubs: joinedClubs,
      participatedActivities: registrations.length,
      totalHours: registrations.length * 3,
      rank: joinedClubs + registrations.length > 0 ? 8 : 0
    });
  }

  static async getClubActivityRanking(): Promise<ClubActivityStats[]> {
    await MockDataService.delay();
    const ranking: ClubActivityStats[] = [];
    MockDataService.database.clubs
      .filter((club: ClubInfo) => club.status === 'approved')
      .forEach((club: ClubInfo, index: number) => {
        const activities: ActivityInfo[] = MockDataService.database.activities.filter((item: ActivityInfo) => item.clubId === club.id);
        const totalParticipants: number = activities.reduce((sum: number, item: ActivityInfo) => sum + item.currentParticipants, 0);
        ranking.push(new ClubActivityStats({
          clubId: club.id,
          clubName: club.name,
          memberCount: club.memberCount,
          activityCount: activities.length,
          totalParticipants: totalParticipants,
          avgRating: 4.2 + (activities.length % 5) * 0.1,
          rank: index + 1
        }));
      });

    ranking.sort((a: ClubActivityStats, b: ClubActivityStats) => b.activityCount - a.activityCount);
    ranking.forEach((item: ClubActivityStats, index: number) => {
      item.rank = index + 1;
    });
    return ranking;
  }

  static async getSystemStatistics(): Promise<SystemStatistics> {
    await MockDataService.delay();
    const approvedClubs: ClubInfo[] = MockDataService.database.clubs.filter((item: ClubInfo) => item.status === 'approved');
    const pendingClubs: ClubInfo[] = MockDataService.database.clubs.filter((item: ClubInfo) => item.status === 'pending');
    const ongoingActivities: ActivityInfo[] = MockDataService.database.activities.filter((item: ActivityInfo) => item.status === 'ongoing');
    const pendingActivities: ActivityInfo[] = MockDataService.database.activities.filter((item: ActivityInfo) => item.status === 'pending');
    const totalFinance: number = MockDataService.database.financeRecords.reduce((sum: number, item: FinanceRecord) => sum + item.amount, 0);

    const userTrend: TrendData[] = [
      new TrendData({ date: '周一', value: 2 }),
      new TrendData({ date: '周二', value: 4 }),
      new TrendData({ date: '周三', value: 5 }),
      new TrendData({ date: '周四', value: 3 }),
      new TrendData({ date: '周五', value: 6 })
    ];

    const activityTrend: TrendData[] = [
      new TrendData({ date: '周一', value: 1 }),
      new TrendData({ date: '周二', value: 2 }),
      new TrendData({ date: '周三', value: 2 }),
      new TrendData({ date: '周四', value: 3 }),
      new TrendData({ date: '周五', value: 1 })
    ];

    const categoryStats: CategoryStat[] = [
      new CategoryStat({ category: '科技类', count: 1, percentage: 34 }),
      new CategoryStat({ category: '文艺类', count: 1, percentage: 33 }),
      new CategoryStat({ category: '体育类', count: 1, percentage: 33 })
    ];

    return new SystemStatistics({
      totalUsers: MockDataService.database.users.length,
      activeUsers: MockDataService.database.users.length - 1,
      newUsersToday: 1,
      totalClubs: MockDataService.database.clubs.length,
      activeClubs: approvedClubs.length,
      pendingClubs: pendingClubs.length,
      totalActivities: MockDataService.database.activities.length,
      ongoingActivities: ongoingActivities.length,
      pendingActivities: pendingActivities.length,
      totalFinance: totalFinance,
      monthIncome: 5200,
      monthExpense: 980,
      userTrend: userTrend,
      activityTrend: activityTrend,
      clubCategoryStats: categoryStats
    });
  }
}