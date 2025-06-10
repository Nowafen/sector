### installation

curl -fsSL https://raw.githubusercontent.com/Nowafen/sector/main/install.sh -o install.sh

'''
wget https://golang.org/dl/go1.22.5.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz && echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && echo 'export GOPATH=$HOME/go' >> ~/.bashrc && echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc && source ~/.bashrc && rm go1.22.5.linux-amd64.tar.gz && go version
