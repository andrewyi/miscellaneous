# andrew's windows wsl settings

export PATH="/home/andrewyi/.local/bin:${PATH}"

export EDITOR=vim
umask 0022
export PATH="${HOME}/workspace/tools:${PATH}"
export PATH="${HOME}/workspace/tools/kubectl_plugins:${PATH}"

# golang
export GOPATH="${HOME}/workspace/go"
export PATH="${GOPATH}/bin:${PATH}"
export PATH="${HOME}/workspace/tools/go/bin:${PATH}"
export GO111MODULE=auto
export GOPROXY=https://mirrors.aliyun.com/goproxy,https://goproxy.cn,https://goproxy.io,https://proxy.golang.org,direct
export PATH="/home/andrewyi/workspace/tools/protoc/bin:${PATH}"

# python
alias flake8='python3 -m flake8'
alias venv='source ./venv/bin/activate'
alias av='source ~/workspace/ansible_venv/bin/activate'
# ANSIBLE_GATHERING=false # to disable gathering facts

# docker & k8s
export DOCKER_HOST="tcp://localhost:2375"
alias kubectl='/home/andrewyi/workspace/tools/kubectl'

# aliyun of yal.ender@gmail.com
export ALICLOUD_ACCESS_KEY="************************"
export ALICLOUD_SECRET_KEY="******************************"
