#!/bin/bash

echo '### STARTING SETUP DEV ###'

readonly devEnvDir=$(pwd)

# Node.js
if [ "$(which node)" != '/usr/bin/node' ]; then
  echo '### Node.js ###'
  curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g typescript npm-check
fi

# NVM
if [ ! -d "/home/$USER/.nvm" ]; then
  echo '### NVM ###'
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# # Docker & Docker Compose
if [[ ! "$(which docker)" =~ /*bin/docker ]]; then
  echo '### Docker & Docker Compose ###'
  sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  sudo rm -rf /var/lib/docker
  sudo rm -rf /var/lib/containerd
  sudo rm -rf /usr/bin/compose
  sudo apt update
  if [ ! -d "/etc/apt/keyrings" ]; then
    echo 'creating /etc/apt/keyings directory'
    sudo mkdir -m 755 -p /etc/apt/keyrings
  fi
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo newgrp docker
fi

# kubectl
if [[ ! "$(which kubectl)" =~ /*bin/kubectl ]]; then
  echo '### Kubectl ###'
  sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt update
  sudo apt install -y kubectl
fi

# minikube
if [[ ! "$(which minikube)" =~ /*bin/minikube ]]; then
  echo '### Minikube ###'
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  sudo rm -f ~/minikube-linux-amd64
fi

# k3d
if [[ ! "$(which k3d)" =~ /*bin/k3d ]]; then
  echo '### K3d ###'
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  sudo chown $USER:$USER -R /usr/local/bin
fi

# krew (kubectl plugin manager)
if [ ! -d "$HOME/.krew" ]; then
  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
  )
  cd $devEnvDir
  echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc

  # kubectl ctx & ns
  kubectl krew install ctx
  kubectl krew install ns
fi


# gcloud
if [[ ! "$(which gcloud)" =~ /*bin/gcloud ]]; then
  echo '### Google Cloud CLI ###'
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  sudo apt update && sudo apt install -y google-cloud-cli
fi

# helm
if [[ ! "$(which gcloud)" =~ /*bin/gcloud ]]; then
  echo '### HELM ###'
  curl -LO https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz
  tar -zxvf helm-v3.11.2-linux-amd64.tar.gz
  sudo chown $USER:$USER -R /usr/local/bin
  cp ~/linux-amd64/helm /usr/local/bin/helm
  sudo chmod +x /usr/local/bin/helm
  rm -rf ~/helm-v3.11.2-linux-amd64.tar.gz
fi

# Telepresence
if [[ ! "$(which telepresence)" =~ /*bin/telepresence ]]; then
  echo '### Telepresence ###'
  # 1. Download the latest binary (~50 MB):
  sudo curl -fL https://app.getambassador.io/download/tel2/linux/amd64/latest/telepresence -o /usr/local/bin/telepresence
  # 2. Make the binary executable:
  sudo chmod +x /usr/local/bin/telepresence
  sudo chown $USER:$USER -R /usr/local/bin
fi

# Terraform
if [[ ! "$(which terraform)" =~ /*bin/terraform ]]; then
  echo '### Terraform ###'
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install -y terraform
fi

echo '### FINISHING SETUP DEV ###'
