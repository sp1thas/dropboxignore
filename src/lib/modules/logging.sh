#!/bin/bash

# Initialize colors using tput with safe fallbacks
if command -v tput >/dev/null 2>&1; then
  ncolors=$(tput colors 2>/dev/null || echo 0)
else
  ncolors=0
fi
if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  DEFAULT="$(tput sgr0)"
  GREEN="$(tput setaf 2)"
  BLUE="$(tput setaf 4)"
  RED="$(tput setaf 1)"
  YELLOW="$(tput setaf 3)"
else
  DEFAULT=""
  GREEN=""
  BLUE=""
  RED=""
  YELLOW=""
fi

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
    echo "$(date) ${GREEN}[  INFO ]${DEFAULT} $1"
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
    echo "$(date) ${BLUE}[ DEBUG ]${DEFAULT} $1"
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
    echo "$(date) ${RED}[ ERROR ]${DEFAULT} $1"
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
    echo "$(date) ${YELLOW}[WARNING]${DEFAULT} $1"
  fi
}
