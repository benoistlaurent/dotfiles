
ZSH_THEME="dst"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Use oh-my-zsh.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load default dotfiles after zsh so that my variable/aliases override
# zsh's.
source ~/.bash_profile
