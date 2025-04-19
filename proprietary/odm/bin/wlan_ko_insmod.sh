#!/vendor/bin/sh
echo "oplus wlan try to insmod wlan ko again" > /dev/kmsg
rmmod qca_cld3_kiwi_v2
insmod vendor/lib/modules/qca_cld3_kiwi_v2.ko
