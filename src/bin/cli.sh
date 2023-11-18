#!/bin/bash
# dropboxignore
# =============
# Ignore files and folders from dropbox using the .dropbox ignore files

SCRIPT_PATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"

if [ "$SCRIPT_PATH" == "/usr/local/bin" ]; then
  LIB_PATH="/usr/local/lib/dropboxignore"
elif [ "$SCRIPT_PATH" == "/code" ]; then
  LIB_PATH="/code/src/lib"
else
  LIB_PATH="$SCRIPT_PATH/../lib"
fi
# shellcheck disable=SC1091
source "$LIB_PATH/modules/loader.sh" "$LIB_PATH"

#######################################
# The main function.
# Arguments:
#   Command
#   Path
#   Extra parameters
# Globals:
#   PROGRAM_NAME
#   VERBOSITY
#   FILTERING_PATTERN
#   MACHINE
# Output:
#   Almost everything.
#######################################
main() {
  if [ $# -eq 0 ]; then
    cmd_help
    return
  fi
  case $1 in
  genupi)
    genupi_action=true
    shift
    ;;
  generate)
    generate_action=true
    shift
    ;;
  update)
    update_action=true
    shift
    ;;
  ignore)
    ignore_action=true
    shift
    ;;
  revert)
    revert_action=true
    shift
    ;;
  delete)
    delete_action=true
    shift
    ;;
  help)
    cmd_help
    exit 0
    ;;
  version)
    cmd_version
    exit 0
    ;;
  list)
    list_action=true
    shift
    ;;
  *)
    log_error "$PROGRAM_NAME: '$1' is not a $PROGRAM_NAME command.\nSee '$PROGRAM_NAME help'" 1
    ;;
  esac

  input_f="$1"

  shift

  while getopts ':pv:' opt; do
    case "$opt" in
    v)
      # shellcheck disable=SC2034
      VERBOSITY=$OPTARG
      ;;
    p)
      FILTERING_PATTERN=$OPTARG
      ;;
    \?)
      log_error "Unknown option: -$OPTARG" 3
      ;;
    esac
  done

  log_debug "Operating system: $MACHINE"
  check_dependencies

  # check input file or folder
  check_input "$input_f"
  input_f=$(get_absolute_path "$input_f")

  # run action
  if [ "$genupi_action" == true ]; then
    cmd_generate "$input_f"
    cmd_update "$input_f"
    cmd_ignore "$input_f"
  elif [ "$generate_action" == true ]; then
    cmd_generate "$input_f"
  elif [ "$update_action" == true ]; then
    cmd_update "$input_f"
  elif [ "$ignore_action" == true ]; then
    cmd_ignore "$input_f"
  elif [ "$delete_action" == true ]; then
    cmd_delete "$input_f"
  elif [ "$revert_action" == true ]; then
    cmd_revert "$input_f"
  elif [ "$list_action" == true ]; then
    cmd_list "$input_f" "$FILTERING_PATTERN"
  fi
}

main "$@"
