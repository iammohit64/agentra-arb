import { arbitrum, arbitrumSepolia } from 'wagmi/chains'
import deployments from '../deployments.json'

// Wagmi supports Arbitrum Mainnet and Arbitrum Sepolia Testnet
export const SUPPORTED_CHAINS = [arbitrumSepolia, arbitrum]

// Dynamic lookup map for all supported chains.
export const CHAIN_CONFIG = SUPPORTED_CHAINS.reduce((acc, chain) => {
  acc[chain.id] = {
    chain,
    contracts: deployments[chain.id] || {},
  }

  return acc
}, {})