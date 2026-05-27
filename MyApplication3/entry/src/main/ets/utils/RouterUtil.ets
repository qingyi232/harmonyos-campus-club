import { router } from '@kit.ArkUI';
import { Constants } from '../common/Constants';
import { ClubIdRouteParam, ActivityIdRouteParam } from '../models/RouteParams';

export type RouteParams = ClubIdRouteParam | ActivityIdRouteParam;

/**
 * 路由导航工具类
 */
export class RouterUtil {
  /**
   * 页面跳转
   */
  static async push(url: string, params?: RouteParams): Promise<void> {
    try {
      await router.pushUrl({
        url: url,
        params: params
      });
    } catch (err) {
      console.error('RouterUtil push failed:', JSON.stringify(err));
    }
  }

  /**
   * 页面替换
   */
  static async replace(url: string, params?: RouteParams): Promise<void> {
    try {
      await router.replaceUrl({
        url: url,
        params: params
      });
    } catch (err) {
      console.error('RouterUtil replace failed:', JSON.stringify(err));
    }
  }

  /**
   * 返回上一页
   */
  static async back(): Promise<void> {
    try {
      await router.back();
    } catch (err) {
      console.error('RouterUtil back failed:', JSON.stringify(err));
    }
  }

  /**
   * 返回指定页面
   */
  static async backTo(url: string): Promise<void> {
    try {
      await router.back({
        url: url
      });
    } catch (err) {
      console.error('RouterUtil backTo failed:', JSON.stringify(err));
    }
  }

  /**
   * 清空路由栈并跳转
   */
  static async clearAndPush(url: string, params?: RouteParams): Promise<void> {
    try {
      await router.clear();
      await router.pushUrl({
        url: url,
        params: params
      });
    } catch (err) {
      console.error('RouterUtil clearAndPush failed:', JSON.stringify(err));
    }
  }

  /**
   * 获取页面参数
   */
  static getParams(): Object {
    try {
      return router.getParams() as Object;
    } catch (err) {
      console.error('RouterUtil getParams failed:', JSON.stringify(err));
      return new Object();
    }
  }

  /**
   * 跳转到登录页
   */
  static async toLogin(): Promise<void> {
    await RouterUtil.clearAndPush(Constants.ROUTE_LOGIN);
  }

  /**
   * 跳转到首页
   */
  static async toHome(): Promise<void> {
    await RouterUtil.clearAndPush(Constants.ROUTE_HOME);
  }
}
