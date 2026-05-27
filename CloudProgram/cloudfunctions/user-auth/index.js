// AGC 云函数 - 用户认证服务
// 部署到华为AGC平台的云函数

const { CloudDBZoneWrapper } = require('./clouddb-wrapper')

/**
 * 用户登录
 */
exports.login = async function(event, context) {
  const { username, password } = event.body
  
  try {
    const dbWrapper = new CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('UserInfo')
    
    const users = await dbWrapper.queryByCondition({
      username: username,
      password: password
    })
    
    if (users.length > 0) {
      const user = users[0]
      // 生成token（实际使用AGC认证服务）
      const token = Buffer.from(`${user.id}:${Date.now()}`).toString('base64')
      
      return {
        code: 200,
        message: '登录成功',
        data: {
          token: token,
          userInfo: {
            id: user.id,
            username: user.username,
            realName: user.realName,
            role: user.role,
            avatar: user.avatar,
            college: user.college,
            major: user.major
          }
        }
      }
    } else {
      return { code: 401, message: '用户名或密码错误', data: null }
    }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}

/**
 * 用户注册
 */
exports.register = async function(event, context) {
  const { username, password, realName, studentId, phone, college, major, grade } = event.body
  
  try {
    const dbWrapper = new CloudDBZoneWrapper()
    await dbWrapper.openCloudDBZone('UserInfo')
    
    // 检查用户名是否已存在
    const existing = await dbWrapper.queryByCondition({ username: username })
    if (existing.length > 0) {
      return { code: 409, message: '用户名已存在', data: null }
    }
    
    // 创建新用户
    const newUser = {
      id: `u_${Date.now()}`,
      username, password, realName, studentId, phone,
      email: `${username}@campus.edu.cn`,
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop',
      role: 'student',
      college, major, grade,
      createTime: Date.now()
    }
    
    await dbWrapper.upsert(newUser)
    
    return { code: 200, message: '注册成功', data: { userId: newUser.id } }
  } catch (error) {
    return { code: 500, message: `服务器错误: ${error.message}`, data: null }
  }
}
