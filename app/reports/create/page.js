// 'use client'

// import { useState } from 'react'
// import { useRouter } from 'next/navigation'

// export default function CreateReport() {
//   const [content, setContent] = useState('')
//   const [error, setError] = useState('')
//   const router = useRouter()

//   const handleSubmit = async (e) => {
//     e.preventDefault()
//     const token = localStorage.getItem('token')
//     const res = await fetch('http://localhost:8080/api/reports', {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         Authorization: `Bearer ${token}`
//       },
//       body: JSON.stringify({ content })
//     })
//     if (res.ok) {
//       router.push('/reports') // 提交成功后跳转到报告页面
//     } else {
//       setError('提交失败')
//     }
//   }

//   return (
//     <div className="max-w-md mx-auto mt-10 p-4 bg-white shadow-md rounded-lg">
//       <h2 className="text-2xl font-bold mb-4">提交日报</h2>
//       {error && <p className="text-red-500">{error}</p>}
//       <form onSubmit={handleSubmit}>
//         <textarea
//           className="w-full p-2 border rounded-lg mb-4"
//           rows="6"
//           value={content}
//           onChange={(e) => setContent(e.target.value)}
//           required
//         />
//         <button type="submit" className="w-full bg-blue-500 text-white py-2 rounded-lg">提交</button>
//       </form>
//     </div>
//   )
// }
"use client";

import { useState, useEffect } from "react";
import axios from "axios";

export default function ReportsPage() {
  const [reports, setReports] = useState([]);
  const [editingReport, setEditingReport] = useState(null);
  const [editContent, setEditContent] = useState("");

  useEffect(() => {
    fetchReports();
  }, []);

  // 获取日报数据
  const fetchReports = async () => {
    try {
      const response = await axios.get("http://localhost:8080/reports");
      setReports(response.data);
    } catch (error) {
      console.error("获取日报失败", error);
    }
  };

  // 删除日报
  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:8080/reports/${id}`);
      setReports(reports.filter((report) => report.id !== id)); // 前端同步更新
    } catch (error) {
      console.error("删除失败", error);
    }
  };

  // 进入编辑模式
  const handleEdit = (report) => {
    setEditingReport(report.id);
    setEditContent(report.content);
  };

  // 提交更新
  const handleUpdate = async (id) => {
    try {
      await axios.put(`http://localhost:8080/reports/${id}`, {
        content: editContent,
      });
      setEditingReport(null);
      fetchReports(); // 重新获取数据
    } catch (error) {
      console.error("更新失败", error);
    }
  };

  return (
    <div className="max-w-2xl mx-auto p-6 bg-white shadow-lg rounded-lg">
      <h1 className="text-2xl font-bold mb-4">日报列表</h1>
      {reports.length === 0 ? (
        <p>暂无日报</p>
      ) : (
        reports.map((report) => (
          <div
            key={report.id}
            className="border p-4 rounded-lg mb-2 flex justify-between items-center"
          >
            {editingReport === report.id ? (
              <input
                type="text"
                value={editContent}
                onChange={(e) => setEditContent(e.target.value)}
                className="border p-2 w-full"
              />
            ) : (
              <p>{report.content}</p>
            )}

            <div className="flex gap-2">
              {editingReport === report.id ? (
                <button
                  onClick={() => handleUpdate(report.id)}
                  className="bg-green-500 text-white px-3 py-1 rounded"
                >
                  保存
                </button>
              ) : (
                <button
                  onClick={() => handleEdit(report)}
                  className="bg-blue-500 text-white px-3 py-1 rounded"
                >
                  修改
                </button>
              )}

              <button
                onClick={() => handleDelete(report.id)}
                className="bg-red-500 text-white px-3 py-1 rounded"
              >
                删除
              </button>
            </div>
          </div>
        ))
      )}
    </div>
  );
}
