/**
 * 通用工具类
 */
export class CommonUtil {
  /**
   * 生成唯一ID
   */
  static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substring(2);
  }

  /**
   * 格式化时间戳
   */
  static formatTimestamp(timestamp: number, format: string = 'YYYY-MM-DD HH:mm:ss'): string {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    let result = format;
    result = result.replace('YYYY', String(year));
    result = result.replace('MM', month);
    result = result.replace('DD', day);
    result = result.replace('HH', hours);
    result = result.replace('mm', minutes);
    result = result.replace('ss', seconds);
    return result;
  }

  /**
   * 获取相对时间描述
   */
  static getRelativeTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    const minute = 60 * 1000;
    const hour = 60 * minute;
    const day = 24 * hour;

    if (diff < minute) {
      return '刚刚';
    } else if (diff < hour) {
      return `${Math.floor(diff / minute)}分钟前`;
    } else if (diff < day) {
      return `${Math.floor(diff / hour)}小时前`;
    } else if (diff < 7 * day) {
      return `${Math.floor(diff / day)}天前`;
    } else {
      return CommonUtil.formatTimestamp(timestamp, 'YYYY-MM-DD');
    }
  }

  /**
   * 格式化金额
   */
  static formatAmount(amount: number): string {
    return `¥${amount.toFixed(2)}`;
  }

  /**
   * 手机号脱敏
   */
  static maskPhone(phone: string): string {
    if (!phone || phone.length < 11) return phone;
    return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
  }

  /**
   * 验证手机号
   */
  static isValidPhone(phone: string): boolean {
    return /^1[3-9]\d{9}$/.test(phone);
  }

  /**
   * 验证邮箱
   */
  static isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  /**
   * 获取状态文本
   */
  static getStatusText(status: string, type: 'club' | 'activity' | 'apply'): string {
    if (type === 'club') {
      if (status === 'pending') return '待审核';
      if (status === 'approved') return '已通过';
      if (status === 'rejected') return '已拒绝';
    } else if (type === 'activity') {
      if (status === 'draft') return '草稿';
      if (status === 'pending') return '待审核';
      if (status === 'approved') return '已通过';
      if (status === 'rejected') return '已拒绝';
      if (status === 'ongoing') return '进行中';
      if (status === 'completed') return '已结束';
      if (status === 'cancelled') return '已取消';
    } else if (type === 'apply') {
      if (status === 'pending') return '待审核';
      if (status === 'approved') return '已通过';
      if (status === 'rejected') return '已拒绝';
    }
    return status;
  }

  /**
   * 获取状态颜色
   */
  static getStatusColor(status: string): string {
    if (status === 'pending') return '#FF9800';
    if (status === 'approved') return '#4CAF50';
    if (status === 'rejected') return '#F44336';
    if (status === 'ongoing') return '#2196F3';
    if (status === 'completed') return '#9E9E9E';
    if (status === 'cancelled') return '#757575';
    if (status === 'draft') return '#9E9E9E';
    return '#757575';
  }

  /**
   * 获取财务类型文本
   */
  static getFinanceTypeText(type: string): string {
    return type === 'income' ? '收入' : '支出';
  }

  /**
   * 获取角色文本
   */
  static getRoleText(role: string): string {
    if (role === 'student') return '学生';
    if (role === 'leader') return '社长';
    if (role === 'admin') return '管理员';
    return role;
  }

  /**
   * 获取社团分类列表
   */
  static getClubCategories(): string[] {
    const categories: string[] = [];
    categories.push('科技类');
    categories.push('文艺类');
    categories.push('体育类');
    categories.push('公益类');
    categories.push('学术类');
    categories.push('实践类');
    categories.push('兴趣类');
    return categories;
  }

  /**
   * 获取财务分类列表
   */
  static getFinanceCategories(type: string): string[] {
    const categories: string[] = [];
    if (type === 'income') {
      categories.push('会费收入');
      categories.push('活动经费');
      categories.push('赞助收入');
      categories.push('其他收入');
    } else {
      categories.push('活动支出');
      categories.push('物资采购');
      categories.push('场地租赁');
      categories.push('宣传费用');
      categories.push('其他支出');
    }
    return categories;
  }

  /**
   * 截断文本
   */
  static truncateText(text: string, maxLength: number): string {
    if (!text || text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  }

  /**
   * 防抖函数
   */
  static debounce(func: () => void, delay: number): () => void {
    let timeoutId: number | null = null;
    return (): void => {
      if (timeoutId !== null) {
        clearTimeout(timeoutId);
      }
      timeoutId = setTimeout(() => {
        func();
      }, delay);
    };
  }
}
