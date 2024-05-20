# Jira Unfurl Bot

Currently running https://console-openshift-console.apps.rosa.appsres07ue1.a9ro.p3.openshiftapps.com

# Jira Unfurl Bot Architecture

This document describes the architecture of the Jira Unfurl Bot, a Slack bot
that unfurls Jira issues shared in Slack channels, providing a
summary of the linked resource directly within Slack.

## Overview

The Jira Unfurl Bot is a Python application that integrates Slack with Jira. It
listens for specific events in Slack, such as app mentions and link sharing,
and responds by fetching relevant information from Jira and displaying it in
the Slack channel.

## Key Elements

1. **Socket Mode**: The bot uses the Socket Mode feature of Slack Bolt, which
  enables real-time communication between the bot and Slack over a secure
  WebSocket connection. This eliminates the need for setting up a public HTTP
  endpoint.

2. **Event Handling**: The bot listens for two main events from Slack:
  - *App Mention*: When the bot is mentioned in a Slack channel, it responds with
  a simple "I'm alive" message to indicate that it is running and responsive.
  - *Link Shared*: When a Jira issue or version link is shared in a Slack
  channel, the bot intercepts the event, extracts the issue key or version ID
  from the link, and fetches the corresponding details from Jira.

3. **Jira Integration**: The bot interacts with Jira using the Jira Python
  library. It authenticates using an access token provided as an environment
  variable (`JIRA_ACCESS_TOKEN`).
  - For Jira issue links, the bot fetches the issue details and constructs a
  formatted message with the issue key, status, summary, and issue type.

## Configuration

The bot relies on the following environment variables for configuration:
- `SLACK_BOT_TOKEN`: The bot token for the Slack app.
- `SLACK_APP_TOKEN`: The app token for the Slack app, used for Socket Mode.
- `JIRA_ACCESS_TOKEN`: The access token for authenticating with the Jira API.

## Error Handling

If the required `JIRA_ACCESS_TOKEN` environment variable is not provided, the
bot raises a `ValueError` and terminates.
