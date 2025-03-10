import { NextResponse } from 'next/server'

const reports = []

export async function GET() {
  // 你可以根据 token 或其他身份信息来查询不同用户的日报
  return NextResponse.json(reports)
}

export async function POST(req) {
  const { content } = await req.json()
  const newReport = { id: Date.now(), content, createdAt: new Date() }
  reports.push(newReport)
  return NextResponse.json(newReport)
}
