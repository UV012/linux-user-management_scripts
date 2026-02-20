#!/bin/bash
#
# This script disables, deletes, and/or archives users on the local system
#

ARCHIVE_DIR='/archive'

usage() {
  echo "Usage: ${0} [-dra] USER [USERN]..." >&2
  echo 'Disable a local Linux account.' >&2
  echo '  -d   Deletes accounts instead of disabling them.' >&2
  echo '  -r   Removes the home directory associated with the account(s).' >&2
  echo '  -a   Creates an archive of the home directory associated with the account(s).' >&2
  exit 1
}

# Require superuser privileges
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run with sudo or as root' >&2
  exit 1
fi

# Parse options
while getopts dra OPTION; do
  case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='-r' ;;
    a) ARCHIVE='true' ;;
    ?) usage ;;
  esac
done

shift $(( OPTIND - 1 ))

# Require at least one username
if [[ "${#}" -lt 1 ]]; then
  usage
fi

# Process each user
for USERNAME in "${@}"; do
  echo "Processing user: ${USERNAME}"

  USER_ID=$(id -u ${USERNAME} 2>/dev/null)
  if [[ "${?}" -ne 0 ]]; then
    echo "User ${USERNAME} does not exist." >&2
    exit 1
  fi

  if [[ ${USER_ID} -lt 1000 ]]; then
    echo "Refusing to remove the ${USERNAME} account with UID ${USER_ID}" >&2
    exit 1
  fi

  # Archive if requested
  if [[ "${ARCHIVE}" = 'true' ]]; then
    if [[ ! -d "${ARCHIVE_DIR}" ]]; then
      echo "Creating ${ARCHIVE_DIR} directory."
      mkdir -p ${ARCHIVE_DIR} || { echo "Could not create ${ARCHIVE_DIR}." >&2; exit 1; }
    fi

    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]; then
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &>/dev/null || { echo "Could not create ${ARCHIVE_FILE}." >&2; exit 1; }
    else
      echo "${HOME_DIR} does not exist or is not a directory." >&2
      exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true' ]]; then
    userdel ${REMOVE_OPTION} ${USERNAME} || { echo "The account ${USERNAME} was NOT deleted." >&2; exit 1; }
    echo "The account ${USERNAME} was deleted."
  else
    chage -E 0 ${USERNAME} || { echo "The account ${USERNAME} was NOT disabled." >&2; exit 1; }
    echo "The account ${USERNAME} was disabled."
  fi
done

exit 0

