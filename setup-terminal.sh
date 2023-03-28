# Setup terminal
cp zsh.sh oh-my-zsh.sh dracula-theme.sh spaceship-theme.sh zinit.sh $HOME/
cd $HOME/
sudo apt install make curl -y
./zsh.sh
./oh-my-zsh.sh
./dracula-theme.sh
./spaceship-theme.sh
./zinit.sh
cd $HOME/
rm ~/zsh.sh ~/oh-my-zsh.sh ~/dracula-theme.sh ~/spaceship-theme.sh ~/zinit.sh
