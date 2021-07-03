#########################################################  rflib and wave300  download and compilation
## Linux 4.15.0-130-generic #134-Ubuntu SMP Tue Jan 5 20:46:26 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

cd ~

if ! [ -d wave300_rflib ] 
then
    git clone https://repo.or.cz/wave300_rflib.git
else    
    echo 'wave300_rflib directory found, skipping download'
fi

if ! [ -d wave300 ] 
then
    git clone https://github.com/garlett/wave300.git
else    
    echo 'wave300 directory found, skipping download and some config'
    make distclean
fi
cd wave300

if ! [ -d wireless/driver/rflib ]
then
    sed -i "s/cross\/openwrt5/$(whoami)\/openwrt/" support/ugw.env.common
    ln -s ~/wave300_rflib/wireless/driver/rflib/ wireless/driver/rflib
fi


export STAGING_DIR=~/openwrt/staging_dir/

#suleiman
echo 'CONFIG_LINDRV_HW_PCIE=y' >> .config
echo 'CONFIG_USE_INTERRUPT_POLLING=y' >> .config

make menuconfig

start_time="$(date -u +%s)"
make 
if [ $? == 0 ]
then
    echo " ***** after placing firmware files at /lib/firmware"
    echo " ***** copy and insmod in your router the following files:"
    ls -phlrs ~/wave300/builds/ugw5.4-vrx288/binaries/wls/driver/*.ko
fi

echo -e "\e[1;31m[build_openwrt] Total of $(($(date -u +%s)-$start_time)) seconds elapsed for compilation"
echo -e '\e[1;31m[build_openwrt]\e[0m Hit crtl+c to cancel alarm ...'
while [ 1 ]
do
    x=$( (speaker-test -t sine -f 1250 -l 1) & pid=$!; sleep 0.1s; kill -9 $pid )
    sleep 7s
done






