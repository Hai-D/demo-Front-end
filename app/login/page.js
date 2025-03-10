'use client'

// import { useState } from 'react'
// import { useRouter } from 'next/navigation'
// import axios from '../../utils/axios'

// export default function LoginPage() {
//   const [username, setUsername] = useState('')
//   const [password, setPassword] = useState('')
//   const [error, setError] = useState('')
//   const router = useRouter()

//   // 处理登录
//   const handleLogin = async (e) => {
//     e.preventDefault()

//     try {
//       const response = await axios.post('/auth/login', {
//         username,
//         password,
//       })

//       // 登录成功后存储 token 和 username
//       localStorage.setItem('username', username)
//       localStorage.setItem('token', response.data.token)

//       // 跳转到用户的日报页面
//       router.push('/reports') // 根据需要跳转到其他页面
//     } catch (err) {
//       setError('登录失败，请检查用户名或密码')
//     }
//   }

//   return (
//     <div className="min-h-screen p-6 bg-gray-50">
//       <h1 className="text-3xl font-bold text-blue-500 mb-6">登录</h1>
//       {error && <p className="text-red-500">{error}</p>}
//       <form onSubmit={handleLogin} className="mb-4">
//         <input
//           type="text"
//           value={username}
//           onChange={(e) => setUsername(e.target.value)}
//           placeholder="用户名"
//           className="w-full px-4 py-2 border rounded-lg mb-4"
//         />
//         <input
//           type="password"
//           value={password}
//           onChange={(e) => setPassword(e.target.value)}
//           placeholder="密码"
//           className="w-full px-4 py-2 border rounded-lg mb-4"
//         />
//         <button
//           type="submit"
//           className="bg-blue-500 text-white py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
//         >
//           登录
//         </button>
//       </form>
//     </div>
//   )
// }


import { useState } from 'react'
import { useRouter } from 'next/navigation'
import axios from '../../utils/axios'

export default function LoginPage() {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const router = useRouter()

  const handleLogin = async (e) => {
    e.preventDefault()
    try {
      const response = await axios.post('/auth/login', { username, password })
      localStorage.setItem('token', response.data.token)
      localStorage.setItem('username', username)
      router.push('/reports') // 登录成功跳转到日报页面
    } catch (err) {
      setError('用户名或密码错误')
    }
  }

  return (
    <div className="min-h-screen flex justify-center items-center bg-gray-100">
      <div className="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 className="text-2xl font-bold text-center text-blue-500 mb-6">登录</h2>
        {error && <p className="text-red-500 text-center mb-4">{error}</p>}
        <form onSubmit={handleLogin}>
          <div className="mb-4">
            <label className="block text-gray-700 font-semibold">用户名</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
              required
            />
          </div>
          <div className="mb-4">
            <label className="block text-gray-700 font-semibold">密码</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
              required
            />
          </div>
          <button
            type="submit"
            className="w-full bg-blue-500 text-white py-2 rounded-lg shadow-md hover:bg-blue-600 transition duration-300"
          >
            登录
          </button>
        </form>
      </div>
    </div>
  )
}
