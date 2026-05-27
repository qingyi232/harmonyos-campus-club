// AGC 云函数 - 社团管理服务

/**
 * 获取社团列表
 */
exports.getClubs = async function(event, context) {
  const { category, status, keyword } = event.body || {}
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('ClubInfo')
    
    let condition = {}
    if (status) condition.status = status
    if (category && category !== '全部') condition.category = category
    
    let clubs = await dbWrapper.queryByCondition(condition)
    
    if (keyword) {
      const kw = keyword.toLowerCase()
      clubs = clubs.filter(c => c.name.toLowerCase().includes(kw) || c.description.toLowerCase().includes(kw))
    }
    
    return { code: 200, message: '查询成功', data: clubs }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 申请创建社团
 */
exports.applyClub = async function(event, context) {
  const { userId, userName, clubName, description, category, reason } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('ClubApplication')
    
    const application = {
      id: `ca_${Date.now()}`,
      userId, userName, clubName, description, category, reason,
      status: 'pending',
      reviewerId: '', reviewerName: '', reviewComment: '',
      createTime: Date.now(), reviewTime: 0
    }
    
    await dbWrapper.upsert(application)
    return { code: 200, message: '申请已提交', data: { applicationId: application.id } }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 审核社团申请（管理员）
 */
exports.reviewClubApplication = async function(event, context) {
  const { applicationId, approved, reviewerId, reviewerName, comment } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('ClubApplication')
    
    const apps = await dbWrapper.queryByCondition({ id: applicationId })
    if (apps.length === 0) {
      return { code: 404, message: '申请不存在', data: null }
    }
    
    const app = apps[0]
    app.status = approved ? 'approved' : 'rejected'
    app.reviewerId = reviewerId
    app.reviewerName = reviewerName
    app.reviewComment = comment
    app.reviewTime = Date.now()
    
    await dbWrapper.upsert(app)
    
    // 如果通过，创建社团
    if (approved) {
      await dbWrapper.openCloudDBZone('ClubInfo')
      const newClub = {
        id: `c_${Date.now()}`,
        name: app.clubName, description: app.description,
        category: app.category,
        logo: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=200&h=200&fit=crop',
        coverImage: 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&h=300&fit=crop',
        leaderId: app.userId, leaderName: app.userName,
        memberCount: 1, maxMembers: 100,
        status: 'approved', createTime: Date.now(),
        slogan: '', contactInfo: '', tags: [app.category]
      }
      await dbWrapper.upsert(newClub)
    }
    
    return { code: 200, message: approved ? '已批准' : '已拒绝', data: null }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}
