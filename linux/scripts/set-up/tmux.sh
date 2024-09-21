# from https://stackoverflow.com/questions/21926202/libevent-not-found-error-in-tmux
sudo apt install libevent-dev bison ncurses-dev

# from https://github.com/tmux/tmux/wiki/Installing
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make && sudo make install
