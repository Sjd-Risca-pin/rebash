#!/usr/bin/env bash
# shellcheck source=./core.sh
source "$(dirname "${BASH_SOURCE[0]}")/core.sh"

core.import ui
core.import array
core.import arguments
logging__doc__='
'


declare -a trap_on_exit_items=()

trap_run_all() {
    for cmd in "${trap_on_exit_items[@]}"; do
        eval ${cmd}
    done
}

trap_set() {
    trap trap_run_all INT ERR EXIT
}

trap_add() {
    trap_on_exit_items=("$*" "${trap_on_exit_items[@]}")
}

trap_pop() {
    local first="${trap_on_exit_items}"
    eval ${first}
    trap_on_exit_items=($(array.slice 1: "${trap_on_exit_items[@]}"))
}

trap_skip_till() {
    local marker=$1
    local cmd
    for cmd in "${trap_on_exit_items[@]}"; do
        trap_on_exit_items=("${trap_on_exit_items[@]:1}")
        [[ ${cmd} == *"${marker}"* ]] && break
    done
}

trap_run_till() {
    local marker=$1
    local cmd
    for cmd in "${trap_on_exit_items[@]}"; do
        trap_on_exit_items=("${trap_on_exit_items[@]:1}")
        eval ${cmd}
        [[ ${cmd} == *"${marker}"* ]] && break
    done
}


alias trap.run_all="trap_run_all"
alias trap.set="trap_set"
alias trap.add="trap_add"
alias trap.pop="trap_popd"
alias trap.skip_till="trap_skip_till"
alias trap.run_till="trap_run_till"
