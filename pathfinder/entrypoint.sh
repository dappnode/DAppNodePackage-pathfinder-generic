#!/bin/bash
set -e

# Configuration
NETWORK="${PATHFINDER_NETWORK:-mainnet}"
DATA_DIR="${DATA_DIR:-/usr/share/pathfinder/data}"

# Network mapping
case "$NETWORK" in
  mainnet)
    BASE="mainnet"
    SEARCH_PATTERN="mainnet_"
    ;;
  sepolia* | testnet-sepolia)
    BASE="testnet-sepolia"
    # Handle both naming patterns: sepolia-testnet_ and testnet-sepolia_
    SEARCH_PATTERN="(sepolia-testnet_|testnet-sepolia_)"
    ;;
  *)
    echo "Unknown network: $NETWORK"
    exec pathfinder "$@"
    ;;
esac

TARGET_DB="${DATA_DIR}/${BASE}.sqlite"

# Check if database already exists
if [ -f "$TARGET_DB" ] && [ -s "$TARGET_DB" ]; then
  echo "✅ Database already exists at $TARGET_DB, skipping download"
else
  echo "📥 Downloading latest ${BASE} snapshot..."
  
  # Create rclone config using OFFICIAL Pathfinder credentials
  mkdir -p /root/.config/rclone
  cat > /root/.config/rclone/rclone.conf << EOF
[pathfinder-snapshots]
type = s3
provider = Cloudflare
env_auth = false
access_key_id = 7635ce5752c94f802d97a28186e0c96d
secret_access_key = 529f8db483aae4df4e2a781b9db0c8a3a7c75c82ff70787ba2620310791c7821
endpoint = https://cbf011119e7864a873158d83f3304e27.r2.cloudflarestorage.com
acl = private
EOF

  # List available snapshots and find the latest one for our network
  echo "🔍 Finding latest snapshot for ${BASE}..."
  
  if [ "$NETWORK" = "mainnet" ]; then
    # For mainnet, find latest mainnet_ file
    SNAPSHOT_FILE=$(rclone ls pathfinder-snapshots:pathfinder-snapshots/ | \
      grep "mainnet_.*\.sqlite\.zst" | \
      grep -v "_archive" | \
      sort -k2 | \
      tail -1 | \
      awk '{print $2}')
  else
    # For sepolia, find latest from both naming patterns
    SNAPSHOT_FILE=$(rclone ls pathfinder-snapshots:pathfinder-snapshots/ | \
      grep -E "(sepolia-testnet_|testnet-sepolia_).*\.sqlite\.zst" | \
      grep -v "_archive" | \
      sort -k2 | \
      tail -1 | \
      awk '{print $2}')
  fi
  
  if [ -z "$SNAPSHOT_FILE" ]; then
    echo "❌ No snapshot found for network: $NETWORK"
    echo "🚀 Starting Pathfinder without snapshot..."
  else
    echo "⏬ Downloading $SNAPSHOT_FILE..."
    rclone copy -P "pathfinder-snapshots:pathfinder-snapshots/$SNAPSHOT_FILE" .
    
    # Verify download
    if [ ! -f "$SNAPSHOT_FILE" ] || [ ! -s "$SNAPSHOT_FILE" ]; then
      echo "❌ Download failed. Starting Pathfinder without snapshot..."
    else
      echo "⏳ Decompressing snapshot..."
      zstd -T0 -d "$SNAPSHOT_FILE" -o "${BASE}.sqlite"
      
      # Move to target location
      mkdir -p "$DATA_DIR"
      mv "${BASE}.sqlite" "$TARGET_DB"
      rm -f "$SNAPSHOT_FILE"
      
      echo "✅ Database restored to $TARGET_DB"
    fi
  fi
fi

echo "🚀 Starting Pathfinder..."
exec pathfinder "$@"
