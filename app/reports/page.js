
'use client'
import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import axios from '../../utils/axios'

export default function ReportsPage() {
  const [reports, setReports] = useState([])
  const [newReport, setNewReport] = useState('')
  const [editingReportId, setEditingReportId] = useState(null)  // 用于标记哪个报告处于编辑状态
  const [updatedContent, setUpdatedContent] = useState('')
  const [successMessage, setSuccessMessage] = useState('') // 提交成功提示
  const router = useRouter()
  const [error, setError] = useState("")
  const [inputError, setInputError] = useState(false)
  const [updateError, setUpdateError] = useState(false) // 修改时的错误提示

  // 获取当前用户的日报
  useEffect(() => {
    const token = localStorage.getItem('token')
    const username = localStorage.getItem('username')
    if (!token) {
      router.push('/login')  // 如果没有登录 token，跳转到登录页面
    } else {
      axios.get(`/reports/${username}`)
        .then(response => {
          setReports(response.data)
        })
        .catch(err => {
          setError('无法获取日报')
        })
    }
  }, [router])

  // 显示提示信息（3秒后自动消失）
  const showSuccessMessage = (message) => {
    setSuccessMessage(message)
    setTimeout(() => {
      setSuccessMessage('')
    }, 3000)
  }

  // 提交日报
  const handleSubmitReport = async (e) => {
    e.preventDefault()
    
    if (!newReport.trim()) {
      setInputError(true) // 显示错误提示
      return
    }

    const token = localStorage.getItem('token')
    const username = localStorage.getItem('username')
    if (!token) {
      router.push('/login')  // 如果没有登录 token，跳转到登录页面
    }

    try {
      await axios.post(`/reports/${username}`, { content: newReport })  // 提交日报
      setNewReport('')  // 清空输入框
      setInputError(false) // 移除错误状态
      showSuccessMessage('日报提交成功')

      // 重新获取日报
      axios.get(`/reports/${username}`).then(response => {
        setReports(response.data)
      })
    } catch (err) {
      setError('提交日报失败')
    }
  }

  // 删除日报
  const handleDeleteReport = async (id) => {
    try {
      await axios.delete(`/reports/${id}`)
      showSuccessMessage('删除成功')

      // 重新获取日报
      setReports(reports.filter(report => report.id !== id))
    } catch (err) {
      setError('删除日报失败')
    }
  }

  // 开始编辑日报
  const handleEditReport = (id, content) => {
    setEditingReportId(id)  // 设置当前编辑的日报 ID
    setUpdatedContent(content)  // 设置编辑框的内容为当前日报内容
    setUpdateError(false) // 清除编辑时的错误提示
  }

  // 提交修改后的日报
  const handleUpdateReport = async (id) => {
    if (!updatedContent.trim()) {
      setUpdateError(true) // 如果修改内容为空，显示错误提示
      return
    }

    try {
      await axios.put(`/reports/${id}`, { content: updatedContent })
      showSuccessMessage('更新成功')

      // 重新获取日报
      const updatedReports = reports.map(report =>
        report.id === id ? { ...report, content: updatedContent } : report
      )
      setReports(updatedReports)
      setEditingReportId(null)  // 清除编辑状态
      setUpdatedContent('')  // 清空内容
    } catch (err) {
      setError('更新日报失败')
    }
  }

  return (
    <div className="min-h-screen p-6 bg-gray-50">
      <h1 className="text-3xl font-bold text-blue-500 mb-6">我的日报</h1>
      {error && <p className="text-red-500">{error}</p>}

      {/* 成功提示框 */}
      {successMessage && (
        <div className="mb-4 p-3 bg-green-100 text-green-700 border border-green-400 rounded">
          {successMessage}
        </div>
      )}
      
      <form onSubmit={handleSubmitReport} className="mb-4">
        <textarea
          value={newReport}
          onChange={(e) => { 
            setNewReport(e.target.value) 
            setInputError(false)   
          }}
          rows="4"
          className={`w-full px-4 py-2 border rounded-lg mb-2 ${
            inputError ? 'border-red-500' : 'border-gray-300'
          }`}
          placeholder="输入您的日报内容"
        />
        {inputError && <p className="text-red-500 text-sm">请输入日报内容</p>}
        <button
          type="submit"
          className="bg-blue-500 text-white py-2 px-4 rounded-lg shadow-md hover:bg-blue-600 transition duration-300 cursor-pointer"
        >
          提交日报
        </button>
      </form>

      <h2 className="text-xl font-semibold mb-4">我的日报</h2>
      <ul>
        {reports.map(report => (
          <li key={report.id} className="mb-2 p-4 bg-white shadow-md rounded-lg">
            {editingReportId === report.id ? (
              // 编辑模式
              <>
                <textarea
                  value={updatedContent}
                  onChange={(e) => setUpdatedContent(e.target.value)}
                  rows="4"
                  className="w-full px-4 py-2 border rounded-lg mb-4"
                />
                {updateError && <p className="text-red-500 text-sm">内容不能为空</p>} {/* 修改内容为空时的提示 */}
                <button
                  onClick={() => handleUpdateReport(report.id)}
                  className="bg-green-500 text-white py-1 px-4 rounded-lg cursor-pointer"
                >
                  保存修改
                </button>
                
              </>
            ) : (
              // 普通模式
              <>
                <p>{report.content}</p>
                <small className="text-gray-500">{new Date(report.createdAt).toLocaleString()}</small>
                <div className="flex justify-end mt-2">
                  <button
                    onClick={() => handleEditReport(report.id, report.content)}
                    className="mr-2 bg-yellow-500 text-white py-1 px-4 rounded-lg cursor-pointer"
                  >
                    修改
                  </button>
                  <button
                    onClick={() => handleDeleteReport(report.id)}
                    className="bg-red-500 text-white py-1 px-4 rounded-lg cursor-pointer"
                  >
                    删除
                  </button>
                </div>
              </>
            )}
          </li>
        ))}
      </ul>
    </div>
  )
}
