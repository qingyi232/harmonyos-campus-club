/**
 * 社团数据模型
 */
export interface ClubInfoInit {
  id?: string;
  name?: string;
  logo?: string;
  category?: string;
  description?: string;
  leaderId?: string;
  leaderName?: string;
  memberCount?: number;
  maxMembers?: number;
  status?: string;
  createTime?: number;
  updateTime?: number;
  tags?: string[];
  images?: string[];
  contactInfo?: string;
}

export class ClubInfo {
  id: string = '';
  name: string = '';
  logo: string = '';
  category: string = '';
  description: string = '';
  leaderId: string = '';
  leaderName: string = '';
  memberCount: number = 0;
  maxMembers: number = 100;
  status: string = 'pending';
  createTime: number = 0;
  updateTime: number = 0;
  tags: string[] = [];
  images: string[] = [];
  contactInfo: string = '';

  constructor(data?: ClubInfoInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.name !== undefined) this.name = data.name;
      if (data.logo !== undefined) this.logo = data.logo;
      if (data.category !== undefined) this.category = data.category;
      if (data.description !== undefined) this.description = data.description;
      if (data.leaderId !== undefined) this.leaderId = data.leaderId;
      if (data.leaderName !== undefined) this.leaderName = data.leaderName;
      if (data.memberCount !== undefined) this.memberCount = data.memberCount;
      if (data.maxMembers !== undefined) this.maxMembers = data.maxMembers;
      if (data.status !== undefined) this.status = data.status;
      if (data.createTime !== undefined) this.createTime = data.createTime;
      if (data.updateTime !== undefined) this.updateTime = data.updateTime;
      if (data.tags !== undefined) this.tags = data.tags;
      if (data.images !== undefined) this.images = data.images;
      if (data.contactInfo !== undefined) this.contactInfo = data.contactInfo;
    }
  }
}

/**
 * 社团申请请求参数
 */
export interface ClubApplyRequestInit {
  name?: string;
  category?: string;
  description?: string;
  logo?: string;
  tags?: string[];
}

export class ClubApplyRequest {
  name: string = '';
  category: string = '';
  description: string = '';
  logo: string = '';
  tags: string[] = [];

  constructor(data?: ClubApplyRequestInit) {
    if (data) {
      if (data.name !== undefined) this.name = data.name;
      if (data.category !== undefined) this.category = data.category;
      if (data.description !== undefined) this.description = data.description;
      if (data.logo !== undefined) this.logo = data.logo;
      if (data.tags !== undefined) this.tags = data.tags;
    }
  }
}

/**
 * 社团成员信息
 */
export interface ClubMemberInit {
  id?: string;
  clubId?: string;
  userId?: string;
  userName?: string;
  userAvatar?: string;
  studentId?: string;
  phone?: string;
  role?: string;
  status?: string;
  joinTime?: number;
}

export class ClubMember {
  id: string = '';
  clubId: string = '';
  userId: string = '';
  userName: string = '';
  userAvatar: string = '';
  studentId: string = '';
  phone: string = '';
  role: string = 'member';
  status: string = 'active';
  joinTime: number = 0;

  constructor(data?: ClubMemberInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.userId !== undefined) this.userId = data.userId;
      if (data.userName !== undefined) this.userName = data.userName;
      if (data.userAvatar !== undefined) this.userAvatar = data.userAvatar;
      if (data.studentId !== undefined) this.studentId = data.studentId;
      if (data.phone !== undefined) this.phone = data.phone;
      if (data.role !== undefined) this.role = data.role;
      if (data.status !== undefined) this.status = data.status;
      if (data.joinTime !== undefined) this.joinTime = data.joinTime;
    }
  }
}

/**
 * 社团招新申请
 */
export interface ClubRecruitmentInit {
  id?: string;
  clubId?: string;
  clubName?: string;
  title?: string;
  description?: string;
  requirements?: string;
  maxRecruits?: number;
  currentRecruits?: number;
  status?: string;
  startTime?: number;
  endTime?: number;
  createTime?: number;
}

export class ClubRecruitment {
  id: string = '';
  clubId: string = '';
  clubName: string = '';
  title: string = '';
  description: string = '';
  requirements: string = '';
  maxRecruits: number = 0;
  currentRecruits: number = 0;
  status: string = 'active';
  startTime: number = 0;
  endTime: number = 0;
  createTime: number = 0;

  constructor(data?: ClubRecruitmentInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.title !== undefined) this.title = data.title;
      if (data.description !== undefined) this.description = data.description;
      if (data.requirements !== undefined) this.requirements = data.requirements;
      if (data.maxRecruits !== undefined) this.maxRecruits = data.maxRecruits;
      if (data.currentRecruits !== undefined) this.currentRecruits = data.currentRecruits;
      if (data.status !== undefined) this.status = data.status;
      if (data.startTime !== undefined) this.startTime = data.startTime;
      if (data.endTime !== undefined) this.endTime = data.endTime;
      if (data.createTime !== undefined) this.createTime = data.createTime;
    }
  }
}
