### installation

curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/install.sh -o install.sh


sudo snap install go --classic && echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc && echo 'export GOPATH=$HOME/go' >> ~/.bashrc && echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc && source ~/.bashrc && go version
