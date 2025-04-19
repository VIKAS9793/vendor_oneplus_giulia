#! /vendor/bin/sh

config="$1"

function lowram_device_setup()
{
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    Heapminfree=4m
    Heapmaxfree=32m
    Heapstartsize=16m
    Heapsize=512m
    Heapgrowthlimit=256m
    Heaptargetutilization=0.5

    if [ $MemTotal -lt 9437184 ]; then
       Heapminfree=2m
       Heapmaxfree=16m
       Heapstartsize=16m
       Heapsize=512m
       Heapgrowthlimit=384m
       Heaptargetutilization=0.75
    fi

    setprop vendor.oplus.dalvik.vm.heapminfree $Heapminfree
    setprop vendor.oplus.dalvik.vm.heapmaxfree $Heapmaxfree
    setprop vendor.oplus.dalvik.vm.heapstartsize $Heapstartsize
    setprop vendor.oplus.dalvik.vm.heapsize $Heapsize
    setprop vendor.oplus.dalvik.vm.heapgrowthlimit $Heapgrowthlimit
    setprop vendor.oplus.dalvik.vm.heaptargetutilization $Heaptargetutilization
    setprop ro.vendor.config.oplus.low_ram false
}

case "$config" in
    "lowram_device_setup")
        lowram_device_setup
    ;;
       *)

      ;;
esac
