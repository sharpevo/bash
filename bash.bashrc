


# Conditions

is_root=false
[[ $UID -eq 0 ]] && is_root=true

# System Variables

_vcs_prompt() {
    if [ -d .git ]; then
        if git rev-parse --quiet --verify --no-revs HEAD; then
            git_branch=$(git rev-parse --abbrev-ref HEAD)
            if git diff-files --quiet; then
                if git diff-index --quiet --cached HEAD; then
                    git_status=""
                else
                    git_status="+"
                fi
            else
                git_status="*"
            fi
            echo -n "[${git_branch}]${git_status}"
        else
            echo -n "[init]"
        fi
    fi
}

$is_root && user_color="\[\e[31m\]" || user_color="\[\e[1;32m\]"
export PS1="$user_color\u@\h>\[\e[0;36m\] \W \[\e[0;32m\]\$(_vcs_prompt)\n\[\e[0m\]> \[\e[1;36m\]"
trap 'echo -ne "\e[0m"' DEBUG # different colors for text entry and console output 
source /usr/share/git/completion/git-completion.bash
complete -o default -o nospace -F _git g # completion with 'g' if alias g as git

export PROMPT_DIRTRIM=3
export EDITOR="vim"
export VISUAL="/usr/bin/vim -p -X"
export TERM="screen-256color"

complete -cf sudo
# User friendly completion
bind '"\C-j": menu-complete'
#bind '"\C-k": menu-complete-backward'
set completion-ignore-case on

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s hostcomplete
shopt -s nocaseglob


#  History
export HISTCONTROL=ignoredups # ignore duplicates items
export HISTIGNORE="[   ]*:&:bg:exit:H*:history*" # ignore these items; H, history | grep
export HISTSIZE=10000
export HISTFILESIZE=5000
shopt -s histappend  # append history not overwrite 
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"    


#  Alias

alias ..='cd ..'
alias aria='aria2c -c -s 5 -d /tmp'
alias cp2='sudo rsync -trh --progress'
alias mv2='sudo rsync -trh --progress --remove-source-files'
alias ct='sh /home/yang/dev/night_vision/night_vision.sh'
alias df='df -h' # human-readable sizes
alias dk='setxkbmap dvorak && xmodmap /home/yang/.Xmodmap'
alias duinfo='du -hm -d 1 | sort -nr'
alias g='git'
alias ll='ls -al --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=never -ohF'
alias grep='grep --color=tty -d skip'
alias ls='ls --group-directories-first --time-style=+"%d/%m/%Y %H:%M" --color=auto -F'
alias man='TERM="xterm-256color" man'
alias mirror='wget -r -p -np -k -E -w 2 --random-wait'
alias mnt='sudo mount -o iocharset=utf8,uid=yang'
alias mountU='mnt /dev/sdb1 /mnt/usb'
alias mountFTP='sudo curlftpfs -o codepage=gbk -o allow_other 192.168.1.70 /mnt/ftp/'
alias mountFTPHD='sudo curlftpfs 192.168.161.10 /mnt/ftp/ -o codepage=gbk,allow_other'
alias mv='mv -i'
alias nlc='python2 /mnt/linux/home/ryan/local/scripts/python/nlc/nlc_daemon.py'
alias tm='sh /etc/tmux_dev.sh'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias umountU='sudo umount /mnt/usb'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING)=\"NAME\",\"CLASS\""'
alias pep8='pep8-python2 --show-source --max-line-length=87'
alias tracver='sudo python2 /home/ryan/local/scripts/python/trac/delete_page_version.py'

if ! $is_root;then
    alias conf='sh ~/configs/configs'
    alias disc='python2 ~/local/scripts/python/discipline/main.py'
    alias gta='sh ~/configs/git_status.sh'
    alias mt='mutt -F ~/.mutt/.muttrc'
    alias rss='python2 ~/local/scripts/kindle/fetch_rss/fetch_rss.py'
fi

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



# Shortcut function for directories

export MARKPATH=$HOME/.cache/.marks

jump() {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark() {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

unmark() {
    rm -i "$MARKPATH/$1"
}

marks() {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f8- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find $MARKPATH -type l -printf "%f\n")
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}
complete -F _completemarks jump unmark
