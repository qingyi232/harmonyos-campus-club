/**
 * 财务记录数据模型
 */
export interface FinanceRecordInit {
  id?: string;
  clubId?: string;
  clubName?: string;
  type?: string;
  category?: string;
  amount?: number;
  description?: string;
  proofImage?: string;
  operatorId?: string;
  operatorName?: string;
  createTime?: number;
  updateTime?: number;
}

export class FinanceRecord {
  id: string = '';
  clubId: string = '';
  clubName: string = '';
  type: string = 'expense';
  category: string = '';
  amount: number = 0;
  description: string = '';
  proofImage: string = '';
  operatorId: string = '';
  operatorName: string = '';
  createTime: number = 0;
  updateTime: number = 0;

  constructor(data?: FinanceRecordInit) {
    if (data) {
      if (data.id !== undefined) this.id = data.id;
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.type !== undefined) this.type = data.type;
      if (data.category !== undefined) this.category = data.category;
      if (data.amount !== undefined) this.amount = data.amount;
      if (data.description !== undefined) this.description = data.description;
      if (data.proofImage !== undefined) this.proofImage = data.proofImage;
      if (data.operatorId !== undefined) this.operatorId = data.operatorId;
      if (data.operatorName !== undefined) this.operatorName = data.operatorName;
      if (data.createTime !== undefined) this.createTime = data.createTime;
      if (data.updateTime !== undefined) this.updateTime = data.updateTime;
    }
  }
}

export interface FinanceRecordRequest {
  clubId: string;
  type: string;
  category: string;
  amount: number;
  description: string;
  proofImage: string;
}

export interface FinanceStatisticsInit {
  clubId?: string;
  clubName?: string;
  totalIncome?: number;
  totalExpense?: number;
  balance?: number;
  incomeRecords?: FinanceRecord[];
  expenseRecords?: FinanceRecord[];
  monthIncome?: number;
  monthExpense?: number;
}

export class FinanceStatistics {
  clubId: string = '';
  clubName: string = '';
  totalIncome: number = 0;
  totalExpense: number = 0;
  balance: number = 0;
  incomeRecords: FinanceRecord[] = [];
  expenseRecords: FinanceRecord[] = [];
  monthIncome: number = 0;
  monthExpense: number = 0;

  constructor(data?: FinanceStatisticsInit) {
    if (data) {
      if (data.clubId !== undefined) this.clubId = data.clubId;
      if (data.clubName !== undefined) this.clubName = data.clubName;
      if (data.totalIncome !== undefined) this.totalIncome = data.totalIncome;
      if (data.totalExpense !== undefined) this.totalExpense = data.totalExpense;
      if (data.balance !== undefined) this.balance = data.balance;
      if (data.incomeRecords !== undefined) this.incomeRecords = data.incomeRecords;
      if (data.expenseRecords !== undefined) this.expenseRecords = data.expenseRecords;
      if (data.monthIncome !== undefined) this.monthIncome = data.monthIncome;
      if (data.monthExpense !== undefined) this.monthExpense = data.monthExpense;
    }
  }
}
