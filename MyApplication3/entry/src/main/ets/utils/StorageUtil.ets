import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

/**
 * 数据存储工具类
 */
export class StorageUtil {
  private static preferencesStore: preferences.Preferences | null = null;
  private static readonly STORE_NAME = 'club_management_store';

  /**
   * 初始化存储
   */
  static async init(context: Context): Promise<void> {
    try {
      StorageUtil.preferencesStore = await preferences.getPreferences(context, StorageUtil.STORE_NAME);
    } catch (err) {
      console.error('StorageUtil init failed:', JSON.stringify(err));
    }
  }

  /**
   * 保存数据
   */
  static async put(key: string, value: Object | string | number | boolean): Promise<boolean> {
    try {
      if (!StorageUtil.preferencesStore) {
        console.warn('StorageUtil not initialized');
        return false;
      }
      await StorageUtil.preferencesStore.put(key, value as preferences.ValueType);
      await StorageUtil.preferencesStore.flush();
      return true;
    } catch (err) {
      console.error('StorageUtil put failed:', JSON.stringify(err));
      return false;
    }
  }

  /**
   * 读取布尔（Preferences 仅支持 ValueType，复杂对象请用 JSON 字符串自行序列化）
   */
  static async getBoolean(key: string, defaultValue: boolean): Promise<boolean> {
    try {
      if (!StorageUtil.preferencesStore) {
        console.warn('StorageUtil not initialized');
        return defaultValue;
      }
      const value = await StorageUtil.preferencesStore.get(key, defaultValue);
      if (typeof value === 'boolean') {
        return value;
      }
      return defaultValue;
    } catch (err) {
      console.error('StorageUtil getBoolean failed:', JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 读取字符串
   */
  static async getString(key: string, defaultValue: string = ''): Promise<string> {
    try {
      if (!StorageUtil.preferencesStore) {
        console.warn('StorageUtil not initialized');
        return defaultValue;
      }
      const value = await StorageUtil.preferencesStore.get(key, defaultValue);
      if (typeof value === 'string') {
        return value;
      }
      return defaultValue;
    } catch (err) {
      console.error('StorageUtil getString failed:', JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 删除数据
   */
  static async delete(key: string): Promise<boolean> {
    try {
      if (!StorageUtil.preferencesStore) {
        console.warn('StorageUtil not initialized');
        return false;
      }
      await StorageUtil.preferencesStore.delete(key);
      await StorageUtil.preferencesStore.flush();
      return true;
    } catch (err) {
      console.error('StorageUtil delete failed:', JSON.stringify(err));
      return false;
    }
  }

  /**
   * 清空所有数据
   */
  static async clear(): Promise<boolean> {
    try {
      if (!StorageUtil.preferencesStore) {
        console.warn('StorageUtil not initialized');
        return false;
      }
      await StorageUtil.preferencesStore.clear();
      await StorageUtil.preferencesStore.flush();
      return true;
    } catch (err) {
      console.error('StorageUtil clear failed:', JSON.stringify(err));
      return false;
    }
  }
}
