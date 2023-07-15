#!/bin/bash

MELTANO_PROJECT_DIRECTORY="${MELTANO_PROJECT_DIRECTORY:-/meltano/project}"

CYN0='\033[0;36m' # Cyon
CYN1='\033[1;36m' # Cyon Bold
GRN0='\033[0;32m' # Green
YLW1='\033[1;33m' # Yellow Bold
WHT1='\033[1m'    # White Bold
NOCL='\033[0m'    # No Color

if [ $# -eq 0 ]; then
    docker exec -i meltano meltano dragon
    echo -e "${YLW1}Usage: mel.sh [meltano|container|shell|...] <args>${NOCL}"
    echo -e ""
    echo -e "${WHT1}Options:${NOCL}"
    echo -e "  ${CYN1}meltano   :${NOCL} Run Meltano commands inside the meltano container"
    echo -e "  ${CYN1}container :${NOCL} Run docker-compose commands"
    echo -e "      ${WHT1}build :${NOCL} Build the Docker images specified in docker-compose.yml file"
    echo -e "      ${WHT1}up    :${NOCL} Start the Docker containers defined in docker-compose.yml file"
    echo -e "      ${WHT1}down  :${NOCL} Stop the Docker containers defined in docker-compose.yml file"
    echo -e "  ${CYN1}shell     :${NOCL} Run commands inside the meltano container's shell"
    echo -e ""
    exit 1
fi


replace_project_prefix() {
  local param="$1"
  if [[ $param == project/* ]]; then
    echo "${MELTANO_PROJECT_DIRECTORY}/${param#project/}"
  else
    echo "$param"
  fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
EXEC_MSG="${CYN1}Executing command:${GRN0}"

cmd="$1"
shift
args=()
for arg in "$@"; do
  args+=("$(replace_project_prefix "$arg")")
done

case "$cmd" in
  "container")
    subcmd="$1"
    shift
    case "$subcmd" in
        "build")
            echo -e "${EXEC_MSG} docker-compose -f "${DOCKER_COMPOSE_FILE}" ${args[@]:1}${NOCL}\n"
            docker-compose -f "${DOCKER_COMPOSE_FILE}" build --no-cache "${args[@]:1}"
            ;;
        "up")
            echo -e "${EXEC_MSG} docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d ${args[@]:1}${NOCL}\n"
            docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d "${args[@]:1}"
            ;;
        "down")
            echo -e "${EXEC_MSG} docker-compose -f "${DOCKER_COMPOSE_FILE}" down ${args[@]:1}${NOCL}\n"
            docker-compose -f "${DOCKER_COMPOSE_FILE}" down "${args[@]:1}"
            ;;
    esac
    ;;
  "shell")
    echo -e "${EXEC_MSG} docker exec $cmd ${args[*]}${NOCL}\n"
    docker exec -i meltano "${args[@]}"
    ;;
  "meltano")
    echo -e "${EXEC_MSG} docker exec meltano $cmd ${args[*]}${NOCL}\n"
    docker exec -i meltano meltano "${args[@]}"
    ;;
  *)
    echo -e "${EXEC_MSG} docker exec meltano meltano $cmd ${args[*]}${NOCL}\n"
    docker exec -i meltano meltano "$cmd" "${args[@]}"
    ;;
esac