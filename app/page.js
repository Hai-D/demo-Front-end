'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'

export default function HomePage() {
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const router = useRouter()

  // 检查是否已登录
  useEffect(() => {
    const token = localStorage.getItem('token')
    if (token) {
      setIsAuthenticated(true)
      router.push('/reports')  // 如果已经登录，跳转到日报页面
    }
  }, [router])

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="text-center p-6 bg-white shadow-md rounded-lg max-w-lg w-full">
        <h1 className="text-3xl font-bold text-blue-500 mb-4">欢迎来到日报管理系统</h1>
        <p className="text-lg mb-6">请登录后查看和提交您的日报。</p>
        <button
          onClick={() => router.push('/login')}
          className="bg-blue-500 text-white py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-300 cursor-pointer"
        >
          登录
        </button>
      </div>
    </div>
  )
}
