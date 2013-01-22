


# System Variables

_vcs_prompt() {
    if [ -d .git ]; then
        git_branch="$(basename "$(git symbolic-ref HEAD 2>/dev/null)")"
        if git diff-files --quiet; then
            if git diff-index --quiet --cached HEAD; then
                git_status=""
            else
                git_status="+"
            fi
        else
            git_status="*"
        fi
        echo -n "[${git_repo}${git_branch}]${git_status}"
    fi
}

export PS1="\[\e[1;32m\]\u@\h>\[\e[0;36m\] \W \[\e[0;32m\]\$(_vcs_prompt)\n\[\e[0m\]> \[\e[1;36m\]"
trap 'echo -ne "\e[0m"' DEBUG # different colors for text entry and console output 
source /usr/share/git/completion/git-completion.bash
complete -o default -o nospace -F _git g # completion with 'g' if alias g as git

export PROMPT_DIRTRIM=3
export EDITOR="vim"
export VISUAL="vim"
export TERM="screen-256color"

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob

#  Input Method
export GTK_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export XIM=ibus
export LC_CTYPE=zh_CN.UTF-8 # for emacs

#  History
export HISTCONTROL=ignoredups # ignore duplicates items
export HISTIGNORE="[   ]*:&:bg:exit:H*:history*" # ignore these items; H, history | grep
export HISTSIZE=10000
export HISTFILESIZE=5000
shopt -s histappend  # append history not overwrite 
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"    



#  Alias

alias H='history | grep'
alias aria='aria2c -c -s 5 -d ~/tmp'
alias cp='cp -i' # confirm before overwriting something
alias conf='sh ~/configs/configs'
alias df='df -h' # human-readable sizes
alias dk='setxkbmap dvorak && xmodmap ~/.Xmodmap'
alias duinfo='du -hm -d 1 | sort -nr'
alias e='emacsclient -nw'
alias fehm='feh -m -H 800 -w 1280'
alias fehc='feh -c -H 800 -w 1280'
alias fr='mplayer -shuffle -fs -fixed-vo /media/Resources/Movies/Friends_HD/*.rmvb'
alias ha='hg add'
alias hs='hg status'
alias hm='hg commit -m'
alias hl='hg lga'
alias hd='hg diff'
alias hu='hg update'
alias hr='hg revert'
alias g='git'
alias gta='sh ~/configs/git_status.sh'
alias isilo='wine /media/Archives/Program\ Files/iSilo/iSilo/iSilo.exe'
alias ll='ls -l --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=auto -ohF'
alias grep='grep --color=tty -d skip'
alias ls='ls --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=auto -F'
alias man='TERM="xterm-256color" man'
alias mirror='wget -r -p -np -k -E -w 2 --random-wait'
alias mnt='sudo mount -o iocharset=utf8,uid=ryan'
alias mountU='mnt /dev/sdb1 /media/usb'
alias mountFTP='sudo curlftpfs -o codepage=gbk -o allow_other 192.168.1.70 /media/ftp/'
alias mountFTPHD='sudo curlftpfs 192.168.161.10 /media/ftp/ -o codepage=gbk,allow_other'
alias mt='mutt -F ~/.mutt/.muttrc'
alias mv='mv -i'
alias nlc='python2 /home/ryan/local/scripts/python/nlc/nlc_daemon.py'
alias rm='rm -vi'
alias rss='python2 ~/local/scripts/kindle/fetch_rss/fetch_rss.py'
alias rst='sudo shutdown -r now'
alias shd='sudo shutdown -h now'
alias t='sh ~/local/scripts/tmux_dev.sh'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias umountU='sudo umount /media/usb'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING)=\"NAME\",\"CLASS\""'
alias wc='sudo mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot -geometry 128x80+576+720 -name "webcamera"'
alias play='mplayer -include /home/ryan/.mplayer/config.mv -xy 500 -shuffle -loop 0 -fixed-vo'
alias pep8='pep8-python2 --show-source --max-line-length=87'
alias tracver='sudo python2 /home/ryan/local/scripts/python/trac/delete_page_version.py'



#  Functions

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

[ -n "$XTERM_VERSION" ] && transset-df -a .85 >/dev/null # autotrans if launched in xterm 
