###
### PS1 prompt
###
########################


# Color Codes
Clear="\[\033[0m\]"
Black='\[\e[0;30m\]'
Red='\[\e[0;31m\]'
Green='\[\e[0;32m\]'
Yellow='\[\e[0;33m\]'
Blue='\[\e[0;34m\]'
Purple='\[\e[0;35m\]'
Cyan='\[\e[0;36m\]'
White='\[\e[0;37m\]'

# Bold Colors
BBlack='\[\e[1;30m\]'
BRed='\[\e[1;31m\]'
BGreen='\[\e[1;32m\]'
BYellow='\[\e[1;33m\]'
BBlue='\[\e[1;34m\]'
BPurple='\[\e[1;35m\]'
BCyan='\[\e[1;36m\]'
BWhite='\[\e[1;37m\]'

# Underline
BUBlack='\[\e[1;4;30m\]'
BURed='\[\e[1;4;31m\]'
BUGreen='\[\e[1;4;32m\]'
BUYellow='\[\e[1;4;33m\]'
BUBlue='\[\e[1;4;34m\]'
BUPurple='\[\e[1;4;35m\]'
BUCyan='\[\e[1;4;36m\]'
BUWhite='\[\e[1;4;37m\]'

# Background
BOn_Black='\[\e[1;40m\]'
BOn_Red='\[\e[1;41m\]'
BOn_Green='\[\e[1;42m\]'
BOn_Yellow='\[\e[1;43m\]'
BOn_Blue='\[\e[1;44m\]'
BOn_Purple='\[\e[1;45m\]'
BOn_Cyan='\[\e[1;46m\]'
BOn_White='\[\e[1;47m\]'

# High Intensity
BIBlack='\[\e[1;90m\]'
BIRed='\[\e[1;91m\]'
BIGreen='\[\e[1;92m\]'
BIYellow='\[\e[1;93m\]'
BIBlue='\[\e[1;94m\]'
BIPurple='\[\e[1;95m\]'
BICyan='\[\e[1;96m\]'
BIWhite='\[\e[1;97m\]'

# Bold High Intensity
BIBlack='\[\e[1;4;90m\]'
BIRed='\[\e[1;4;91m\]'
BIGreen='\[\e[1;4;92m\]'
BIYellow='\[\e[1;4;93m\]'
BIBlue='\[\e[1;4;94m\]'
BIPurple='\[\e[1;4;95m\]'
BICyan='\[\e[1;4;96m\]'
BIWhite='\[\e[1;4;97m\]'

# High Intensity backgrounds
BOn_IBlack='\[\e[1;100m\]'
BOn_IRed='\[\e[1;101m\]'
BOn_IGreen='\[\e[1;102m\]'
BOn_IYellow='\[\e[1;103m\]'
BOn_IBlue='\[\e[1;104m\]'
BOn_IPurple='\[\e[1;105m\]'
BOn_ICyan='\[\e[1;106m\]'
BOn_IWhite='\[\e[1;107m\]'



###
### BASH PS1
###
##########################


# Success of previous command
PS1_SUCCESS="\$(ret=\$?; if [ \$ret != 0 ]; then echo \[\e[31m\][\$ret] \[\e[0m\]; fi)"


_get_git_dirty() {
    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'
    local marks

    local tmp="$( git status --porcelain --branch 2> /dev/null )"
    if [ "${?}" != "0" ]; then
        return 1
    fi

    local stat="$( echo "${tmp}" | grep '^##' | grep -o '\[.\+\]$')"

    [[ $( echo "${tmp}" | wc -l) -gt 1 ]] && marks+="${GIT_BRANCH_CHANGED_SYMBOL}"

    # how many commits local branch is ahead/behind of remote?
    local stat="$( echo "${tmp}" | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN="$(echo $stat | grep -o 'ahead[[:space:]][0-9]+' | grep -o '[0-9]\+' )"
    local behindN="$(echo $stat | grep -o 'behind[[:space:]][0-9]\+' | grep -o '[0-9]\+' )"
    [ -n "$aheadN" ] && marks+=" ${GIT_NEED_PUSH_SYMBOL}${aheadN}"
    [ -n "$behindN" ] && marks+=" ${GIT_NEED_PULL_SYMBOL}${behindN}"

    echo "${marks}"
}


_get_git_branch() {
    readonly GIT_BRANCH_SYMBOL=""
    local git_branch

    if ! git_branch="$( git branch --no-color 2> /dev/null | grep '^*[[:space:]]' )"; then
        return 1
    fi

    git_branch="$( echo "${git_branch}" | sed 's/^\*[[:space:]]*//g' )"
    echo "${GIT_BRANCH_SYMBOL}${git_branch}"
}


_get_git_remote() {
    readonly GIT_REMOTE_SYMBOL="☿"
    local git_remote

    if ! git_remote="$( git remote -v 2> /dev/null )"; then
        return 1
    fi

    # has remote?
    if ! git_remote="$( echo "${git_remote}" | grep '(fetch)' )"; then
        echo "[no remote]"
        return
    fi

    git_remote="$( echo "${git_remote% (fetch)}" )"
    if [ "${#git_remote}" = "0" ]; then
        return
    fi
    git_remote="$( basename "${git_remote}" )"
    echo "${GIT_REMOTE_SYMBOL} ${git_remote}"
}


get_git_prompt() {
    local git_dirty
    local git_branch
    local git_remote

    if ! git_dirty="$( _get_git_dirty )"; then
        return
    fi
    if ! git_branch="$( _get_git_branch )"; then
        return
    fi
    if ! git_remote="$( _get_git_remote )"; then
        return
    fi

    # echo "(${git_remote} ${git_branch}${git_dirty})"
    echo " (${git_branch})"
}


parse_svn() {
    # Helpers
    local svn_info
    local svn_root
    local svn_url

    # Final output
    local branch
    local repository
    svn_info=$(svn info 2>/dev/null)

    if [ ${#svn_info} -gt 0 ]; then
        svn_root=$(echo "$svn_info" | sed -ne 's#^Repository Root: ##p')
        svn_url=$(echo "$svn_info" | sed -ne 's#^URL: ##p')

        repository=$(echo "$svn_info" | grep "^Repository Root" | awk '{print $3}')
        repository=$(basename $repository)

        branch=$(echo "$svn_url" | sed -e 's#^'"$svn_root"'##g')
        branch=$(echo "$branch" | cut -d "/" -f2)

        if [ ${#branch} -eq 0 ]; then
            branch="/"
        fi

        echo " (svn::${repository}::${branch})"
    fi
}
# Append Git status?
if command -v git >/dev/null 2>&1; then
    PS1_GIT="\[$BRed\]\$(get_git_prompt)\[$Clear\]"
else
    PS1_GIT=""
fi


# Append SVN status?
if command -v svn >/dev/null 2>&1 ; then
    PS1_SVN="\[$BRed\]\$(parse_svn)\[$Clear\]"
else
    PS1_SVN=""
fi


# Inside FreeBSD Jail
if [ -d /boot/kernel ] && [ $(ls -l /boot/kernel/ | grep -v total | wc -l) == "0" ]; then
    PS1_JAIL="[\[$Green\]JAIL\[$Clear\]]"
else
    PS1_JAIL="\[$Clear\]"
fi


# User Color
PS1_USER="\[$(if [ "$USER" = "root" ]; then echo $Red; else echo $Blue; fi)\]\u\[$Clear\]"
PS1_CHAR="\[$(if [ "$USER" = "root" ]; then echo $Red; else echo $Blue; fi)\]\$\[$Clear\]"


# Other prompt components
PS1_HIST="[\#]"
PS1_HOST="\[$Cyan\]\H"
PS1_PATH="\[$Green\]\$PWD\[$Clear\]"
PS1_GO="\[$Clear\]C:\\>\[$Clear\]"


# Determine the environment (tmux or not)
pid="$$"
lvl="$( pstree -s -p ${pid} | sed 's/[()0-9]//g' | awk -F "---" '{for (i=2; i<NF; i++) print $i}' )"
post=
for l in $lvl; do
    post="${post}${l}>"
done
PS1_GO="${post/#sh>urxvt>/}"

# Set the final PS1
# export PS1="${PS1_SUCCESS}\n${PS1_HIST} ${Purple}\u ${Clear}at ${Yellow}\h ${Clear}in ${Green}\w${PS1_GIT}${PS1_SVN}${Clear}\n${PS1_GO} "
export PS1="${PS1_SUCCESS}${Green}\u@\h${Clear}:${Blue}\W${Clear}${White}\$${Clear} "
