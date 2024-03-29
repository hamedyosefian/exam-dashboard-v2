import { ConfigProvider as AntdConfigProvider, Spin, App as AntdApp } from 'antd'
import faIR from 'antd/locale/fa_IR'
import './globals.css'
import './ckeditor.css'
import { SWRProvider } from '@/provider/SwrProvider'
import Header from '@/Header'
import { AuthProvider } from '@/provider/AuthProvider'
import StyledJsxProvider from '@/provider/StyledJsxProvider'
import { AntdRegistry } from '@ant-design/nextjs-registry'

export const metadata = {
  title: 'Create Next App',
  description: 'Generated by create next app',
}

export default function RootLayout({ children }) {
  return (
    <html lang='fa' dir='rtl'>
      <body id='app'>
        <AntdRegistry>
          <AntdConfigProvider
            direction='rtl'
            locale={faIR}
            theme={{
              token: {
                fontFamily: 'IRANYekanX',
                // controlHeight: 40,
                // controlPaddingHorizontal: 20,
                colorPrimary: '#3f0ecc',
              },
              components: {
                Breadcrumb: {
                  itemColor: 'rgba(255,255,255,0.5)',
                  linkColor: 'rgba(255,255,255,0.5)',
                  lastItemColor: 'rgba(255,255,255,1)',
                  linkHoverColor: 'rgba(255,255,255,1)',
                  separatorColor: 'rgba(255,255,255,0.5)',
                },
              },
            }}
          >
            <StyledJsxProvider>
              <SWRProvider>
                <AntdApp>
                  <AuthProvider>
                    <Header />
                    <main>{children}</main>
                  </AuthProvider>
                </AntdApp>
              </SWRProvider>
            </StyledJsxProvider>
          </AntdConfigProvider>
        </AntdRegistry>
      </body>
    </html>
  )
}
