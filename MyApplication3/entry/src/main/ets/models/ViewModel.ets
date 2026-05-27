/**
 * 页面展示模型
 */
export class TabItem {
  title: string = '';
  icon: string = '';
  iconActive: string = '';
  /** 本地可见图标（与网络图标并存，避免远程加载失败时底栏空白） */
  glyph: string = '';

  constructor(title: string = '', icon: string = '', iconActive: string = '', glyph: string = '') {
    this.title = title;
    this.icon = icon;
    this.iconActive = iconActive;
    this.glyph = glyph;
  }
}

export class StatusTabItem {
  label: string = '';
  value: string = '';

  constructor(label: string = '', value: string = '') {
    this.label = label;
    this.value = value;
  }
}

export class LabelValueItem {
  label: string = '';
  value: string = '';

  constructor(label: string = '', value: string = '') {
    this.label = label;
    this.value = value;
  }
}