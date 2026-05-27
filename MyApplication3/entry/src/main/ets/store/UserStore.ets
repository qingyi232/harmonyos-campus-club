import { UserInfo } from '../models/UserModel';
import { StorageUtil } from '../utils/StorageUtil';
import { Constants } from '../common/Constants';

/**
 * 用户状态管理
 */
export class UserStore {
  private static instance: UserStore;
  
  private _userInfo: UserInfo | null = null;
  private _token: string = '';
  private _isLogin: boolean = false;

  private constructor() {}

  static getInstance(): UserStore {
    if (!UserStore.instance) {
      UserStore.instance = new UserStore();
    }
    return UserStore.instance;
  }

  /**
   * 初始化用户状态
   */
  async init(): Promise<void> {
    try {
      const isLogin = await StorageUtil.getBoolean(Constants.KEY_IS_LOGIN, false);
      this._isLogin = isLogin;
      
      if (this._isLogin) {
        const userJson = await StorageUtil.getString(Constants.KEY_USER_INFO, '');
        const token = await StorageUtil.getString(Constants.KEY_TOKEN, '');
        const userInfo = userJson.length > 0 ? UserInfo.fromStorageJson(userJson) : null;
        
        if (userInfo && token.length > 0) {
          this._userInfo = userInfo;
          this._token = token;
        } else {
          await this.logout();
        }
      }
    } catch (err) {
      console.error('UserStore init failed:', JSON.stringify(err));
    }
  }

  /**
   * 登录
   */
  async login(userInfo: UserInfo, token: string): Promise<void> {
    this._userInfo = userInfo;
    this._token = token;
    this._isLogin = true;
    
    await StorageUtil.put(Constants.KEY_USER_INFO, UserInfo.toStorageJson(userInfo));
    await StorageUtil.put(Constants.KEY_TOKEN, token);
    await StorageUtil.put(Constants.KEY_IS_LOGIN, true);
  }

  /**
   * 登出
   */
  async logout(): Promise<void> {
    this._userInfo = null;
    this._token = '';
    this._isLogin = false;
    
    await StorageUtil.delete(Constants.KEY_USER_INFO);
    await StorageUtil.delete(Constants.KEY_TOKEN);
    await StorageUtil.delete(Constants.KEY_IS_LOGIN);
  }

  /**
   * 更新用户信息
   */
  async updateUserInfo(userInfo: UserInfo): Promise<void> {
    this._userInfo = userInfo;
    await StorageUtil.put(Constants.KEY_USER_INFO, UserInfo.toStorageJson(userInfo));
  }

  get userInfo(): UserInfo | null {
    return this._userInfo;
  }

  get token(): string {
    return this._token;
  }

  get isLogin(): boolean {
    return this._isLogin;
  }

  get isStudent(): boolean {
    return this._userInfo?.role === Constants.ROLE_STUDENT;
  }

  get isLeader(): boolean {
    return this._userInfo?.role === Constants.ROLE_LEADER;
  }

  get isAdmin(): boolean {
    return this._userInfo?.role === Constants.ROLE_ADMIN;
  }

  get userId(): string {
    return this._userInfo?.id || '';
  }

  get userName(): string {
    return this._userInfo?.realName || '';
  }

  get userAvatar(): string {
    return this._userInfo?.avatar || '';
  }

  get clubId(): string {
    return this._userInfo?.clubId || '';
  }

  get clubName(): string {
    return this._userInfo?.clubName || '';
  }
}

// 导出单例实例
export const userStore = UserStore.getInstance();
