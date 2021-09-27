#!/bin/bash
#
# Usage:
#   gtc_setup_cloud9_environment.sh
#   
# Arguments & Options:
#   -h                 : Help option displays usage
#   
# Examples:
#   $ /efs/em/gtc_sh_ver00/gtc_setup_cloud9_environment.sh
# 
# Debug Script:
#   gtc_setup_cloud9_environment_debug.sh
# 
# Developer Notes:
#   [2021/0725 Toshio Moriya]
#   Considered following specification but rejected.
#   Usage:
#     gtc_setup_env_vars_on_cloud9.sh  -s GTC_SH_DIR  -d GTC_DEBUG_MODE
#   
#   Arguments & Options:
#     -s GTC_SH_DIR      : GoToCloud shell script direcctory path. e.g. "/efs/em/gtc_sh_ver00/". (default "/efs/em/gtc_sh")
#     -d GTC_DEBUG_MODE  : GoToCloud debug mode. 0 (off) or 1 (on)  (default 0 (off))
#     
#     -h                 : Help option displays usage

if [ ! -z $GTC_SYSTEM_DEBUG_MODE ]; then 
    if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] GTC_SYSTEM_DEBUG_MODE is set to ${GTC_SYSTEM_DEBUG_MODE} already!"; fi
else 
    # GTC_SYSTEM_DEBUG_MODE is not set yet!
    export GTC_SYSTEM_DEBUG_MODE=0
fi

if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] --------------------------------------------------"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] Hello gtc_setup_cloud9_environment.sh"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] --------------------------------------------------"; fi

usage_exit() {
        echo "GoToCloud: Usage $0" 1>&2
        echo "GoToCloud: Exiting(1)..."
        exit 1
}

# Check if the number of command line arguments is valid
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] @=$@"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] #=$#"; fi
if [[ $# -gt 1 ]]; then
    echo "GoToCloud: Invalid number of arguments ($#)"
    usage_exit
fi

# Parse command line arguments
while getopts h OPT
do
    if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] OPT=$OPT"; fi
    case "$OPT" in
        h)  usage_exit
            ;;
        \?) echo "GoToCloud: [GTC_ERROR] Invalid option $OPTARG is specified!"
            usage_exit
            ;;
    esac
done

# GoToCloud shell script direcctory path
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] 0 = $0"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] dirname $0 = $(dirname $0)"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] pwd = $(pwd)"; fi
GTC_SH_DIR=`cd $(dirname ${0}) && pwd`
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] GTC_SH_DIR=${GTC_SH_DIR}"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] pwd = $(pwd)"; fi

# Setup Cloud9 environment for GoToCloud (mainly systemwise environment global variables)
echo "GoToCloud: Calling gtc_utility_setup_global_variables..."
# First import gtc_utility_global_varaibles shell utility functions
source ${GTC_SH_DIR}/gtc_utility_global_varaibles.sh
# . ${GTC_SH_DIR}/gtc_utility_global_varaibles.sh
# Then call gtc_utility_setup_global_variables function
gtc_utility_setup_global_variables

if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then 
# 
    echo "GoToCloud: [GTC_DEBUG] "
    echo "GoToCloud: [GTC_DEBUG] At this point, get functions in gtc_utility_global_varaibles.sh should be usable within file scope of this script file"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_sh_dir = $(gtc_utility_get_sh_dir)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_iam_user_name = $(gtc_utility_get_iam_user_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_method_name = $(gtc_utility_get_method_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_project_name = $(gtc_utility_get_project_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_pcluster_name = $(gtc_utility_get_pcluster_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_s3_name = $(gtc_utility_get_s3_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_key_name = $(gtc_utility_get_key_name)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_key_dir = $(gtc_utility_get_key_dir)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_key_file = $(gtc_utility_get_key_file)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_application_dir = $(gtc_utility_get_application_dir)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_global_varaibles_file = $(gtc_utility_get_global_varaibles_file)"
    echo "GoToCloud: [GTC_DEBUG] gtc_utility_get_debug_mode = $(gtc_utility_get_debug_mode)"
    echo "GoToCloud: [GTC_DEBUG] "
fi

GTC_BASHRC=${HOME}/.bashrc
if [ -e ${GTC_BASHRC} ]; then
    GTC_APPLICATION_DIR=$(gtc_utility_get_application_dir)
    if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] GTC_APPLICATION_DIR=${GTC_APPLICATION_DIR}"; fi
    GTC_BASHRC_BACKUP=${GTC_APPLICATION_DIR}/.bashrc_backup_`date "+%Y%m%d_%H%M%S"`
    echo "GoToCloud: Making a backup of previous ${GTC_BASHRC} as ${GTC_BASHRC_BACKUP}..."
    cp ${GTC_BASHRC} ${GTC_BASHRC_BACKUP}
else
    echo "GoToCloud: [GTC_WARNING] ${GTC_BASHRC} does not exist on this system. Normally, this should not happen!"
fi

echo "GoToCloud: Appending GoToCloud system environment variable settings to ${GTC_BASHRC}..."
GTC_GLOBAL_VARIABLES_FILE=$(gtc_utility_get_global_varaibles_file)
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] GTC_GLOBAL_VARIABLES_FILE=${GTC_GLOBAL_VARIABLES_FILE}"; fi
# cat > ${GTC_BASHRC} <<'EOS' suppresses varaible replacements 
# cat > ${GTC_BASHRC} <<EOS allows varaible replacements 
cat >> ${GTC_BASHRC} <<EOS

#  GoToCloud system environment variables
source ${GTC_GLOBAL_VARIABLES_FILE}
EOS

echo "GoToCloud: "
echo "GoToCloud: To applying GoToCloud system environment variables, open a new terminal. "
echo "GoToCloud: OR use the following command in this session:"
echo "GoToCloud: "
echo "GoToCloud:   source ${GTC_GLOBAL_VARIABLES_FILE}"
echo "GoToCloud: "
echo "GoToCloud: Done"

if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] "; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] --------------------------------------------------"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] Good-bye gtc_setup_cloud9_environment.sh!"; fi
if [[ ${GTC_SYSTEM_DEBUG_MODE} != 0 ]]; then echo "GoToCloud: [GTC_DEBUG] --------------------------------------------------"; fi