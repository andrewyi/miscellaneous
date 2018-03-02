#!/bin/bash
# used for cheanjia deployments
# set -x

CURRENT_DIR=$(pwd)
PROJECT_DIR_NAME=$(basename ${CURRENT_DIR})
PROJECT_NAME=${PROJECT_DIR_NAME}

EXECUTABLE_NAME=$(basename $0)
EXECUTABLE_TYPE=${EXECUTABLE_NAME%.*}
RSA_KEY_PREFIX=${PROJECT_NAME%-*}

function validate_project() {
    git status > /dev/null 2>&1
    if [ ! "$?" -eq 0 ]; then
        echo "this is not a git project"
        exit 1
    fi

    if [ ! -e "venv" -o ! -d "venv" ]; then
        echo "no venv found for this workspace"
        exit 1
    fi
}

validate_project

function setup_webapp_env() {

    case ${PROJECT_NAME} in
        wechat-web)
            WORKER_COUNT=3
            PORT=5000
            ;;
        admin-web)
            WORKER_COUNT=1
            PORT=6000
            ;;
        merchant-web)
            WORKER_COUNT=1
            PORT=7000
            ;;
        qiye-web)
            WORKER_COUNT=3
            PORT=8000
            ;;
        zspay-web)
            WORKER_COUNT=1
            PORT=5100
            ;;
        client-manage-web)
            RSA_KEY_PREFIX="cm"
            PROJECT_NAME="cmw-web"
            WORKER_COUNT=1
            PORT=5200
            ;;
        *)
            echo "it seems that this project is not supported yet."
            exit 1
            ;;
    esac

    PID_FILE=$(echo ${PROJECT_NAME}.pid | sed 's/-/_/g')

    if [ ! -e "log" -o ! -d "log" ]; then
        rm -f ./log
        mkdir ./log
    fi

    source ./venv/bin/activate
}

function teardown() {
    deactivate
}

function teardown_and_exit() {
    deactivate > /dev/null 2>&1
    exit 1
}

function webapp_start() {
    if [ -e ${PID_FILE} ];then
        echo "service already running! return directly"
    else
        START_COMMAND="gunicorn -b 127.0.0.1:${PORT} -w ${WORKER_COUNT} wsgi:application -D -p ${PID_FILE}"
        ${START_COMMAND}
        echo "sleep 3 seconds for the processes setup"
        sleep 3
    fi

    webapp_status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    start fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function webapp_stop() {
    if [ ! -e ${PID_FILE} ];then
        echo "service not running! return directly"
    else
        STOP_COMMAND="kill $(cat ${PID_FILE})"
        ${STOP_COMMAND}
        echo "sleep 3 seconds for the gracefull exits of the processes"
        sleep 3
    fi

    webapp_status > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    stop fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function webapp_refresh() {
    webapp_status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    service not running, can't refresh    !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi

    REFRESH_COMMAND="kill -HUP $(cat ${PID_FILE})"
    ${REFRESH_COMMAND}
    echo "sleep 3 seconds for the refresh of the processes"
    sleep 3
}

function webapp_status() {
    if [ ! -e ${PID_FILE} ]; then
        echo "service not running"
        return 0 # 0 means not running
    else
        process_count=$(ps aux | grep ${PID_FILE} | grep -v grep | wc -l)
        if [ ${process_count} -eq 0 ]; then
            echo "pid file exists, but service not running! pid: $(cat ${PID_FILE})."
            rm ${PID_FILE}
            return 0
        else
            echo "service running with pid: $(cat ${PID_FILE})"
            echo "processes:"
            ps aux | grep ${PID_FILE} | grep -v grep
            return 1
        fi
    fi
}

function webapp_pull() {
    ssh-agent bash -c "ssh-add /home/app/.ssh/${RSA_KEY_PREFIX}_id_rsa; git pull" 
}

function webapp_monitor() {
    setup_webapp_env

    ACTION=$1
    OPTION=$2

    case ${ACTION} in
        start)
            echo "starting ..."
            webapp_start
            echo "started"
            ;;
        stop)
            echo "stopping..."
            webapp_stop
            echo "stopped"
            ;;
        refresh)
            echo "refreshing..."
            webapp_refresh
            echo "refreshed"
            ;;
        restart)
            echo "restarting..."
            webapp_stop
            webapp_start
            echo "restarted"
            ;;
        show|status)
            webapp_status
            ;;
        update|pull)
            webapp_pull
            ;;
        *)
            echo "invalid action, should be: start|stop|refresh|restart|status"
            ;;
    esac

    teardown
}

function setup_celery_env() {

    case ${PROJECT_NAME} in
        wechat-web)
            PACKAGE_NAME="app"
            ;;
        zsqy-web)
            PACKAGE_NAME="qiye"
            ;;
        qiye-web)
            PACKAGE_NAME="qiye"
            ;;
        *)
            echo "it seems that this project is not supported yet."
            exit 1
            ;;
    esac

    CELERY_BEAT_PID_FILE="celerybeat.pid"

    if [ ! -e "log" -o ! -d "log" ]; then
        rm -f ./log
        mkdir ./log
    fi

    source ./venv/bin/activate
}

function celery_beat_stop() {
    if [ ! -e ${CELERY_BEAT_PID_FILE} ];then
        echo "beat not running! return directly"
    else
        STOP_COMMAND="kill $(cat ${CELERY_BEAT_PID_FILE})"
        ${STOP_COMMAND}
        echo "sleep 3 seconds for the gracefull exits of the processes"
        sleep 3
    fi

    celery_beat_status > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    stop fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function celery_beat_start() {
    if [ -e ${CELERY_BEAT_PID_FILE} ];then
        echo "beat already running! return directly"
    else
        START_COMMAND="celery -A ${PACKAGE_NAME}.tasks -l INFO -f log/celery.beat.log beat"
        ${START_COMMAND} &
        echo "sleep 3 seconds for the processes setup"
        sleep 3
    fi

    celery_beat_status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    start fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function celery_beat_status() {
    if [ ! -e ${CELERY_BEAT_PID_FILE} ];then
        echo "beat not running"
        return 0 # 0 means not running
    else
        process_count=$(ps aux | grep ${PACKAGE_NAME}.task | grep beat | grep -v grep | wc -l)
        if [ ${process_count} -eq 0 ]; then
            echo "pid file exists, but beat not running! pid: $(cat ${CELERY_BEAT_PID_FILE})."
            rm ${CELERY_BEAT_PID_FILE}
            return 0
        else
            echo "beat running with pid: $(cat ${CELERY_BEAT_PID_FILE})"
            echo "processes:"
            ps aux | grep ${PACKAGE_NAME}.task | grep beat | grep -v grep
            return 1
        fi
    fi
}

function celery_beat_monitor() {
    ACTION=$1
    case ${ACTION} in
        start)
            echo "starting"
            celery_beat_start
            echo "started"
            ;;
        stop)
            echo "stopping"
            celery_beat_stop
            echo "stopped"
            ;;
        restart)
            echo "restarting"
            celery_beat_stop
            celery_beat_start
            echo "restarted"
            ;;
        status)
            celery_beat_status
            ;;
        *)
            echo "this action is not support"
            teardown_and_exit
            ;;
    esac
}

function celery_worker_stop() {
    celery_worker_status > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "beat not running! return directly"
    else
        for pid in $(ps aux | grep ${PACKAGE_NAME}.task | grep worker| grep -v grep | awk '{print $2}')
        do
            kill -9 ${pid}
        done
        echo "sleep 3 seconds for the gracefull exits of the processes"
        sleep 3
    fi

    celery_worker_status > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    stop fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function celery_worker_start() {
    celery_worker_status > /dev/null 2>&1

    if [ ! $? -eq 0 ]; then
        echo "worker already running! return directly"
    else
        START_COMMAND="celery -A ${PACKAGE_NAME}.tasks -l INFO -f log/celery.worker.log worker"
        ${START_COMMAND} &
        echo "sleep 3 seconds for the processes setup"
        sleep 3
    fi

    celery_worker_status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!    start fail.     !!!!!!!!!!!!!!!!"
        teardown_and_exit
    fi
}

function celery_worker_status() {
    process_count=$(ps aux | grep ${PACKAGE_NAME}.task | grep worker | grep -v grep | wc -l)
    if [ ${process_count} -eq 0 ]; then
        echo "worker not running!"
        return 0
    else
        echo "worker running"
        echo "processes:"
        ps aux | grep ${PACKAGE_NAME}.task | grep worker | grep -v grep
        return 1
    fi
}

function celery_worker_monitor() {
    ACTION=$1
    case ${ACTION} in
        start)
            echo "starting"
            celery_worker_start
            echo "started"
            ;;
        stop)
            echo "stopping"
            celery_worker_stop
            echo "stopped"
            ;;
        restart)
            echo "restarting"
            celery_worker_stop
            celery_worker_start
            echo "restarted"
            ;;
        status)
            celery_worker_status
            ;;
        *)
            echo "this action is not support"
            teardown_and_exit
            ;;
    esac
}

function celery_monitor() {
    setup_celery_env

    ACTION=$1
    SUB_TYPE=$2
    case ${SUB_TYPE} in
        b|beat)
            celery_beat_monitor ${ACTION}
            ;;

        w|worker)
            celery_worker_monitor ${ACTION}
            ;;
        *)
            echo "sub type (${SUB_TYPE}) not support"
            ;;
    esac

    teardown
}

function main() {

    ACTION=$1
    OPTION=$2
    case ${EXECUTABLE_TYPE} in
        deploy|webapp)
            webapp_monitor ${ACTION} ${OPTION}
            ;;
        celery)
            celery_monitor ${ACTION} ${OPTION}
            ;;
        *)
            echo "script can't run with this executable name"
            echo "please follow belowing steps to setup:"
            echo "  ln -s deploy_v2.sh webapp.sh"
            echo "      ../webapp.sh start|stop|restart|status"
            echo ""
            echo "  ln -s deploy_v2.sh celery.sh"
            echo "      ../celery.sh start|stop|restart|status beat|b|worker|w"
            teardown_and_exit
            ;;
    esac
}

main $1 $2
