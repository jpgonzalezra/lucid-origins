function getRandomInt(min = 0, max = 100000): number {
  min = Math.ceil(min)
  max = Math.floor(max)

  return Math.floor(Math.random() * (max - min + 1)) + min
}

function getRandomBigInt(min = 0, max = 100000): bigint {
  return BigInt(getRandomInt(min, max))
}

function getRandomBigInts(count = 1, min = 0, max = 100000): bigint[] {
  return Array.from({ length: count }, () => getRandomBigInt(min, max))
}

export { getRandomInt, getRandomBigInt, getRandomBigInts }
