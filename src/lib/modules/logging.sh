#!/bin/bash

DEFAULT="\e[0m"
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"

#######################################
# Log info message.
# Globals:
#   VERBOSITY
# Arguments:
#   Info Message.
# Outputs:
#   Info Message
#######################################
log_info() {
  if [ "$VERBOSITY" -ge 1 ]; then
    printf "%s %s [  INFO ] %s %s", "$(date)", "$GREEN", "$1", "$DEFAULT"
  fi
}

#######################################
# Log debug message.
# Globals:
#   VERBOSITY
# Arguments:
#   Debug Message.
# Outputs:
#   Debug Message
#######################################
log_debug() {
  if [ "$VERBOSITY" -ge 2 ]; then
    printf "%s %s [ DEBUG ] %s %s", "$(date)", "$BLUE", "$1", "$DEFAULT"
  fi
}

#######################################
# Log error message.
# Globals:
#   VERBOSITY
# Arguments:
#   Error Message.
#   Exit status.
# Outputs:
#   Error message.
#######################################
log_error() {
  if [ "$VERBOSITY" -ge 0 ]; then
    printf "%s %s [ ERROR ] %s %s", "$(date)", "$RED", "$1", "$DEFAULT"
  fi
  if [ -z "$2" ]; then
    exit 1
  else
    exit "$2"
  fi
}

#######################################
# Log warning message.
# Globals:
#   VERBOSITY
# Arguments:
#   Warning message.
# Outputs:
#   Warning message.
#######################################
log_warning() {
  if [ "$VERBOSITY" -ge 1 ]; then
    printf "%s %s [WARNING] %s %s", "$(date)", "$YELLOW", "$1", "$DEFAULT"
  fi
}
