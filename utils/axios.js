
import axios from 'axios'

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,  // 后端服务的基础 URL
  headers: {
    'Content-Type': 'application/json',
  },
})

export default api;
