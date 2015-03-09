# used to fit andrew's personal settings

# tools/path settings
PATH=/home/andrew/personal_tools/bin:${PATH}
export PATH

# common settings
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL

EDITOR=vim
export EDITOR
alias vi=vim

LOCAL_IP=$(/sbin/ifconfig | grep -A 1 "eth1" | sed -n '/inet addr/p' | grep -v "127.0.0.1" | awk -F"([\t ]*|:)" '{print $4}')
export LOCAL_IP

PS1='\u@${LOCAL_IP}:\W>'
export PS1

# set sercureCRT tab title
function set_title() {
    title=$1
    if [ ! "${title}" == "" ];then
        echo -ne "\033]2;${title}\007"
        echo "set title: ${title}"
    fi
}
alias settitle='set_title'

# accelerate operations
function gen_tags() {
    file=$1
    if [ -e ${file} ];then
        ctags -R --c++-kinds=+px --fields=+iaS --extra=+q --languages=C++,+C -L ${file}
    else
        ctags -R --c++-kinds=+px --fields=+iaS --extra=+q --languages=C++,+C
    fi
}
alias gentags='gen_tags'

function ls_pwd() {
    echo "current dir ---------------------------->:"
    pwd
    echo "list files  ---------------------------->:"
    ls -lrt
}
alias lspwd='ls_pwd'
alias pwdls='ls_pwd'

alias sl='ls'
alias s='ls'
alias lsa='ls -a'
