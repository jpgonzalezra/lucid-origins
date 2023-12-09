import { useContractReads } from 'wagmi'

import { useWagmiContract } from './useContract'

function extractSVGContent(inputString?: string) {
  if (!inputString) return null
  const decodedInput = JSON.parse(atob(inputString.replace(/^data:\w+\/\w+;base64,/, '')))
  return decodedInput?.image
}

export const useWagmi = (tokenIds: bigint[]): string[] => {
  const wagmiContract = useWagmiContract()

  const { data } = useContractReads({
    contracts: tokenIds.map((tokenId) => ({
      ...wagmiContract,
      functionName: 'tokenURI',
      args: [tokenId],
    })),
  })

  return data
    ?.map((_, idx) => (data?.[idx] ? extractSVGContent(data?.[idx]?.result as string) : null))
    .filter(Boolean) as string[]
}
