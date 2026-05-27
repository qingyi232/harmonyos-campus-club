import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { userStore } from '../store/UserStore';
import { StorageUtil } from '../utils/StorageUtil';
import { AppTheme } from '../theme/AppTheme';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 初始化存储
    await StorageUtil.init(this.context);
    
    // 初始化用户状态
    await userStore.init();
    
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // 设置主窗口为全屏
    windowStage.getMainWindow((err: BusinessError, mainWindow) => {
      if (err.code) {
        return;
      }
      mainWindow.setWindowLayoutFullScreen(true)
        .then(() => {
          hilog.info(0x0000, 'testTag', 'Set window layout full screen success.');
        })
        .catch((err: BusinessError) => {
          hilog.error(0x0000, 'testTag', `Failed to set window layout full screen. Code: ${err.code}, message: ${err.message}`);
        });
    });

    windowStage.loadContent('pages/Index', (err: BusinessError) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', `Failed to load content. Code: ${err.code}, message: ${err.message}`);
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

}
