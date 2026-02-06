#!/usr/bin/env bash

# Usage: source env.sh

# ============================================================================ #
# Set up environment variables for the project
# ============================================================================ #
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SIM_BUILD_DIR="$ROOT_DIR/build/sim"
PATH="$ROOT_DIR/tools:$PATH"

# ============================================================================ #
# Export environment variables
# ============================================================================ #
export ROOT_DIR
export SIM_BUILD_DIR
export PATH
