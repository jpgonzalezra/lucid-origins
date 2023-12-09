import { NetworkSwitcher } from '@/components/SwitchNetworks'
import { WalletModal } from '@/components/WalletModal'
import { Header } from '@/components/layout/Header'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useWagmi } from '@/hooks'
import { shorten } from '@did-network/dapp-sdk'
import { useAccount } from 'wagmi'

const Home = () => {
  const { address } = useAccount()

  const blobsTokenIds: bigint[] = [
    947n,
    487n,
    540n,
    318n,
    747n,
    892n,
    234n,
    194n,
    762n,
    848n,
    884n,
    49n,
    651n,
    188n,
    449n,
    249n,
    331n,
    920n,
    656n,
    946n,
    5n,
  ].sort((a, b) => Number(a) - Number(b))
  const blobs = useWagmi(blobsTokenIds)

  const [show, setShow] = useState(false)

  const toggleModal = (e: boolean) => {
    setShow(e)
  }

  return (
    <>
      <Header
        action={
          <>
            <NetworkSwitcher />
            <WalletModal open={show} onOpenChange={toggleModal} close={() => setShow(false)}>
              {({ isLoading }) => (
                <Button className="flex items-center mr-4">
                  {isLoading && (
                    <span className="i-line-md:loading-twotone-loop inline-flex mr-1 w-4 h-4 text-white"></span>
                  )}{' '}
                  {address ? shorten(address) : 'Connect Wallet'}
                </Button>
              )}
            </WalletModal>
          </>
        }
      />
      <div className="relative max-w-6xl min-h-[calc(100vh-8rem)] m-auto pt-16 flex-col-center justify-start">
        <p
          className="font-bold bg-clip-text text-4xl lt-sm:text-2xl"
          style={
            {
              backgroundImage: 'linear-gradient(270deg, #B4EAA1 0%, #F8D07A 100%)',
              display: 'inline-block',
              lineHeight: 1,
              WebkitTextFillColor: 'transparent',
            } as any
          }
        >
          Lucid blobs
        </p>
        <p className="mt-3 text-5xl text-center font-bold lt-sm:text-3xl">The best way to create blockchain blobs</p>

        <div className="mt-8 max-w-6xl m-auto px-4 flex gap-8 flex-wrap items-stretch justify-center">
          {blobs?.map((blob, idx) => (
            <div
              key={idx}
              className="p-.5 rounded-lg hover:bg-gradient-conic hover:bg-gradient-[from_var(--conic-deg),#B4EAA1,yellow,#B4EAA1] hover:animate-[conic_2.5s_infinite_linear]"
            >
              <Card className="w-[318px] rounded-lg">
                <CardHeader>
                  <CardTitle className="flex gap-2">tokenId: {blobsTokenIds[idx].toString()}</CardTitle>
                  <CardDescription>Instant blob engine</CardDescription>
                </CardHeader>
                <CardContent className="grid gap-4">
                  <img src={`data:image/svg+xml;utf8,${encodeURIComponent(blob)}`} />
                </CardContent>
              </Card>
            </div>
          ))}
        </div>
      </div>
    </>
  )
}

export default Home
