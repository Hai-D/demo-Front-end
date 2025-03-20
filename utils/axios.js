// import axios from 'axios'

// const api = axios.create({
//   baseURL: 'http://localhost:8080',  // 后端服务的基础 URL
//   headers: {
//     'Content-Type': 'application/json',
//   },
// })

// export default api
import axios from 'axios'

// const api = axios.create({
//   baseURL: 'http://localhost:8080',  // 后端服务的基础 URL
//   headers: {
//     'Content-Type': 'application/json',
//   },
// })
// // utils/axios.js

// import axios from 'axios'

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,  // 使用环境变量中的基础 URL
  headers: {
    'Content-Type': 'application/json',
  },
})



// // 获取当前登录用户
// export const getCurrentUser = async () => {
//   try {
//     const response = await api.get('/auth/me');
//     return response.data.username;  // 返回用户名
//   } catch (error) {
//     return null;  // 未登录返回 null
//   }
// };

// // 获取用户的所有日报
// export const getReports = async (username) => {
//   try {
//     const response = await api.get(`/reports/${username}`);
//     return response.data;  // 返回日报数据
//   } catch (error) {
//     throw new Error("获取日报失败");
//   }
// };

// // 提交日报
// export const submitReport = async (username, content) => {
//   try {
//     await api.post(`/reports/${username}`, { content });
//   } catch (error) {
//     throw new Error("提交日报失败");
//   }
// };

// // 删除日报
// export const deleteReport = async (username, reportId) => {
//   try {
//     await api.delete(`/reports/${username}/${reportId}`);
//   } catch (error) {
//     throw new Error("删除日报失败");
//   }
// };

// // 修改日报
// export const updateReport = async (username, reportId, newContent) => {
//   try {
//     await api.put(`/reports/${username}/${reportId}`, { content: newContent });
//   } catch (error) {
//     throw new Error("更新日报失败");
//   }
// };

export default api;
