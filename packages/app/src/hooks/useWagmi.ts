import { useContractReads } from 'wagmi'

import { useWagmiContract } from './useContract'

function extractSVGContent(inputString?: string) {
  if (!inputString) return null
  const regex = /<svg.*?svg>/
  const match = JSON.stringify(inputString).match(regex)
  return match ? match[0].replaceAll('\n', '').replaceAll('\\', '') : null
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
