// 日期格式化工具
export class DateUtil {
  static format(timestamp: number, pattern: string = 'YYYY-MM-DD'): string {
    const date = new Date(timestamp)
    const year = date.getFullYear().toString()
    const month = (date.getMonth() + 1).toString().padStart(2, '0')
    const day = date.getDate().toString().padStart(2, '0')
    const hour = date.getHours().toString().padStart(2, '0')
    const minute = date.getMinutes().toString().padStart(2, '0')
    return pattern
      .replace('YYYY', year)
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hour)
      .replace('mm', minute)
  }

  static formatDate(timestamp: number): string {
    return DateUtil.format(timestamp, 'YYYY-MM-DD')
  }

  static formatDateTime(timestamp: number): string {
    return DateUtil.format(timestamp, 'YYYY-MM-DD HH:mm')
  }

  static formatRelative(timestamp: number): string {
    const now = Date.now()
    const diff = now - timestamp
    if (diff < 60000) return '刚刚'
    if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`
    if (diff < 86400000) return `${Math.floor(diff / 3600000)}小时前`
    if (diff < 604800000) return `${Math.floor(diff / 86400000)}天前`
    return DateUtil.formatDate(timestamp)
  }
}
