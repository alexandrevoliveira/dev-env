#!/bin/bash

# set -o errexit

echo '### STARTING SETUP TERMINAL ###'

# Zsh install
if [[ ! "$(which zsh)" =~ /*bin/zsh ]]; then
  echo '### Zsh ###'
  sudo apt install zsh -y
  chsh -s $(which zsh) $(whoami)
fi

# Oh My Zsh install => (https://draculatheme.com/gnome-terminal)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo '### Oh My Zsh ###'
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o "$HOME/ohmyzsh.sh"
  sudo chown $USER:$USER $HOME/ohmyzsh.sh
  chmod ug+x $HOME/ohmyzsh.sh
  sh -c $HOME/ohmyzsh.sh
fi

# Zinit install => (https://github.com/zdharma-continuum/zinit#automatic)
if [ ! -d "$HOME/.local/share/zinit" ]; then
  echo '### Zinit ###'
  curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh -o "$HOME/zinit.sh"
  sudo chown $USER:$USER $HOME/zinit.sh
  chmod ug+x $HOME/zinit.sh
  sh -c $HOME/zinit.sh
  if [ ! $(cat ~/.zshrc | grep "zinit light zdharma") ]; then
    echo '
    zinit light zdharma/fast-syntax-highlighting
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-completions
    ' >> ~/.zshrc
  fi
  zinit self-update
fi

# Spaceship theme install
if [ ! -d "$HOME/spaceship" ]; then
  echo '### Spaceship ###'
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/spaceship/themes/spaceship-prompt" --depth=1
  ln -s "$HOME/spaceship/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/spaceship/themes/spaceship.zsh-theme"
  ln -s "$HOME/spaceship/themes/spaceship.zsh-theme" "$HOME/.oh-my-zsh/themes/spaceship.zsh-theme"
  sudo chown -R $USER:$USER $HOME/spaceship
  chmod ug+x -R $HOME/spaceship
  if [ ! $(cat ~/.zshrc | grep SPACESHIP_PROMPT_ORDER) ]; then
    echo 'SPACESHIP_PROMPT_ORDER=(
      user          # Username section
      dir           # Current directory section
      host          # Hostname section
      git           # Git section (git_branch + git_status)
      hg            # Mercurial section (hg_branch  + hg_status)
      exec_time     # Execution time
      line_sep      # Line break
      vi_mode       # Vi-mode indicator
      jobs          # Background jobs indicator
      exit_code     # Exit code section
      char          # Prompt character
    )
    SPACESHIP_USER_SHOW=always
    SPACESHIP_PROMPT_ADD_NEWLINE=false
    SPACESHIP_CHAR_SYMBOL="❯"
    SPACESHIP_CHAR_SUFFIX=" "' >> ~/.zshrc
  fi
fi

# Agora dentro do arquivo ~/.zshrc vamos alterar a variável ZSH_THEME ficando dessa forma:
# ZSH_THEME="spaceship"

# Dracula Theme for Zsh install
if [ ! -d "$HOME/gnome-terminal" ]; then
  echo '### Dracula Theme for Zsh ###'
  sudo apt install dconf-cli
  git clone https://github.com/dracula/gnome-terminal $HOME/gnome-terminal
  sudo chown -R $USER:$USER $HOME/gnome-terminal
  chmod ug+x -R $HOME/gnome-terminal
  sh -c gnome-terminal/install.sh
fi

source $HOME/.zshrc

sudo rm -f $HOME/ohmyzsh.sh $HOME/zinit.sh

echo '### FINISHING SETUP TERMINAL ###'
