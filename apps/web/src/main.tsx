import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { configureChains, createConfig, WagmiConfig } from 'wagmi'
import { localhost } from 'wagmi/chains'
import { MetaMaskConnector } from 'wagmi/connectors/metaMask'
import { WalletConnectConnector } from 'wagmi/connectors/walletConnect'
import { WalletConnectLegacyConnector } from 'wagmi/connectors/walletConnectLegacy'
import { jsonRpcProvider } from 'wagmi/providers/jsonRpc'
import { publicProvider } from 'wagmi/providers/public'

import App from './App'

import '@unocss/reset/tailwind.css'
import 'uno.css'
import { WALLET_CONNECT_PROJECT_ID } from './config/constants'
import './index.css'

console.table(import.meta.env)

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [localhost],
  [
    // publicProvider(),
    jsonRpcProvider({
      rpc: (chain) => {
        if (chain.id !== 97 && chain.id !== 56) return null
        return { http: chain.rpcUrls.default.http[0] }
      },
    }),
    publicProvider(),
  ],
)

const config = createConfig({
  autoConnect: true,
  connectors: [
    new MetaMaskConnector({ chains }),
    new WalletConnectConnector({
      options: {
        projectId: WALLET_CONNECT_PROJECT_ID,
      },
    }),
    new WalletConnectLegacyConnector({
      chains,
      options: {
        qrcode: true,
      },
    }),
  ],
  publicClient,
  webSocketPublicClient,
})

const root = createRoot(document.getElementById('root')!)
root.render(
  <WagmiConfig config={config}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </WagmiConfig>,
)
