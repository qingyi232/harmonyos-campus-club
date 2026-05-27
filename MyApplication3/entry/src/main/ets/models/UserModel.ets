/**
 * 用户数据模型
 */
export interface UserInfoInit {
  id?: string;
  username?: string;
  password?: string;
  realName?: string;
  studentId?: string;
  phone?: string;
  email?: string;
  avatar?: string;
  role?: string;
  clubId?: string;
  clubName?: string;
  createTime?: number;
  updateTime?: number;
}

export class UserInfo {
  id: string = '';
  username: string = '';
  password: string = '';
  realName: string = '';
  studentId: string = '';
  phone: string = '';
  email: string = '';
  avatar: string = '';
  role: string = 'student';
  clubId?: string;
  clubName?: string;
  createTime: number = 0;
  updateTime: number = 0;

  constructor(data?: UserInfoInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.username !== undefined) this.username = data.username;
      if (data.password !== undefined) this.password = data.password;
      if (data.realName !== undefined) this.realName = data.realName;
      if (data.studentId !== undefined) this.studentId = data.studentId;
      if (data.phone !== undefined) this.phone = data.phone;
      if (data.email !== undefined) this.email = data.email;
      if (data.avatar !== undefined) this.avatar = data.avatar;
      if (data.role !== undefined) this.role = data.role;
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.createTime !== undefined) this.createTime = data.createTime;
      if (data.updateTime !== undefined) this.updateTime = data.updateTime;
    }
  }

  static toStorageJson(user: UserInfo): string {
    const init: UserInfoInit = {
      id: user.id,
      username: user.username,
      password: user.password,
      realName: user.realName,
      studentId: user.studentId,
      phone: user.phone,
      email: user.email,
      avatar: user.avatar,
      role: user.role,
      clubId: user.clubId,
      clubName: user.clubName,
      createTime: user.createTime,
      updateTime: user.updateTime
    };
    return JSON.stringify(init);
  }

  static fromStorageJson(json: string): UserInfo | null {
    try {
      const o = JSON.parse(json) as UserInfoInit;
      const u: UserInfo = new UserInfo();
      if (o.id !== undefined) u.id = o.id;
      if (o.username !== undefined) u.username = o.username;
      if (o.password !== undefined) u.password = o.password;
      if (o.realName !== undefined) u.realName = o.realName;
      if (o.studentId !== undefined) u.studentId = o.studentId;
      if (o.phone !== undefined) u.phone = o.phone;
      if (o.email !== undefined) u.email = o.email;
      if (o.avatar !== undefined) u.avatar = o.avatar;
      if (o.role !== undefined) u.role = o.role;
      if (o.clubId !== undefined) u.clubId = o.clubId;
      if (o.clubName !== undefined) u.clubName = o.clubName;
      if (o.createTime !== undefined) u.createTime = o.createTime;
      if (o.updateTime !== undefined) u.updateTime = o.updateTime;
      return u;
    } catch {
      return null;
    }
  }
}

/**
 * 登录请求参数
 */
export interface LoginRequestInit {
  username?: string;
  password?: string;
}

export class LoginRequest {
  username: string = '';
  password: string = '';

  constructor(data?: LoginRequestInit) {
    if (data) {
      if (data.username !== undefined) this.username = data.username;
      if (data.password !== undefined) this.password = data.password;
    }
  }
}

/**
 * 登录响应数据
 */
export interface LoginResponseInit {
  token?: string;
  userInfo?: UserInfo;
}

export class LoginResponse {
  token: string = '';
  userInfo: UserInfo = new UserInfo();

  constructor(data?: LoginResponseInit) {
    if (data) {
      if (data.token !== undefined) this.token = data.token;
      if (data.userInfo !== undefined) this.userInfo = data.userInfo;
    }
  }
}

/**
 * 注册请求参数
 */
export interface RegisterRequestInit {
  username?: string;
  password?: string;
  realName?: string;
  studentId?: string;
  phone?: string;
  email?: string;
}

export class RegisterRequest {
  username: string = '';
  password: string = '';
  realName: string = '';
  studentId: string = '';
  phone: string = '';
  email: string = '';

  constructor(data?: RegisterRequestInit) {
    if (data) {
      if (data.username !== undefined) this.username = data.username;
      if (data.password !== undefined) this.password = data.password;
      if (data.realName !== undefined) this.realName = data.realName;
      if (data.studentId !== undefined) this.studentId = data.studentId;
      if (data.phone !== undefined) this.phone = data.phone;
      if (data.email !== undefined) this.email = data.email;
    }
  }
}
