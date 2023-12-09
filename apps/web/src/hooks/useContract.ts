import { useNetwork } from 'wagmi'
import { goerli, localhost, mainnet } from 'wagmi/chains'

import { LUCID_BLOB_ADDRESS } from '@/config/constants'
import WAGMI_ABI from '@/config/abis/LucidBlob'

export const useWagmiContract = () => {
  const address = useWagmiContractAddress()
  return useMemo(
    () => ({
      address: address! as `0x${string}`,
      abi: WAGMI_ABI,
    }),
    [address],
  )
}

export const useWagmiContractAddress = () => {
  const { chain = mainnet } = useNetwork()
  return useMemo(
    () =>
      ({
        [mainnet.id]: LUCID_BLOB_ADDRESS,
        [goerli.id]: LUCID_BLOB_ADDRESS,
        [localhost.id]: LUCID_BLOB_ADDRESS,
      }[chain.id]),
    [chain],
  )
}
