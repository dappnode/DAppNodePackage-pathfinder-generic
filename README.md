# Pathfinder DAppNode Package

[![DAppNode Available](https://img.shields.io/badge/DAppNode-Available-brightgreen.svg)](http://my.dappnode.io/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://github.com/dappnode/DAppNodePackage-pathfinder-generic/blob/main/LICENSE)
[![StarkNet](https://img.shields.io/badge/StarkNet-Node-orange.svg)](https://starknet.io/)

A DAppNode package for running [Pathfinder](https://github.com/eqlabs/pathfinder), a StarkNet full node client, allowing you to participate in the StarkNet network directly from your DAppNode.

## 🌟 Features

- **Full StarkNet Node**: Run a complete StarkNet full node with Pathfinder
- **Multiple Networks**: Support for both Mainnet and Sepolia testnet
- **JSON-RPC API**: Access StarkNet through standard JSON-RPC endpoints
- **WebSocket Support**: Real-time data access via WebSocket connections
- **Easy Configuration**: Simple setup wizard for network configuration
- **Grafana Dashboard**: Built-in monitoring dashboard for node metrics
- **Multi-Architecture**: Supports both AMD64 and ARM64 architectures

## 📋 Prerequisites

- **DAppNode**: This package requires a running DAppNode
- **Ethereum Node**: An Ethereum L1 node is required for L1 state verification
  - Can use a DAppNode execution client (recommended)
  - Or external providers like Infura, Alchemy, etc.

## 🚀 Installation

### Via DAppNode Store

1. Open your DAppNode admin panel
2. Go to the DAppStore
3. Search for "Pathfinder"
4. Click "Install" and follow the setup wizard

## ⚙️ Configuration

During installation, you'll need to configure:

### Required Settings

- **Ethereum API URL**: URL of your Ethereum L1 node for state verification
  - DAppNode execution client: `ws://execution.{network}.dncore.dappnode:8555`
  - Infura WebSocket: `wss://mainnet.infura.io/ws/v3/YOUR-PROJECT-ID`
  - Other providers: Any valid HTTP/WebSocket URL

### Optional Settings

- **Log Level**: Choose verbosity level (error, warn, info, debug, trace)
  - Default: `info` (recommended for most users)

## 🌐 Network Variants

This package supports multiple StarkNet networks:

| Network   | Package                            | RPC Port | Monitor Port | RPC Endpoint                               | WebSocket Endpoint                                 |
|-----------|-------------------------------------|----------|--------------|---------------------------------------------|-----------------------------------------------------|
| **Mainnet** | `pathfinder.dnp.dappnode.eth`        | 6060     | 9547         | <http://pathfinder.dappnode:6060/>            | ws://pathfinder.dappnode:6061/ws                    |
| **Sepolia** | `pathfinder-sepolia.dappnode.eth`    | 9555     | 9557         | <http://pathfinder-sepolia.dappnode:9555/>    | ws://pathfinder-sepolia.dappnode:9556/ws            |

> **Note**: The Monitor port is used for metrics and health check endpoints for monitoring and observability.

## 🔌 API Usage

### JSON-RPC Interface

The Pathfinder node exposes a StarkNet JSON-RPC API compatible with the official specification:

```bash
# Mainnet - Get the latest block
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"starknet_blockNumber","params":[],"id":1}' \
  http://pathfinder.dappnode:6060/

# Sepolia - Get chain ID
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"starknet_chainId","params":[],"id":1}' \
  http://pathfinder-sepolia.dappnode:9555/
```

## 📊 Monitoring

The package includes a Grafana dashboard for monitoring:

- Node synchronization status
- Block height and sync progress
- RPC call metrics
- Resource usage (CPU, memory, disk)
- Network connectivity

## 🐳 Technical Details

### Docker Configuration

- **Base Image**: `eqlabs/pathfinder`
- **Exposed Ports**:
  - **Mainnet**: `6060` (JSON-RPC), `9547` (Monitor)
  - **Sepolia**: `9555` (JSON-RPC), `9557` (Monitor)
- **Data Persistence**: Node data stored in persistent Docker volume
- **Environment Variables**:
  - `PATHFINDER_ETHEREUM_API_URL`: L1 Ethereum node URL
  - `PATHFINDER_NETWORK`: StarkNet network (mainnet/sepolia-testnet)
  - `RUST_LOG`: Logging level
  - `PATHFINDER_DB_DIR`: Database directory

### Storage Requirements

- **Initial Sync**: ~50GB+ (varies by network and state size)
- **Ongoing Growth**: Several GB per month
- **Recommended**: SSD storage for optimal performance

## 🔧 Troubleshooting

### Common Issues

1. **Sync Problems**
   - Ensure Ethereum API URL is correct and accessible
   - Check that the L1 node is fully synced
   - Verify network connectivity

2. **Performance Issues**
   - Ensure sufficient RAM (8GB+ recommended)
   - Use SSD storage for better I/O performance
   - Monitor CPU usage during initial sync

3. **API Connection Issues**
   - Verify the node is running and healthy
   - Check port accessibility from client applications
   - Ensure firewall rules allow connections

### Logs Access

View logs through the DAppNode interface:

1. Go to Packages → Pathfinder
2. Click on "Logs" tab
3. Adjust log level in configuration if needed

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues and pull requests.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/dappnode/DAppNodePackage-pathfinder-generic.git
cd DAppNodePackage-pathfinder-generic

# Build the package
npx @dappnode/dappnodesdk build

# Build specific variant
npx @dappnode/dappnodesdk build --variant sepolia
```

## 📚 Resources

- **Pathfinder Documentation**: [GitHub Repository](https://github.com/eqlabs/pathfinder)
- **StarkNet Documentation**: [Official Docs](https://docs.starknet.io/)
- **DAppNode Documentation**: [DAppNode Docs](https://docs.dappnode.io/)
- **StarkNet JSON-RPC Spec**: [API Specification](https://github.com/starkware-libs/starknet-specs)

## 📄 License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Equilibrium Labs](https://github.com/eqlabs) for developing Pathfinder
- [StarkWare](https://starkware.co/) for the StarkNet protocol
- [DAppNode](https://dappnode.io/) community for package maintenance

---

**Made with ❤️ by the DAppNode community**

For support, join our [Discord](https://discord.gg/dappnode) or visit our [forum](https://discourse.dappnode.io/).
