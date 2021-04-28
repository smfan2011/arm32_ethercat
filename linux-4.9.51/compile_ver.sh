#compile kernel

echo "[1] Kernel Compiling....."
cd ./
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage  -j 4
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules -j 4
#install into sd card
sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=/media/fsm/rootfs
sudo cp -rf arch/arm/boot/zImage /media/fsm/rootfs/boot/

sleep 10s

echo "[2] Kernel Complete!!!"
echo -e "\n"

#compile eth
echo "[3] Ethercat Compiling....."
cd ../ethercat-1.5.2
./configure --prefix=/media/fsm/rootfs/ --with-linux-dir=$(pwd)/../linux-4.9.51 --enable-8139too=no --enable-generic=yes CC=arm-linux-gnueabihf-gcc --host=arm-linux-gnueabihf
make && make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules
sudo make install
sudo cp master/ec_master.ko  /media/fsm/rootfs/lib/modules/4.9.51-v1.5
sudo cp devices/ec_generic.ko  /media/fsm/rootfs/lib/modules/4.9.51-v1.5
sudo cp examples/dc_user/.libs/ec_dc_user_example /media/fsm/rootfs/opt/

sleep 10s

echo "[4] Ethercat Complete!!!"

sudo sed -i "s/^MASTER0_DEVICE=.*/MASTER0_DEVICE=\"68:47:49:7C:F2:EE\"/" /media/fsm/rootfs/etc/sysconfig/ethercat
