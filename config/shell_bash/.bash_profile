# env settings
LANG=en_US.UTF-8
export LANG
LC_ALL=en_US.UTF-8
export LC_ALL

# CLICOLOR=1
# export CLICOLOR
PS1='\u:my-macbookpro:\W$'
export PS1

# LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
# export LS_COLORS

export EDITOR="vim"

# set sercureCRT tab title                                                        
function title() {                                                            
    title=$1                                                                      
    if [ ! "${title}" == "" ];then                                                
        echo -ne "\033]0; ${*} \007"                                            
        # echo -ne "\033]0; Hello World \007"
        echo "set title: ${*}"                                                
    else
        echo "no title input!"
    fi                                                                            
}                                                                                 
# alias ='set_title'

# command shortcut
alias vi='vim'
alias ls='gls --color=auto'
alias sl='gls --color=auto'
alias ll='gls --color=auto -lrt'
alias ..='cd ..'
alias tailf='tail -f'

PATH="/usr/local/sbin:${PATH}"
export PATH

# restart airport
function restart_airport() {
    networksetup -setairportpower en0 off
    networksetup -setairportpower en0 on
}
alias rewifi='restart_airport'

# alias tmux='/Users/andrewyi/sourcespace/tmux/tmux -2 -u'

# restart clipboard
alias restartpb='launchctl stop com.apple.pboard && launchctl start com.apple.pboard'

# find
# alias mfind='find . -type f ! -path "./venv/*" ! -path "./.git/*" -exec'

function find_in_python_file () {
    input_content=$1
    if [ "${input_content}" == "" ]; then
        echo "no input..."
        return
    fi
    find . -name "*.py" ! -path "./tests/*" ! -path "./venv/*" ! -path "./.git/*" -exec grep -iHn -C 2 "${input_content}" {} \;
}
alias pyfind='find_in_python_file'

function find_in_file () {
    input_content=$1
    if [ "${input_content}" == "" ]; then
        echo "no input..."
        return
    fi
    find . -type f ! -path "./instance/*" ! -path "./tests/*" ! -path "./venv/*" ! -path "./.git/*" -exec grep -iHn -C 2 "${input_content}" {} \;
}
alias ffind='find_in_file'

# go settings
# GOROOT='/Users/andrewyi/workspace/tools/go1.10.3'
# export GOROOT

# PATH="${GOROOT}/bin:${PATH}"
PATH="/Users/andrewyi/workspace/tools/go/bin:${PATH}"
export PATH

GOPATH='/Users/andrewyi/workspace/go'
export GOPATH

PATH="${GOPATH}/bin:${PATH}"
export PATH

alias cdgo='cd /Users/andrewyi/workspace/go'

# for go-ethereum testing
# export PATH="/Users/andrewyi/workspace/go/src/github.com/ethereum/go-ethereum/build/bin:${PATH}"

# nohup go-shadowsocks2 -c 'ss://AES-256-CFB:uc8n35a9v3adf4jKKdasdfowe@139.162.54.123:443' -socks :1050 -u -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 > /dev/null 2>&1 &

# docker run --restart=always -v /var/run/docker.sock:/var/run/docker.sock -p 2376:2375 --name remoteapi -d bobrik/socat TCP4-LISTEN:2375,fork,reuseaddr UNIX-CONNECT:/var/run/docker.sock

alias cdjs='cd /Users/andrewyi/workspace/javascript'

export PATH="/Users/andrewyi/workspace/wsk:${PATH}"
alias wsk='wsk -i'
alias venv='. venv/bin/activate'

export PATH="/Users/andrewyi/workspace/tools/protoc/bin:${PATH}"

# export PATH="${PATH}:/Users/andrewyi/workspace/helm/darwin-amd64"
alias helm212="/Users/andrewyi/workspace/helm/darwin-amd64/helm"
alias helm214="/Users/andrewyi/workspace/helm214/darwin-amd64/helm"

export GO111MODULE=on

s() {
  str=''
  arr=("$@")
  for i in ${!arr[@]}; do
    if [ "$i" -eq 0 ]; then
      str+="${arr[$i]}"
    else
      str+="%20${arr[$i]}"
    fi
  done
  curl "v2en.co/$str"
}
