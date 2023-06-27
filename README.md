# AutoScanForMe

### Installation Requirements:
Maximum tools are made in **go**, So Install golang on your liux:
```
Go to official site of go https://go.dev/dl/ and download the latest version of golang 
* Follow the steps:
$ wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
* Extract the tar file:
$ tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
* Add environment PATH variables for go Lang
$ nano ~/.zshrc
* Go to the bottom of this file and paste it.

GOPATH=/root/go-workspace
export GOROOT=/usr/local/go
PATH=$PATH:$GOROOT/bin/:$GOPATH/bin

* Then click CTRL+O and press ENTER to save the file And to exit from this file click CTRL+X After this refresh the terminal: 
$ source ~/.zshrc
* For check golang version:
$ go version
```
### After complete go installation run setup.sh script file, before this script run give it to permission chmod +x setup.sh
#### In this script Installing Subfinder, Assetfinder, Waybackurls, Nuclei, dirsearch, bhedak, GF and more..
### After complete full installation then give it to permission chmod +x Recon.sh and run the main tool Recon.sh
#### If tools were not work, then install all required tools:
```
Subfinder, Assetfinder, Waybackuls, Nuclei, GF
```
### GF Tool Installation
```
$ go install -v github.com/tomnomnom/gf@latest
* Go path:
/root/go-workspace/
$ cp gf /usr/local/bin
* Download GF and GF patterns
$ git clone https://github.com/tomnomnom/gf
$ git clone https://github.com/1ndianl33t/Gf-Patterns
* Make a folder in root in new terminal
$ mkdir .gf
* Gf examples
$ cd /gf/examples
$ cp * /root/.gf
* Gf patterns
$ cd /Gf-Patterns
$ cp * /root/.gf 
```
# Thank You for your Contribution ...!!!
