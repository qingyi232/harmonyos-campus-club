import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { window } from '@kit.ArkUI'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onCreate')
  }

  onDestroy(): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onWindowStageCreate')
    windowStage.loadContent('pages/auth/LoginPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'ClubManager', 'Failed to load content. Cause: %{public}s', JSON.stringify(err) ?? '')
        return
      }
      hilog.info(0x0000, 'ClubManager', 'Succeeded in loading content.')
    })
  }

  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onWindowStageDestroy')
  }

  onForeground(): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onForeground')
  }

  onBackground(): void {
    hilog.info(0x0000, 'ClubManager', 'Ability onBackground')
  }
}
