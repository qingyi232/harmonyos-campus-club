// AGC 云函数 - 财务管理服务

/**
 * 添加财务记录
 */
exports.addFinanceRecord = async function(event, context) {
  const { clubId, clubName, type, amount, description, category, receipt, operatorId, operatorName } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('FinanceRecord')
    
    const record = {
      id: `f_${Date.now()}`,
      clubId, clubName, type, amount, description, category,
      receipt: receipt || '',
      operatorId, operatorName,
      createTime: Date.now()
    }
    
    await dbWrapper.upsert(record)
    return { code: 200, message: '记录添加成功', data: { recordId: record.id } }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 获取社团财务记录
 */
exports.getFinanceRecords = async function(event, context) {
  const { clubId } = event.body || {}
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('FinanceRecord')
    
    let condition = {}
    if (clubId) condition.clubId = clubId
    
    const records = await dbWrapper.queryByCondition(condition)
    
    // 计算统计数据
    let totalIncome = 0, totalExpense = 0
    records.forEach(r => {
      if (r.type === 'income') totalIncome += r.amount
      else totalExpense += r.amount
    })
    
    return {
      code: 200,
      message: '查询成功',
      data: {
        records,
        summary: { totalIncome, totalExpense, balance: totalIncome - totalExpense }
      }
    }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 获取所有社团财务概览（管理员）
 */
exports.getFinanceOverview = async function(event, context) {
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('FinanceRecord')
    
    const allRecords = await dbWrapper.queryByCondition({})
    
    // 按社团分组统计
    const clubStats = {}
    allRecords.forEach(r => {
      if (!clubStats[r.clubId]) {
        clubStats[r.clubId] = { clubId: r.clubId, clubName: r.clubName, income: 0, expense: 0 }
      }
      if (r.type === 'income') clubStats[r.clubId].income += r.amount
      else clubStats[r.clubId].expense += r.amount
    })
    
    const overview = Object.values(clubStats).map(s => ({
      ...s,
      balance: s.income - s.expense
    }))
    
    return { code: 200, message: '查询成功', data: overview }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}
