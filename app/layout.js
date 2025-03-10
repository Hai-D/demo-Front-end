// import './globals.css'

// import { useRouter } from 'next/navigation'
// export const metadata = {
//   title: '日报管理系统',
//   description: '个人日报提交与管理平台',
// }

// export default function RootLayout({ children }) {
//   return (
//     <html lang="zh">
//       <body className="bg-gray-100">
//         <header className="bg-blue-500 text-white p-4">
//           <nav>
//             <ul className="flex space-x-4">
//               <li><a href="/">首页</a></li>
//               {/* <li><a href="/login">登录</a></li> */}
//               {/* <li><a href="/reports">日报</a></li> */}
//             </ul>
//           </nav>
//         </header>
//         <main>{children}</main>
//       </body>
//     </html>
//   )
// }

import './globals.css'
import Link from 'next/link'

export const metadata = {
  title: '日报管理系统',
  description: '个人日报提交与管理平台',
}

export default function RootLayout({ children }) {
  return (
    <html lang="zh">
      <body className="bg-gray-100">
        <header className="bg-blue-500 text-white p-4">
          <nav>
            <ul className="flex space-x-4">
              <li>
                <Link href="/login">首页</Link>
              </li>
              {/* <li><a href="/login">登录</a></li> */}
              {/* <li><a href="/reports">日报</a></li> */}
            </ul>
          </nav>
        </header>
        <main>{children}</main>
      </body>
    </html>
  )
}
