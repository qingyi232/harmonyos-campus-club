/**
 * 活动数据模型
 */
export interface ActivityInfoInit {
  id?: string;
  clubId?: string;
  clubName?: string;
  title?: string;
  description?: string;
  coverImage?: string;
  location?: string;
  startTime?: number;
  endTime?: number;
  maxParticipants?: number;
  currentParticipants?: number;
  status?: string;
  creatorId?: string;
  creatorName?: string;
  createTime?: number;
  updateTime?: number;
  tags?: string[];
  images?: string[];
  summary?: string;
}

export class ActivityInfo {
  id: string = '';
  clubId: string = '';
  clubName: string = '';
  title: string = '';
  description: string = '';
  coverImage: string = '';
  location: string = '';
  startTime: number = 0;
  endTime: number = 0;
  maxParticipants: number = 0;
  currentParticipants: number = 0;
  status: string = 'draft';
  creatorId: string = '';
  creatorName: string = '';
  createTime: number = 0;
  updateTime: number = 0;
  tags: string[] = [];
  images: string[] = [];
  summary: string = '';

  constructor(data?: ActivityInfoInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.title !== undefined) this.title = data.title;
      if (data.description !== undefined) this.description = data.description;
      if (data.coverImage !== undefined) this.coverImage = data.coverImage;
      if (data.location !== undefined) this.location = data.location;
      if (data.startTime !== undefined) this.startTime = data.startTime;
      if (data.endTime !== undefined) this.endTime = data.endTime;
      if (data.maxParticipants !== undefined) this.maxParticipants = data.maxParticipants;
      if (data.currentParticipants !== undefined) this.currentParticipants = data.currentParticipants;
      if (data.status !== undefined) this.status = data.status;
      if (data.creatorId !== undefined) this.creatorId = data.creatorId;
      if (data.creatorName !== undefined) this.creatorName = data.creatorName;
      if (data.createTime !== undefined) this.createTime = data.createTime;
      if (data.updateTime !== undefined) this.updateTime = data.updateTime;
      if (data.tags !== undefined) this.tags = data.tags;
      if (data.images !== undefined) this.images = data.images;
      if (data.summary !== undefined) this.summary = data.summary;
    }
  }
}

/**
 * 活动申请请求参数
 */
export interface ActivityApplyRequestInit {
  clubId?: string;
  title?: string;
  description?: string;
  coverImage?: string;
  location?: string;
  startTime?: number;
  endTime?: number;
  maxParticipants?: number;
  tags?: string[];
}

export class ActivityApplyRequest {
  clubId: string = '';
  title: string = '';
  description: string = '';
  coverImage: string = '';
  location: string = '';
  startTime: number = 0;
  endTime: number = 0;
  maxParticipants: number = 0;
  tags: string[] = [];

  constructor(data?: ActivityApplyRequestInit) {
    if (data) {
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.title !== undefined) this.title = data.title;
      if (data.description !== undefined) this.description = data.description;
      if (data.coverImage !== undefined) this.coverImage = data.coverImage;
      if (data.location !== undefined) this.location = data.location;
      if (data.startTime !== undefined) this.startTime = data.startTime;
      if (data.endTime !== undefined) this.endTime = data.endTime;
      if (data.maxParticipants !== undefined) this.maxParticipants = data.maxParticipants;
      if (data.tags !== undefined) this.tags = data.tags;
    }
  }
}

/**
 * 活动报名信息
 */
export interface ActivityRegistrationInit {
  id?: string;
  activityId?: string;
  activityTitle?: string;
  userId?: string;
  userName?: string;
  userAvatar?: string;
  studentId?: string;
  phone?: string;
  status?: string;
  registerTime?: number;
  checkInTime?: number;
}

export class ActivityRegistration {
  id: string = '';
  activityId: string = '';
  activityTitle: string = '';
  userId: string = '';
  userName: string = '';
  userAvatar: string = '';
  studentId: string = '';
  phone: string = '';
  status: string = 'registered';
  registerTime: number = 0;
  checkInTime?: number;

  constructor(data?: ActivityRegistrationInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.activityId !== undefined) this.activityId = data.activityId;
      if (data.activityTitle !== undefined) this.activityTitle = data.activityTitle;
      if (data.userId !== undefined) this.userId = data.userId;
      if (data.userName !== undefined) this.userName = data.userName;
      if (data.userAvatar !== undefined) this.userAvatar = data.userAvatar;
      if (data.studentId !== undefined) this.studentId = data.studentId;
      if (data.phone !== undefined) this.phone = data.phone;
      if (data.status !== undefined) this.status = data.status;
      if (data.registerTime !== undefined) this.registerTime = data.registerTime;
      if (data.checkInTime !== undefined) this.checkInTime = data.checkInTime;
    }
  }
}

/**
 * 活动评价
 */
export interface ActivityReviewInit {
  id?: string;
  activityId?: string;
  userId?: string;
  userName?: string;
  userAvatar?: string;
  rating?: number;
  content?: string;
  createTime?: number;
}

export class ActivityReview {
  id: string = '';
  activityId: string = '';
  userId: string = '';
  userName: string = '';
  userAvatar: string = '';
  rating: number = 5;
  content: string = '';
  createTime: number = 0;

  constructor(data?: ActivityReviewInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.activityId !== undefined) this.activityId = data.activityId;
      if (data.userId !== undefined) this.userId = data.userId;
      if (data.userName !== undefined) this.userName = data.userName;
      if (data.userAvatar !== undefined) this.userAvatar = data.userAvatar;
      if (data.rating !== undefined) this.rating = data.rating;
      if (data.content !== undefined) this.content = data.content;
      if (data.createTime !== undefined) this.createTime = data.createTime;
    }
  }
}
