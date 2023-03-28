# Setup terminal
cp zsh.sh oh-my-zsh.sh dracula-theme.sh spaceship-theme.sh zinit.sh $HOME/
cd $HOME/
sudo apt install make curl -y
sh ~/zsh.sh
sh ~/oh-my-zsh.sh
sh ~/dracula-theme.sh
sh ~/zinit.sh
sh ~/spaceship-theme.sh
cd $HOME/
rm -rf ~/zsh.sh ~/oh-my-zsh.sh ~/dracula-theme.sh ~/spaceship-theme.sh ~/zinit.sh
