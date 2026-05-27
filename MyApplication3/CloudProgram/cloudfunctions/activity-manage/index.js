// AGC 云函数 - 活动管理服务

/**
 * 创建活动
 */
exports.createActivity = async function(event, context) {
  const { clubId, clubName, title, description, location, startTime, endTime, maxParticipants, creatorId, creatorName, tags } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('ActivityInfo')
    
    const activity = {
      id: `a_${Date.now()}`,
      clubId, clubName, title, description,
      coverImage: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=250&fit=crop',
      location, startTime, endTime, maxParticipants,
      currentParticipants: 0, status: 'pending',
      creatorId, creatorName, createTime: Date.now(),
      tags: tags || [], summary: '', photos: []
    }
    
    await dbWrapper.upsert(activity)
    return { code: 200, message: '活动创建成功，等待审核', data: { activityId: activity.id } }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 活动报名
 */
exports.registerActivity = async function(event, context) {
  const { activityId, userId, userName } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    
    // 检查是否已报名
    await dbWrapper.openCloudDBZone('ActivityRegistration')
    const existing = await dbWrapper.queryByCondition({ activityId, userId })
    if (existing.length > 0) {
      return { code: 409, message: '您已报名该活动', data: null }
    }
    
    // 检查活动名额
    await dbWrapper.openCloudDBZone('ActivityInfo')
    const activities = await dbWrapper.queryByCondition({ id: activityId })
    if (activities.length === 0) return { code: 404, message: '活动不存在', data: null }
    
    const activity = activities[0]
    if (activity.currentParticipants >= activity.maxParticipants) {
      return { code: 400, message: '活动名额已满', data: null }
    }
    
    // 创建报名记录
    await dbWrapper.openCloudDBZone('ActivityRegistration')
    const registration = {
      id: `r_${Date.now()}`,
      activityId, activityTitle: activity.title,
      userId, userName,
      registerTime: Date.now(), status: 'registered'
    }
    await dbWrapper.upsert(registration)
    
    // 更新参与人数
    activity.currentParticipants++
    await dbWrapper.openCloudDBZone('ActivityInfo')
    await dbWrapper.upsert(activity)
    
    return { code: 200, message: '报名成功', data: { registrationId: registration.id } }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 审核活动（管理员）
 */
exports.reviewActivity = async function(event, context) {
  const { activityId, approved } = event.body
  
  try {
    const dbWrapper = new (require('./clouddb-wrapper')).CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('ActivityInfo')
    
    const activities = await dbWrapper.queryByCondition({ id: activityId })
    if (activities.length === 0) return { code: 404, message: '活动不存在', data: null }
    
    const activity = activities[0]
    activity.status = approved ? 'approved' : 'rejected'
    await dbWrapper.upsert(activity)
    
    return { code: 200, message: approved ? '已批准' : '已拒绝', data: null }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}
