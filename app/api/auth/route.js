import { NextResponse } from 'next/server'

export async function POST(req) {
  const { username, password } = await req.json()
  
  // 这里可以添加数据库查询和身份验证的逻辑
  if (username === 'admin' && password === 'password') {
    return NextResponse.json({ token: 'fake-jwt-token' }) // 返回token
  }
  
  return NextResponse.json({ message: '用户名或密码错误' }, { status: 401 })
}
