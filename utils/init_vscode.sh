#!/usr/bin/env bash
set -euo pipefail

# Copy data
mc cp -r s3/projet-betsaka/diffusion/tany_vao_2026/ /home/onyxia/work || echo "Warning: S3 copy failed. Continuing."

# Install R packages provided as arguments
if [ "$#" -gt 0 ]; then
    echo "Installing R packages: $@"
    Rscript -e 'install.packages(commandArgs(trailingOnly = TRUE), repos = "https://cloud.r-project.org")' "$@"
fi
