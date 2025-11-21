wget https://github.com/cli/cli/releases/download/v2.83.1/gh_2.83.1_linux_amd64.tar.gz
tar -xvf gh_2.83.1_linux_amd64.tar.gz
mv gh_2.83.1_linux_amd64/bin/gh ~/bin/

# Add the PATH to the ~/.bashrc file
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc