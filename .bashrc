
# Check for an interactive session
#[ -z "$PS1" ] && return

#if [ -f /etc/bash_completion ]; then
#	    . /etc/bash_completion
#fi

###############################
#  System Variables
###############################
# export PS1="\! \w\n    > "
#PS1='\[\e]0;\u@\H \w\a\[\e[32;1m\]$?\\$\[\e[0m\] ' #title: directory, return state of last command
#export PS1="\[\033[1;37m\]    \w > \[\033[0m\]"
#export PS1="\[\033[0;33m\]\w\n> \[\033[0m\]"
#export PS1="\[\033[1;30m\]\u\033[1;31m@\033[1;30m\h-> \033[0;32m\w\n\[\033[0m\]> "
# change prompt behavior in screen
#[[ -n "$STY" ]] && _screen='\[\ek\e\\\]\[\ek\W\e\\\]' || _screen=''
#export PS1="${_screen}\[\033[1;30m\]\u\033[1;31m@\033[1;30m\h-> \033[0;32m\w\n\[\033[0m\]> "

red='\[\e[0;31m\]'
# loosely based on rson's
_git_prompt() {
  if [[ -d .git ]]; then
    # determine repo/branch; todo: find a better way
    git_repo="$(git remote -v | tail -n 1 | sed 's|^.*/\(.*\)\.git .*$|\1|g')"
    git_branch="$(basename "$(git symbolic-ref HEAD 2>/dev/null)")"

    # note changes yet to be committed
    if git status | grep -Fq 'nothing to commit, working directory clean'; then
      git_status=''
    else
      git_status='*'
    fi

#     echo "-> git/${git_repo}:${git_branch}${git_status}"
    echo "[${git_repo}${git_branch}]${git_status}"
  fi
}
_hg_prompt() {
    if [[ -d .hg ]]; then
        hg prompt "[{branch}{({bookmark})}]{status}" 2> /dev/null
    fi
}

_vcs_prompt() {
    export vcs_cmd='2'
    if [ -d .git ]; then
        git_branch="$(git symbolic-ref HEAD 2> /dev/null | cut -b 12-)"
        if git status | grep -Fq 'nothing to commit, working directory clean'; then
            git_status=''
        else
            git_status='*'
        fi

        echo -n "[${git_repo}${git_branch}]${git_status}"
    fi
}

export PS1="\[\033[1;30m\]\u@\033[1;30m\h>\033[0;36m \W \[\033[0;32m\$(_vcs_prompt) \n\[\033[0m\]> "
# export PS1="\[\033[1;30m\]\u@\033[1;30m\h>\033[0;36m \W \[\033[1;32m\$(_vcs_prompt) \n\[\033[0m\]> "
#export PS1="\[${_screen}\033[1;30m\]\u@\033[1;30m\h>\033[0;36m \W \[\033[0;31m\$(_git_prompt) \n\[\033[0m\]> "

export PROMPT_DIRTRIM=3
# export EDITOR="emacsclient --alternate-editor=\"\" -c"
export EDITOR="vim"
export VISUAL="vim"
export TERM="screen-256color"
export SCREEN_CONF_DIR="/home/ryan/.screen"
export SCREEN_CONF="main"

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob

###############################
#  Input Method
###############################

export GTK_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export XIM=ibus
#export XIM_ARGS="ibus-daemon -d -x"
export LC_CTYPE=zh_CN.UTF-8 # for emacs

###############################
#  History
###############################

# export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoredups # ignore duplicates items
export HISTIGNORE="[   ]*:&:bg:exit:H*:history*" # ignore these items; H, history | grep
export HISTSIZE=10000
#export HISTSIZE=500
export HISTFILESIZE=5000

# The following code implements a global history that more terminals can share.
shopt -s histappend # adding items by append not by overwrite
PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # add history after an item execute, to read this one in a new terminal
# now the limitation should be the former terminal can not read the later ones items.

###############################
#  Alias
###############################

alias H='history | grep'
alias aria='aria2c -c -s 5 -d ~/tmp'
alias cp='cp -i'                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias dk='setxkbmap dvorak && xmodmap ~/.Xmodmap'
alias disc='python2 ~/local/scripts/python/discipline/main.py'
alias duinfo='du -hm -d 1 | sort -nr'
alias e='emacsclient -nw'
alias fehm='feh -m -H 800 -w 1280'
alias fehc='feh -c -H 800 -w 1280'
# alias fr='mplayer -shuffle -playlist ~/local/Friends.pls'
alias fr='mplayer -shuffle -fs -fixed-vo /media/Resources/Movies/Friends_HD/*.rmvb'
alias free='free'                      # show sizes in MB
alias ha='hg add'
alias hs='hg status'
alias hm='hg commit -m'
alias hl='hg lga'
alias hd='hg diff'
alias hu='hg update'
alias hr='hg revert'
# alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gam='git commit -a -m "'
alias gt='git status'
alias gm='git commit'
alias gl='git hist'
alias gll='git histfile'
alias gd='git diff'
alias gdd='git diff --color-words'
alias gr='git reset'
alias gk='git checkout'
alias isilo='wine /media/Archives/Program\ Files/iSilo/iSilo/iSilo.exe'
alias ll='ls -l --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=auto -ohF'alias grep='grep --color=tty -d skip'
alias ls='ls --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=auto -F'
alias mdict='wine /media/Archives/Program\ Files/MDictPC/MDict.exe'
alias mirror='wget -r -p -np -k -E -w 2 --random-wait'
alias mnt='sudo mount -o iocharset=utf8,uid=ryan'
alias mountA='mnt /dev/sda6 /media/Archives'
alias mountR='mnt /dev/sda5 /media/Resources'
alias mountU='mnt /dev/sdb1 /media/usb'
alias mountFTP='sudo curlftpfs -o codepage=gbk -o allow_other 192.168.1.70 /media/ftp/'
alias mountFTPHD='sudo curlftpfs 192.168.161.10 /media/ftp/ -o codepage=gbk,allow_other'
alias mt='mutt -F ~/.mutt/.muttrc'
alias mv='mv -i'
alias nlc='python2 /home/ryan/local/scripts/python/nlc/nlc_daemon.py'
alias rm='rm -vi'
alias rss='python2 ~/local/scripts/kindle/fetch_rss/fetch_rss.py'
alias rst='sudo shutdown -r now'
alias irssis='SCREEN_CONF=irssi screen -S irssi -D -R irssi'
alias shd='sudo shutdown -h now'
alias t='sh ~/local/scripts/tmux_dev.sh'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias umountA='sudo umount /media/Archives'
alias umountR='sudo umount /media/Resources'
alias umountU='sudo umount /media/usb'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING)=\"NAME\",\"CLASS\""'
alias wc='sudo mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot -geometry 128x80+576+720 -name "webcamera"'
alias play='mplayer -sub-bg-color 0 -sub-bg-alpha 80 -subcp enca:en:gb2312 -subfont "WenQuanYi Zen Hei Mono" -subfont-autoscale 2'
alias pep8='pep8-python2 --show-source --max-line-length=87'
alias ut='urxvtc -name irssiurxvt'
alias tracver='sudo python2 /home/ryan/local/scripts/python/trac/delete_page_version.py'
###############################
#  Functions
###############################

rnr() {
    if [ -n "$1" ];then
        case "$1" in
            tA|ta) xrandr --output LVDS1 --auto --output VGA1 --auto --above LVDS1 ;;
            tM|tm) xrandr --output LVDS1 --auto --output VGA1 --auto --same-as LVDS1 ;;
            xV|xv) xrandr --output VGA1 --off ;;
            xL|xl) xrandr --output LVDS1 --off ;;
            rL|rl) xrandr --output LVDS1 --auto --rotate left --output VGA1 --auto --rotate normal --above LVDS1 ;;
            rR|rr) xrandr --output LVDS1 --auto --rotate right --output VGA1 --auto --rotate normal --above LVDS1 ;;
            *) echo "rnr: invalid option '$1'  { tA/M | xV/L | rL/R }" ;;
        esac
    else
        echo "usage: rnr { tA/M | xV/L | rL/R }"
    fi
}

# play() {
#     if [ -n "$2" ];then
#         mplayer -sub-bg-color 0 -sub-bg-alpha 80 -subcp enca:en:gb2312 -subfont 'AR PL UKai CN' -subfont-autoscale 2 -sub $1 $2
#     else
#         mplayer $1
#     fi
# }

vue () {

    cd /media/Archives/vue;
    java -jar VUE.jar;
}

wlanon(){
    sudo ifconfig wlan0 up
    sudo wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
    sleep 5 && sudo dhcpcd wlan0
}


wlanoff() {
#    sudo killall dhcpcd;
    sudo dhcpcd -k wlan0;
    sudo killall wpa_supplicant;
}


cl() {
    cd "$1";
    ll;
}

ex (){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# source ~/local/git_projects/git/contrib/completion/git-completion.bash
source /usr/share/git/completion/git-completion.bash
# Assuming you've aliased 'git' to 'g'
complete -o default -o nospace -F _git g

# Use bash-completion, if available
#. /etc/bash_completion.d/hg2
#. /etc/bash_completion.d/git
#. /etc/bash_completion.d/zathura
#. ~/local/git-prompt/git-prompt.sh

# automatic transparency if launch a shell in xterm
[ -n "$XTERM_VERSION" ] && transset-df -a .75 >/dev/null