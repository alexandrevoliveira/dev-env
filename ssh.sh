# generate ssh key
ssh-keygen -o -b 4096 -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "myemail@mail.com"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519