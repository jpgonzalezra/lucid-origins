# Lucid blob

Generative NFT Lucid Blob on Ethereum Blockchain

## Overview

WLucid blob project, a artistic endeavor on the Ethereum blockchain. The project represents the ultimate expression of on-chain purity, where every aspect of the artwork, including images, contract code, unique identifiers, metadata, and the rendering functionality, resides entirely on the Ethereum blockchain. Crucially, the art itself is not stored in any storage; it is dynamically generated on each request. The generation process uses a hash on the token id, referred to as the DNA, ensuring that each piece is not just stored but also created directly on the blockchain. This method ensures that the artwork can be created and viewed at any time in the future, relying solely on the Ethereum blockchain, with no external dependencies.

## Concept

Lucid blob are a collection of generative NFT, each with its own distinct and unique identity. No two Lucid blob are the same, making each Lucid blob a one-of-a-kind masterpiece. The shape of each Lucid Blob is algorithmically generated afresh for every image, based on its unique DNA derived from its token ID.

## Features

- On-Chain Artwork: Every aspect of the Lucid Blob, from the artwork to the metadata, resides on the Ethereum blockchain. This ensures the longevity and authenticity of each piece, independent of external platforms or services.

- Unique: Each Lucid Blob is procedurally generated, ensuring no two are alike. The body shapes are algorithmically created at the time of minting, offering a unique identity to each Lucid Blob.

- DNA: NFT are calculated on-the-fly when the tokenURI method is executed, using the tokenId. The DNA of each Lucid Blob is extracted using the function `getDna(uint256(keccak256(abi.encodePacked(tokenId))))` This ensures that each Lucid Blob NFT is dynamically generated and retrieved in real-time. Importantly, while the NFT generation is dynamic, it consistently produces the same result for the same DNA, ensuring the uniqueness and permanence of each Lucid Blob identity.
