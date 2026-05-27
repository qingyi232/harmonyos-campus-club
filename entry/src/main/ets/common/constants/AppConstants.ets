// ==================== 主题常量 - 清新校园风格 ====================

// 主色调：清新绿色系，体现校园活力与自然感
export class AppColors {
  // 主色
  static readonly PRIMARY: string = '#2ECC71'          // 翠绿色 - 主色调
  static readonly PRIMARY_DARK: string = '#27AE60'     // 深绿色
  static readonly PRIMARY_LIGHT: string = '#A8E6CF'    // 浅绿色
  static readonly PRIMARY_BG: string = '#F0FFF4'       // 极浅绿背景

  // 辅助色
  static readonly ACCENT: string = '#3498DB'           // 天空蓝 - 辅助色
  static readonly ACCENT_LIGHT: string = '#D6EAF8'     // 浅蓝色
  static readonly WARNING: string = '#F39C12'          // 暖橙色 - 警告
  static readonly DANGER: string = '#E74C3C'           // 红色 - 危险
  static readonly SUCCESS: string = '#2ECC71'          // 绿色 - 成功
  static readonly INFO: string = '#17A2B8'             // 青色 - 信息

  // 中性色
  static readonly TEXT_PRIMARY: string = '#2C3E50'     // 主文字 - 深灰蓝
  static readonly TEXT_SECONDARY: string = '#7F8C8D'   // 次要文字
  static readonly TEXT_HINT: string = '#BDC3C7'        // 提示文字
  static readonly TEXT_WHITE: string = '#FFFFFF'        // 白色文字

  // 背景色
  static readonly BG_PAGE: string = '#F5F7FA'          // 页面背景
  static readonly BG_CARD: string = '#FFFFFF'          // 卡片背景
  static readonly BG_SECTION: string = '#FAFBFC'       // 区块背景
  static readonly BG_INPUT: string = '#F8F9FA'         // 输入框背景

  // 边框色
  static readonly BORDER: string = '#E8ECF0'           // 边框色
  static readonly BORDER_LIGHT: string = '#F0F2F5'     // 浅边框
  static readonly DIVIDER: string = '#EBEEF5'          // 分割线

  // 标签色
  static readonly TAG_RED: string = '#FFE8E8'
  static readonly TAG_GREEN: string = '#E8F8EE'
  static readonly TAG_BLUE: string = '#E8F0FE'
  static readonly TAG_ORANGE: string = '#FFF3E0'
  static readonly TAG_PURPLE: string = '#F3E8FF'
}

// 字体大小
export class AppFontSize {
  static readonly TITLE_LARGE: number = 24
  static readonly TITLE: number = 20
  static readonly SUBTITLE: number = 17
  static readonly BODY: number = 15
  static readonly CAPTION: number = 13
  static readonly SMALL: number = 11
}

// 间距
export class AppSpacing {
  static readonly XS: number = 4
  static readonly SM: number = 8
  static readonly MD: number = 12
  static readonly LG: number = 16
  static readonly XL: number = 20
  static readonly XXL: number = 24
  static readonly XXXL: number = 32
}

// 圆角
export class AppRadius {
  static readonly SM: number = 6
  static readonly MD: number = 10
  static readonly LG: number = 14
  static readonly XL: number = 20
  static readonly ROUND: number = 999
}

// 社团分类
export class ClubCategories {
  static readonly ALL: string[] = [
    '学术科技', '文化艺术', '体育运动', '志愿公益',
    '创新创业', '语言交流', '音乐舞蹈', '摄影传媒'
  ]
}

// 在线图片资源 - 校园社团相关
export class OnlineImages {
  // 社团Logo
  static readonly CLUB_TECH: string = 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=200&h=200&fit=crop'
  static readonly CLUB_ART: string = 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=200&h=200&fit=crop'
  static readonly CLUB_SPORT: string = 'https://images.unsplash.com/photo-1461896836934-bd45ba8fcf9b?w=200&h=200&fit=crop'
  static readonly CLUB_MUSIC: string = 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=200&h=200&fit=crop'
  static readonly CLUB_PHOTO: string = 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=200&h=200&fit=crop'
  static readonly CLUB_VOLUNTEER: string = 'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=200&h=200&fit=crop'
  static readonly CLUB_LANGUAGE: string = 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=200&h=200&fit=crop'
  static readonly CLUB_INNOVATION: string = 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=200&h=200&fit=crop'

  // 活动封面
  static readonly ACTIVITY_LECTURE: string = 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=250&fit=crop'
  static readonly ACTIVITY_COMPETITION: string = 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400&h=250&fit=crop'
  static readonly ACTIVITY_OUTDOOR: string = 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400&h=250&fit=crop'
  static readonly ACTIVITY_SHOW: string = 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=250&fit=crop'
  static readonly ACTIVITY_WORKSHOP: string = 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=250&fit=crop'
  static readonly ACTIVITY_SPORTS: string = 'https://images.unsplash.com/photo-1461896836934-bd45ba8fcf9b?w=400&h=250&fit=crop'

  // 用户头像
  static readonly AVATAR_DEFAULT: string = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop'
  static readonly AVATAR_MALE: string = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop'
  static readonly AVATAR_FEMALE: string = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop'

  // Banner
  static readonly BANNER_CAMPUS: string = 'https://images.unsplash.com/photo-1562774053-701939374585?w=800&h=300&fit=crop'
  static readonly BANNER_CLUB: string = 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&h=300&fit=crop'
  static readonly BANNER_ACTIVITY: string = 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&h=300&fit=crop'

  // 空状态
  static readonly EMPTY_STATE: string = 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=300&h=300&fit=crop'

  // 登录页背景
  static readonly LOGIN_BG: string = 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=1080&h=1920&fit=crop'
}
