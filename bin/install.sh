#!/bin/sh
MType=`uname`

echo "Append config .vimrc"
echo "source $HOME/.tools/env/.vimrc" >> $HOME/.vimrc

echo "Append config tools.sh"
echo "source $HOME/.tools/bin/tools.sh" >> $HOME/.bashrc

echo "Downloading... Vundle"
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "Install Vundle Plugins"
vim -c :PluginInstall -c :qa

if [ "$MType" != *"CYGWIN"* ]
then
pip install --user git+git://github.com/powerline/powerline

echo "export PATH+=:$HOME/.local/bin" >> $HOME/.bashrc
echo "powerline-daemon -q" >> $HOME/.bashrc
echo "source $HOME/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" >> $HOME/.bashrc
fi

if [ "$MType" != *"CYGWIN"* ]
then
    echo "Install YouCompleteMe"
    $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer
fi

if [ "$MType" == *"CYGWIN"* ]
then
    echo "Cygwin System"
    echo "Downloading... Global Win32 Version"
    mkdir -p $HOME/.tools/bin/global
    git clone https://github.com/jjangun/GLOBAL_Win32.git $HOME/.tools/bin/global
else
    echo "Install gnu global"
    global_version="global-6.6.3"
    global_archive=$global_version".tar.gz"
    global_down_url="http://ftp.gnu.org/gnu/global/"$global_archive

    mkdir -p $HOME/.tools/bin/global
    wget $global_down_url -P $HOME
    tar xvzf $global_archive -C $HOME

    cd $HOME/$global_version
    ./configure --prefix=$HOME/.tools/bin/global
    make
    make install

    cp $HOME/.tools/bin/global/share/gtags/gtags.conf $HOME/.globalrc

    echo "Remove install files"
    rm -rf $HOME/$global_archive
    rm -rf $HOME/$global_version
    echo "global install done"
    
    echo "Install fixpath"
    git clone https://github.com/xaljox/fixpath.git $HOME/.tools/fixpath
    cd $HOME/.tools/fixpath
    ./configure --prefix=$HOME/.tools
    make
    make install
    
    echo "Remove fixpath directory"
    rm -rf $HOME/.tools/fixpath
fi

echo "Completed!"
