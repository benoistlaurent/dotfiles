# Load our dotfiles like ~/.bash_prompt, etc...
# Untracked setting should be put in $HOME/.extra
for file in ~/.{extra,paths,prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups                   # no duplicate entries
export HISTSIZE=100000                                    # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                             # big big history
if type shopt &> /dev/null; then shopt -s histappend; fi  # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.

