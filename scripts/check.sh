#!/usr/bin/env bash

set -euo pipefail

defs=$(mktemp)

echo "Linting CI Pipeline"
yq r -j .bluemix/ci-tekton.yaml | jq -r '.inputs[] | select(.service=="${TEKTON_CATALOG_REPO}") | "'$COMMON_TEKTON_TASKS_DIR'/" + .path + "/*.yaml"' | tee "$defs"
yq r -j .bluemix/ci-tekton.yaml | jq -r '.inputs[] | select(.service=="${PIPELINE_REPO}") | .path + "/*.yaml"' | tee -a "$defs"

tekton-lint $(cat "$defs")

echo "Linting PR Pipeline"
yq r -j .bluemix/pr-tekton.yaml | jq -r '.inputs[] | select(.service=="${TEKTON_CATALOG_REPO}") | "'$COMMON_TEKTON_TASKS_DIR'/" + .path + "/*.yaml"' | tee "$defs"
yq r -j .bluemix/pr-tekton.yaml | jq -r '.inputs[] | select(.service=="${PIPELINE_REPO}") | .path + "/*.yaml"' | tee -a "$defs"

tekton-lint $(cat "$defs")
