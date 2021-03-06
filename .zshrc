
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load default dotfiles after zsh so that my variable/aliases override
# zsh's.
source ~/.bash_profile

# Make sure zsh cache is updated whenever PATH is modified.
zstyle ":completion:*:commands" rehash 1
