// 示例数据服务 - 模拟AGC云端真实数据
import {
  UserInfo, UserRole, ClubInfo, ActivityInfo, ClubMember,
  FinanceRecord, ClubApplication, JoinApplication, NoticeInfo,
  ActivityRegistration, ApprovalStatus, ActivityStatus,
  ActivityReview, CheckInRecord, RecruitmentInfo
} from '../model/DataModels'
import { OnlineImages } from '../common/constants/AppConstants'

// ========== 用户示例数据 ==========
export const SAMPLE_USERS: UserInfo[] = [
  {
    id: 'u001', username: 'admin', password: '123456',
    realName: '张明远', studentId: '20210001', phone: '13800001111',
    email: 'admin@campus.edu.cn', avatar: OnlineImages.AVATAR_MALE,
    role: UserRole.ADMIN, college: '计算机学院', major: '软件工程',
    grade: '教师', createTime: 1695000000000
  },
  {
    id: 'u002', username: 'leader1', password: '123456',
    realName: '李思涵', studentId: '20220101', phone: '13800002222',
    email: 'lisihan@campus.edu.cn', avatar: OnlineImages.AVATAR_FEMALE,
    role: UserRole.LEADER, college: '计算机学院', major: '计算机科学与技术',
    grade: '2022级', createTime: 1695100000000
  },
  {
    id: 'u003', username: 'leader2', password: '123456',
    realName: '王浩然', studentId: '20220205', phone: '13800003333',
    email: 'wanghr@campus.edu.cn', avatar: OnlineImages.AVATAR_MALE,
    role: UserRole.LEADER, college: '艺术学院', major: '视觉传达设计',
    grade: '2022级', createTime: 1695200000000
  },
  {
    id: 'u004', username: 'student1', password: '123456',
    realName: '陈雨萱', studentId: '20230301', phone: '13800004444',
    email: 'chenyuxuan@campus.edu.cn', avatar: OnlineImages.AVATAR_FEMALE,
    role: UserRole.STUDENT, college: '计算机学院', major: '软件工程',
    grade: '2023级', createTime: 1695300000000
  },
  {
    id: 'u005', username: 'student2', password: '123456',
    realName: '刘子轩', studentId: '20230415', phone: '13800005555',
    email: 'liuzixuan@campus.edu.cn', avatar: OnlineImages.AVATAR_MALE,
    role: UserRole.STUDENT, college: '文学院', major: '汉语言文学',
    grade: '2023级', createTime: 1695400000000
  },
  {
    id: 'u006', username: 'student3', password: '123456',
    realName: '赵诗琪', studentId: '20230520', phone: '13800006666',
    email: 'zhaoshiqi@campus.edu.cn', avatar: OnlineImages.AVATAR_FEMALE,
    role: UserRole.STUDENT, college: '外国语学院', major: '英语',
    grade: '2023级', createTime: 1695500000000
  },
  {
    id: 'u007', username: 'leader3', password: '123456',
    realName: '孙博文', studentId: '20210618', phone: '13800007777',
    email: 'sunbowen@campus.edu.cn', avatar: OnlineImages.AVATAR_MALE,
    role: UserRole.LEADER, college: '体育学院', major: '体育教育',
    grade: '2021级', createTime: 1695600000000
  }
]

// ========== 社团示例数据 ==========
export const SAMPLE_CLUBS: ClubInfo[] = [
  {
    id: 'c001', name: '星火编程社',
    description: '致力于培养编程兴趣，定期举办算法竞赛、项目实战和技术分享会。无论你是零基础还是编程高手，这里都有适合你的舞台。',
    category: '学术科技', logo: OnlineImages.CLUB_TECH,
    coverImage: OnlineImages.ACTIVITY_WORKSHOP,
    leaderId: 'u002', leaderName: '李思涵',
    memberCount: 86, maxMembers: 150,
    status: ApprovalStatus.APPROVED, createTime: 1695100000000,
    slogan: '用代码点亮未来', contactInfo: 'QQ群: 123456789',
    tags: ['编程', '算法', '项目实战']
  },
  {
    id: 'c002', name: '丹青书画社',
    description: '传承中华传统书画艺术，开展书法、国画、水彩等多种艺术形式的学习与交流。每周举办书画沙龙，邀请名家指导。',
    category: '文化艺术', logo: OnlineImages.CLUB_ART,
    coverImage: OnlineImages.ACTIVITY_SHOW,
    leaderId: 'u003', leaderName: '王浩然',
    memberCount: 52, maxMembers: 80,
    status: ApprovalStatus.APPROVED, createTime: 1695200000000,
    slogan: '笔墨丹青，传承经典', contactInfo: 'QQ群: 987654321',
    tags: ['书法', '国画', '水彩']
  },
  {
    id: 'c003', name: '飞翼足球社',
    description: '热爱足球的同学们的家园！定期组织训练、友谊赛和校际联赛。不论男女，不论水平，只要你热爱足球，就来加入我们！',
    category: '体育运动', logo: OnlineImages.CLUB_SPORT,
    coverImage: OnlineImages.ACTIVITY_SPORTS,
    leaderId: 'u007', leaderName: '孙博文',
    memberCount: 68, maxMembers: 100,
    status: ApprovalStatus.APPROVED, createTime: 1695300000000,
    slogan: '绿茵逐梦，飞翼翱翔', contactInfo: 'QQ群: 456789123',
    tags: ['足球', '体育', '联赛']
  },
  {
    id: 'c004', name: '光影摄影社',
    description: '用镜头记录校园之美，捕捉生活中的精彩瞬间。定期组织外拍活动、摄影展览和后期修图教学。',
    category: '摄影传媒', logo: OnlineImages.CLUB_PHOTO,
    coverImage: OnlineImages.ACTIVITY_OUTDOOR,
    leaderId: 'u003', leaderName: '王浩然',
    memberCount: 45, maxMembers: 60,
    status: ApprovalStatus.APPROVED, createTime: 1695400000000,
    slogan: '定格光影，留住美好', contactInfo: 'QQ群: 321654987',
    tags: ['摄影', '修图', '展览']
  },
  {
    id: 'c005', name: '青年志愿者协会',
    description: '奉献爱心，服务社会。组织社区服务、支教活动、环保行动等各类志愿服务，让青春在奉献中闪光。',
    category: '志愿公益', logo: OnlineImages.CLUB_VOLUNTEER,
    coverImage: OnlineImages.ACTIVITY_OUTDOOR,
    leaderId: 'u002', leaderName: '李思涵',
    memberCount: 120, maxMembers: 200,
    status: ApprovalStatus.APPROVED, createTime: 1695500000000,
    slogan: '奉献青春，温暖你我', contactInfo: 'QQ群: 654321789',
    tags: ['志愿', '公益', '支教']
  },
  {
    id: 'c006', name: '回声音乐社',
    description: '汇聚校园音乐爱好者，涵盖声乐、器乐、音乐制作等方向。定期举办音乐会、弹唱之夜和音乐创作比赛。',
    category: '音乐舞蹈', logo: OnlineImages.CLUB_MUSIC,
    coverImage: OnlineImages.ACTIVITY_SHOW,
    leaderId: 'u007', leaderName: '孙博文',
    memberCount: 73, maxMembers: 100,
    status: ApprovalStatus.APPROVED, createTime: 1695600000000,
    slogan: '让音乐回响在校园每个角落', contactInfo: 'QQ群: 789123456',
    tags: ['音乐', '乐器', '演出']
  }
]

// ========== 活动示例数据 ==========
export const SAMPLE_ACTIVITIES: ActivityInfo[] = [
  {
    id: 'a001', clubId: 'c001', clubName: '星火编程社',
    title: '2026春季算法挑战赛', description: '面向全校同学的算法编程竞赛，设置初赛和决赛两个阶段。初赛为线上OJ测试，决赛为现场编程。优胜者将获得丰厚奖品和证书。',
    coverImage: OnlineImages.ACTIVITY_COMPETITION,
    location: '计算机学院B栋301机房', startTime: 1711872000000,
    endTime: 1711900800000, maxParticipants: 100,
    currentParticipants: 67, status: ActivityStatus.APPROVED,
    creatorId: 'u002', creatorName: '李思涵',
    createTime: 1711008000000, tags: ['算法', '竞赛', '编程'],
    summary: '', photos: []
  },
  {
    id: 'a002', clubId: 'c002', clubName: '丹青书画社',
    title: '春日书画展——"墨韵春风"', description: '展出社员优秀书画作品50余幅，涵盖楷书、行书、山水画、花鸟画等多种形式。现场设有书法体验区，欢迎同学们前来观展互动。',
    coverImage: OnlineImages.ACTIVITY_SHOW,
    location: '大学生活动中心一楼展厅', startTime: 1712044800000,
    endTime: 1712217600000, maxParticipants: 200,
    currentParticipants: 143, status: ActivityStatus.APPROVED,
    creatorId: 'u003', creatorName: '王浩然',
    createTime: 1711094400000, tags: ['书画', '展览', '传统文化'],
    summary: '', photos: []
  },
  {
    id: 'a003', clubId: 'c003', clubName: '飞翼足球社',
    title: '校园足球联赛（春季赛）', description: '一年一度的校园足球联赛火热开启！各学院组队参赛，采用小组赛+淘汰赛制。快来为你的学院加油助威！',
    coverImage: OnlineImages.ACTIVITY_SPORTS,
    location: '校足球场', startTime: 1712390400000,
    endTime: 1714982400000, maxParticipants: 160,
    currentParticipants: 128, status: ActivityStatus.ONGOING,
    creatorId: 'u007', creatorName: '孙博文',
    createTime: 1711180800000, tags: ['足球', '联赛', '体育'],
    summary: '', photos: []
  },
  {
    id: 'a004', clubId: 'c005', clubName: '青年志愿者协会',
    title: '社区关爱老人志愿服务', description: '前往阳光社区养老院开展志愿服务，陪伴老人聊天、表演节目、整理房间。用我们的温暖照亮他们的生活。',
    coverImage: OnlineImages.ACTIVITY_OUTDOOR,
    location: '阳光社区养老院', startTime: 1712476800000,
    endTime: 1712505600000, maxParticipants: 30,
    currentParticipants: 28, status: ActivityStatus.APPROVED,
    creatorId: 'u002', creatorName: '李思涵',
    createTime: 1711267200000, tags: ['志愿', '公益', '关爱老人'],
    summary: '', photos: []
  },
  {
    id: 'a005', clubId: 'c006', clubName: '回声音乐社',
    title: '校园民谣弹唱之夜', description: '一把吉他，一首歌，一段故事。校园民谣弹唱之夜邀你共度温馨夜晚，现场报名即可上台表演。',
    coverImage: OnlineImages.ACTIVITY_SHOW,
    location: '大学生活动中心露天广场', startTime: 1712563200000,
    endTime: 1712581200000, maxParticipants: 300,
    currentParticipants: 215, status: ActivityStatus.APPROVED,
    creatorId: 'u007', creatorName: '孙博文',
    createTime: 1711353600000, tags: ['音乐', '民谣', '弹唱'],
    summary: '', photos: []
  },
  {
    id: 'a006', clubId: 'c004', clubName: '光影摄影社',
    title: '春日校园摄影采风', description: '趁着春光正好，一起用镜头记录校园最美的季节。本次采风将走遍校园各个角落，优秀作品将在校园摄影展中展出。',
    coverImage: OnlineImages.ACTIVITY_OUTDOOR,
    location: '校园内（集合点：图书馆前广场）', startTime: 1712649600000,
    endTime: 1712671200000, maxParticipants: 40,
    currentParticipants: 35, status: ActivityStatus.PENDING,
    creatorId: 'u003', creatorName: '王浩然',
    createTime: 1711440000000, tags: ['摄影', '采风', '春日'],
    summary: '', photos: []
  },
  {
    id: 'a007', clubId: 'c001', clubName: '星火编程社',
    title: 'Web前端技术分享会', description: '本期分享主题：现代前端框架对比与实战。邀请资深学长分享React、Vue、鸿蒙ArkUI等框架的使用心得和项目经验。',
    coverImage: OnlineImages.ACTIVITY_LECTURE,
    location: '计算机学院A栋201', startTime: 1712736000000,
    endTime: 1712750400000, maxParticipants: 80,
    currentParticipants: 52, status: ActivityStatus.APPROVED,
    creatorId: 'u002', creatorName: '李思涵',
    createTime: 1711526400000, tags: ['前端', '技术分享', 'Web'],
    summary: '', photos: []
  }
]

// ========== 社团成员示例数据 ==========
export const SAMPLE_MEMBERS: ClubMember[] = [
  { id: 'm001', clubId: 'c001', clubName: '星火编程社', userId: 'u002', userName: '李思涵', studentId: '20220101', role: 'leader', joinTime: 1695100000000, status: 'active' },
  { id: 'm002', clubId: 'c001', clubName: '星火编程社', userId: 'u004', userName: '陈雨萱', studentId: '20230301', role: 'member', joinTime: 1696000000000, status: 'active' },
  { id: 'm003', clubId: 'c001', clubName: '星火编程社', userId: 'u005', userName: '刘子轩', studentId: '20230415', role: 'member', joinTime: 1696100000000, status: 'active' },
  { id: 'm004', clubId: 'c002', clubName: '丹青书画社', userId: 'u003', userName: '王浩然', studentId: '20220205', role: 'leader', joinTime: 1695200000000, status: 'active' },
  { id: 'm005', clubId: 'c002', clubName: '丹青书画社', userId: 'u006', userName: '赵诗琪', studentId: '20230520', role: 'member', joinTime: 1696200000000, status: 'active' },
  { id: 'm006', clubId: 'c003', clubName: '飞翼足球社', userId: 'u007', userName: '孙博文', studentId: '20210618', role: 'leader', joinTime: 1695300000000, status: 'active' },
  { id: 'm007', clubId: 'c003', clubName: '飞翼足球社', userId: 'u005', userName: '刘子轩', studentId: '20230415', role: 'member', joinTime: 1696300000000, status: 'active' },
  { id: 'm008', clubId: 'c005', clubName: '青年志愿者协会', userId: 'u002', userName: '李思涵', studentId: '20220101', role: 'leader', joinTime: 1695500000000, status: 'active' },
  { id: 'm009', clubId: 'c005', clubName: '青年志愿者协会', userId: 'u004', userName: '陈雨萱', studentId: '20230301', role: 'member', joinTime: 1696400000000, status: 'active' },
  { id: 'm010', clubId: 'c005', clubName: '青年志愿者协会', userId: 'u006', userName: '赵诗琪', studentId: '20230520', role: 'member', joinTime: 1696500000000, status: 'active' },
  { id: 'm011', clubId: 'c006', clubName: '回声音乐社', userId: 'u007', userName: '孙博文', studentId: '20210618', role: 'leader', joinTime: 1695600000000, status: 'active' },
  { id: 'm012', clubId: 'c004', clubName: '光影摄影社', userId: 'u003', userName: '王浩然', studentId: '20220205', role: 'leader', joinTime: 1695400000000, status: 'active' }
]

// ========== 财务记录示例数据 ==========
export const SAMPLE_FINANCES: FinanceRecord[] = [
  { id: 'f001', clubId: 'c001', clubName: '星火编程社', type: 'income', amount: 5000, description: '学期社团经费拨款', category: '拨款', receipt: '', operatorId: 'u002', operatorName: '李思涵', createTime: 1696000000000 },
  { id: 'f002', clubId: 'c001', clubName: '星火编程社', type: 'expense', amount: 800, description: '算法竞赛奖品采购', category: '活动支出', receipt: OnlineImages.ACTIVITY_COMPETITION, operatorId: 'u002', operatorName: '李思涵', createTime: 1696100000000 },
  { id: 'f003', clubId: 'c001', clubName: '星火编程社', type: 'expense', amount: 200, description: '技术分享会茶歇', category: '日常支出', receipt: 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop', operatorId: 'u002', operatorName: '李思涵', createTime: 1696200000000 },
  { id: 'f004', clubId: 'c002', clubName: '丹青书画社', type: 'income', amount: 3000, description: '学期社团经费拨款', category: '拨款', receipt: '', operatorId: 'u003', operatorName: '王浩然', createTime: 1696000000000 },
  { id: 'f005', clubId: 'c002', clubName: '丹青书画社', type: 'expense', amount: 1200, description: '书画展布展材料', category: '活动支出', receipt: OnlineImages.ACTIVITY_SHOW, operatorId: 'u003', operatorName: '王浩然', createTime: 1696300000000 },
  { id: 'f006', clubId: 'c002', clubName: '丹青书画社', type: 'expense', amount: 500, description: '笔墨纸砚采购', category: '物资采购', receipt: 'https://images.unsplash.com/photo-1572883454114-1cf0031ede2a?w=400&h=300&fit=crop', operatorId: 'u003', operatorName: '王浩然', createTime: 1696400000000 },
  { id: 'f007', clubId: 'c003', clubName: '飞翼足球社', type: 'income', amount: 4000, description: '学期社团经费拨款', category: '拨款', receipt: '', operatorId: 'u007', operatorName: '孙博文', createTime: 1696000000000 },
  { id: 'f008', clubId: 'c003', clubName: '飞翼足球社', type: 'expense', amount: 1500, description: '足球联赛裁判费用', category: '活动支出', receipt: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&h=300&fit=crop', operatorId: 'u007', operatorName: '孙博文', createTime: 1696500000000 },
  { id: 'f009', clubId: 'c005', clubName: '青年志愿者协会', type: 'income', amount: 6000, description: '学期社团经费拨款', category: '拨款', receipt: '', operatorId: 'u002', operatorName: '李思涵', createTime: 1696000000000 },
  { id: 'f010', clubId: 'c005', clubName: '青年志愿者协会', type: 'expense', amount: 800, description: '志愿服务交通费', category: '交通费', receipt: '', operatorId: 'u002', operatorName: '李思涵', createTime: 1696600000000 },
  { id: 'f011', clubId: 'c006', clubName: '回声音乐社', type: 'income', amount: 3500, description: '学期社团经费拨款', category: '拨款', receipt: '', operatorId: 'u007', operatorName: '孙博文', createTime: 1696000000000 },
  { id: 'f012', clubId: 'c006', clubName: '回声音乐社', type: 'expense', amount: 2000, description: '音乐会音响设备租赁', category: '设备租赁', receipt: 'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop', operatorId: 'u007', operatorName: '孙博文', createTime: 1696700000000 }
]

// ========== 社团申请示例数据 ==========
export const SAMPLE_CLUB_APPLICATIONS: ClubApplication[] = [
  {
    id: 'ca001', userId: 'u005', userName: '刘子轩',
    clubName: '国学经典研读社', description: '致力于传统国学经典的研读与传播',
    category: '文化艺术', reason: '希望在校园中推广国学文化，让更多同学了解传统经典的魅力',
    status: ApprovalStatus.PENDING, reviewerId: '', reviewerName: '',
    reviewComment: '', createTime: 1711612800000, reviewTime: 0
  },
  {
    id: 'ca002', userId: 'u006', userName: '赵诗琪',
    clubName: '英语角交流社', description: '为英语爱好者提供口语练习和文化交流平台',
    category: '语言交流', reason: '学校缺少英语口语练习的平台，希望创建一个轻松的英语交流环境',
    status: ApprovalStatus.PENDING, reviewerId: '', reviewerName: '',
    reviewComment: '', createTime: 1711699200000, reviewTime: 0
  }
]

// ========== 入社申请示例数据 ==========
export const SAMPLE_JOIN_APPLICATIONS: JoinApplication[] = [
  { id: 'ja001', clubId: 'c001', clubName: '星火编程社', userId: 'u006', userName: '赵诗琪', studentId: '20230520', introduction: '虽然是外语专业，但对编程很感兴趣，自学了Python基础', status: ApprovalStatus.PENDING, createTime: 1711785600000, reviewTime: 0 },
  { id: 'ja002', clubId: 'c006', clubName: '回声音乐社', userId: 'u004', userName: '陈雨萱', studentId: '20230301', introduction: '从小学习钢琴，希望在大学继续音乐之路', status: ApprovalStatus.PENDING, createTime: 1711872000000, reviewTime: 0 },
  { id: 'ja003', clubId: 'c003', clubName: '飞翼足球社', userId: 'u004', userName: '陈雨萱', studentId: '20230301', introduction: '热爱足球运动，高中时是校队成员', status: ApprovalStatus.APPROVED, createTime: 1710000000000, reviewTime: 1710100000000 }
]

// ========== 通知示例数据 ==========
export const SAMPLE_NOTICES: NoticeInfo[] = [
  { id: 'n001', title: '2026年春季社团招新通知', content: '各社团即日起可开展春季招新工作，请各社团负责人在系统中发布招新信息，招新截止日期为4月15日。', type: 'system', targetRole: 'all', senderId: 'u001', senderName: '张明远', createTime: 1711008000000, isRead: false },
  { id: 'n002', title: '社团经费使用规范提醒', content: '请各社团严格按照经费管理规定使用社团经费，每笔支出需上传凭证，确保经费使用透明合规。', type: 'system', targetRole: 'leader', senderId: 'u001', senderName: '张明远', createTime: 1711094400000, isRead: false },
  { id: 'n003', title: '星火编程社算法竞赛报名开启', content: '2026春季算法挑战赛报名已开启，欢迎全校同学踊跃参加！报名截止日期为3月25日。', type: 'club', targetRole: 'all', senderId: 'u002', senderName: '李思涵', createTime: 1711180800000, isRead: false },
  { id: 'n004', title: '校园足球联赛赛程公布', content: '2026春季校园足球联赛赛程已公布，请各参赛队伍注意比赛时间和场地安排。', type: 'activity', targetRole: 'all', senderId: 'u007', senderName: '孙博文', createTime: 1711267200000, isRead: true }
]

// ========== 活动报名示例数据 ==========
export const SAMPLE_REGISTRATIONS: ActivityRegistration[] = [
  { id: 'r001', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u004', userName: '陈雨萱', registerTime: 1711094400000, status: 'registered' },
  { id: 'r002', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u005', userName: '刘子轩', registerTime: 1711180800000, status: 'registered' },
  { id: 'r003', activityId: 'a002', activityTitle: '春日书画展——"墨韵春风"', userId: 'u006', userName: '赵诗琪', registerTime: 1711267200000, status: 'registered' },
  { id: 'r004', activityId: 'a004', activityTitle: '社区关爱老人志愿服务', userId: 'u004', userName: '陈雨萱', registerTime: 1711353600000, status: 'registered' },
  { id: 'r005', activityId: 'a005', activityTitle: '校园民谣弹唱之夜', userId: 'u005', userName: '刘子轩', registerTime: 1711440000000, status: 'registered' },
  { id: 'r006', activityId: 'a005', activityTitle: '校园民谣弹唱之夜', userId: 'u006', userName: '赵诗琪', registerTime: 1711526400000, status: 'registered' }
]

// ========== 活动评价示例数据 ==========
export const SAMPLE_REVIEWS: ActivityReview[] = [
  { id: 'rv001', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u004', userName: '陈雨萱', rating: 5, content: '比赛题目设计得很好，难度适中，学到了很多算法知识！', createTime: 1712000000000 },
  { id: 'rv002', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u005', userName: '刘子轩', rating: 4, content: '组织得很不错，希望下次能增加更多实战题目。', createTime: 1712100000000 },
  { id: 'rv003', activityId: 'a002', activityTitle: '春日书画展——"墨韵春风"', userId: 'u006', userName: '赵诗琪', rating: 5, content: '展出的作品水平很高，书法体验区特别有趣，强烈推荐！', createTime: 1712300000000 },
  { id: 'rv004', activityId: 'a005', activityTitle: '校园民谣弹唱之夜', userId: 'u005', userName: '刘子轩', rating: 5, content: '氛围超棒！每个表演者都很有才华，期待下一次！', createTime: 1712600000000 },
  { id: 'rv005', activityId: 'a004', activityTitle: '社区关爱老人志愿服务', userId: 'u004', userName: '陈雨萱', rating: 5, content: '很有意义的活动，老人们都很开心，我们也收获了很多感动。', createTime: 1712500000000 }
]

// ========== 签到记录示例数据 ==========
export const SAMPLE_CHECKINS: CheckInRecord[] = [
  { id: 'ck001', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u004', userName: '陈雨萱', checkInTime: 1711872000000, location: '计算机学院B栋301机房' },
  { id: 'ck002', activityId: 'a001', activityTitle: '2026春季算法挑战赛', userId: 'u005', userName: '刘子轩', checkInTime: 1711872300000, location: '计算机学院B栋301机房' },
  { id: 'ck003', activityId: 'a002', activityTitle: '春日书画展——"墨韵春风"', userId: 'u006', userName: '赵诗琪', checkInTime: 1712044800000, location: '大学生活动中心一楼展厅' },
  { id: 'ck004', activityId: 'a004', activityTitle: '社区关爱老人志愿服务', userId: 'u004', userName: '陈雨萱', checkInTime: 1712476800000, location: '阳光社区养老院' },
  { id: 'ck005', activityId: 'a005', activityTitle: '校园民谣弹唱之夜', userId: 'u005', userName: '刘子轩', checkInTime: 1712563200000, location: '大学生活动中心露天广场' },
  { id: 'ck006', activityId: 'a005', activityTitle: '校园民谣弹唱之夜', userId: 'u006', userName: '赵诗琪', checkInTime: 1712563500000, location: '大学生活动中心露天广场' }
]

// ========== 招新信息示例数据 ==========
export const SAMPLE_RECRUITMENTS: RecruitmentInfo[] = [
  { id: 'rec001', clubId: 'c001', clubName: '星火编程社', title: '2026春季招新 — 寻找代码之星', description: '无论你是编程小白还是技术大牛，星火编程社都欢迎你的加入！我们提供从入门到进阶的完整学习路径，还有丰富的项目实战机会。', requirements: '对编程有兴趣即可，不限专业不限基础', deadline: 1713196800000, contactInfo: '李思涵 13800002222 / QQ群: 123456789', posterImage: OnlineImages.ACTIVITY_WORKSHOP, status: 'active', createTime: 1711008000000 },
  { id: 'rec002', clubId: 'c002', clubName: '丹青书画社', title: '丹青书画社春季纳新', description: '喜欢书法、国画、水彩？来丹青书画社，与志同道合的朋友一起挥毫泼墨，感受传统艺术的魅力。', requirements: '热爱书画艺术，有无基础均可', deadline: 1713196800000, contactInfo: '王浩然 13800003333 / QQ群: 987654321', posterImage: OnlineImages.ACTIVITY_SHOW, status: 'active', createTime: 1711094400000 },
  { id: 'rec003', clubId: 'c003', clubName: '飞翼足球社', title: '飞翼足球社招募新队员', description: '热爱足球的你，快来加入飞翼足球社！我们有专业的训练计划、定期的友谊赛和校际联赛，让你的足球梦在这里起飞。', requirements: '热爱足球运动，身体健康，男女不限', deadline: 1713196800000, contactInfo: '孙博文 13800007777 / QQ群: 456789123', posterImage: OnlineImages.ACTIVITY_SPORTS, status: 'active', createTime: 1711180800000 },
  { id: 'rec004', clubId: 'c005', clubName: '青年志愿者协会', title: '青年志愿者协会招募志愿者', description: '用爱心温暖世界，用行动传递力量。加入青年志愿者协会，一起参与社区服务、支教活动、环保行动等公益项目。', requirements: '有爱心、有责任感、愿意奉献时间', deadline: 1713196800000, contactInfo: '李思涵 13800002222 / QQ群: 654321789', posterImage: OnlineImages.ACTIVITY_OUTDOOR, status: 'active', createTime: 1711267200000 },
  { id: 'rec005', clubId: 'c006', clubName: '回声音乐社', title: '回声音乐社春季招新', description: '如果你热爱音乐，无论是唱歌、乐器还是音乐制作，回声音乐社都是你的舞台。我们定期举办音乐会和创作比赛。', requirements: '热爱音乐，有一定音乐基础优先', deadline: 1713196800000, contactInfo: '孙博文 13800007777 / QQ群: 789123456', posterImage: OnlineImages.ACTIVITY_SHOW, status: 'active', createTime: 1711353600000 }
]
