#!/usr/bin/env bash

set -xeuo pipefail

if command -v podman
then
    CONTAINER_CMD="podman"
else
    CONTAINER_CMD="docker"
fi
export CONTAINER_CMD
echo "Using ${CONTAINER_CMD} as container engine..."

export CONTAINER_BUILD_EXTRA_PARAMS=${CONTAINER_BUILD_EXTRA_PARAMS:-"--no-cache"}
export JIRA_UNFURL_BOT_IMAGE=${JIRA_UNFURL_BOT_IMAGE:-"quay.io/app-sre/jira-unfurl-bot"}

# Tag with the current commit sha
JIRA_UNFURL_BOT_TAG="$(git rev-parse HEAD)"
export JIRA_UNFURL_BOT_TAG

# Setup credentials to image registry
${CONTAINER_CMD} login -u="${QUAY_USER}" -p="${QUAY_TOKEN}" quay.io

# Build and push latest image
make build-image

JIRA_UNFURL_BOT_IMAGE_COMMIT_SHA="${JIRA_UNFURL_BOT_IMAGE}:${JIRA_UNFURL_BOT_TAG}"
${CONTAINER_CMD} push "${JIRA_UNFURL_BOT_IMAGE_COMMIT_SHA}"

# Tag with the current commit short sha
JIRA_UNFURL_BOT_SHORT_TAG="$(git rev-parse --short=7 HEAD)"
JIRA_UNFURL_BOT_IMAGE_COMMIT_SHORT_SHA="${JIRA_UNFURL_BOT_IMAGE}:${JIRA_UNFURL_BOT_SHORT_TAG}"
${CONTAINER_CMD} tag "${JIRA_UNFURL_BOT_IMAGE_COMMIT_SHA}" "${JIRA_UNFURL_BOT_IMAGE_COMMIT_SHORT_SHA}"
${CONTAINER_CMD} push "${JIRA_UNFURL_BOT_IMAGE_COMMIT_SHORT_SHA}"

# Tag the image as latest
JIRA_UNFURL_BOT_IMAGE_LATEST="${JIRA_UNFURL_BOT_IMAGE}:latest"
${CONTAINER_CMD} tag "${JIRA_UNFURL_BOT_IMAGE_COMMIT_SHA}" "${JIRA_UNFURL_BOT_IMAGE_LATEST}"
${CONTAINER_CMD} push "${JIRA_UNFURL_BOT_IMAGE_LATEST}"
