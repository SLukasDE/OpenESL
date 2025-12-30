# install CMake 3.30

Instruction:

```bash
wget https://cmake.org/files/v3.30/cmake-3.30.9.tar.gz
tar zxvf cmake-3.30.9.tar.gz
cd cmake-3.30.9
./bootstrap --prefix=/usr/local
make -j$(nproc)
make install
cmake --version
```

# function(find_package_gmp)

```bash
wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
tar xf gmp-6.3.0.tar.xz
cd gmp-6.3.0
./configure --prefix=/usr
make
make install
```

# function(find_package_nettle)

```bash
wget https://ftp.gnu.org/gnu/nettle/nettle-3.6.tar.gz
tar zxvf nettle-3.6.tar.gz
cd nettle-3.6
./configure --prefix=/usr --disable-static
make
make install
```
