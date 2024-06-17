FROM centos:7.6.1810

# install develope tools
RUN yum update -y && \
    yum install -y git \
      gcc \
      cmake \
      make \
      openssl-devel \
      zlib-devel \
      epel-release \
      json-c-devel \
      wget \
      zsh \
      tmux

RUN yum install -y libuv-devel

# clone and compile libwebsockets
RUN git clone https://mirror.ghproxy.com/https://github.com/warmcat/libwebsockets.git && \
    cd libwebsockets && \
    git checkout v4.1-stable && \
    mkdir build && \
    cd build && \
    cmake .. -DLWS_WITH_LIBUV=ON && \
    make && \
    make install

# clone and compile ttyd
RUN git clone https://mirror.ghproxy.com/https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    git checkout 1.6.3 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# RUN yum install -y wget

# install golang
RUN cd /root && wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz && \
        tar zxvf go1.12.linux-amd64.tar.gz && \
        rm -rf go1.12.linux-amd64.tar.gz && mkdir /root/work
ENV GOROOT=/root/go GOPATH=/root/work PATH=$PATH:/root/go/bin:/root/work/bin

# install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.25.9/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl


# RUN cd /bin && wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
#       tar zxvf nvim-linux64.tar.gz && cp /bin/nvim-linux64/bin/nvim /bin/nvim-linux64/bin/vim && ls /bin/nvim-linux64/bin/vim
# ENV PATH=$PATH:/bin/nvim-linux64/bin

RUN  yum install -y  ncurses-devel ruby ruby-devel lua lua-devel luajit \
        luajit-devel ctags git python python-devel \
        python3 python3-devel tcl-devel \
        perl perl-devel perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed  \
        gcc-c++ cmake make  && \
        wget https://github.com/vim/vim/archive/v8.1.0994.tar.gz && \
        tar zxvf v8.1.0994.tar.gz  && cd vim-8.1.0994/src && \
        ./configure --with-features=huge \
            --enable-multibyte \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/lib64/python2.7/config \
            --enable-python3interp=yes \
            --with-python3-config-dir=/lib64/python3.5/config \
            --enable-gui=gtk2 \
            --enable-cscope \
           --prefix=/usr/local \
         && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81  && make install
RUN update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 && \
     update-alternatives --set editor /usr/local/bin/vim
ENV PATH=$PATH:/usr/local/bin

# install vim and vim plugins
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim  && go get github.com/golang/lint || true

# RUN vim +PluginInstall +qall -e || true && \
#       && git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe \
#       && cd ~/.vim/bundle/YouCompleteMe && \
#        ./install.py --clangd-completer --go-completer --ts-completer

# install helm
RUN wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz \
    && tar -zxvf helm-v3.7.1-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 helm-v3.7.1-linux-amd64.tar.gz

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# vim +PluginInstall +qall && vim +GoInstallBinaries &&
# or using ttyd -p 8080 bash
# or using ttyd -p 8080 zsh
CMD ["ttyd", "-p", "8080", "zsh"]
