#!/vendor/bin/sh
#ifdef OPLUS_FEATURE_BT_EAP_LOG
#Wangguolong@CONNECTIVITY.BT.Basic.Feature.2531788 , 2021/11/10, Add for Open Bluetooth Uart Logs
tracefs=/sys/kernel/tracing
ssrdumpfs=/data/vendor/ssrdump
enable_debug()
{
    if [ -d $tracefs ]; then

        mkdir $tracefs/instances/hsuart
        #Add permission for user bluetooth
        chmod 0755 $tracefs/instances
        chmod 0755 $tracefs/instances/hsuart -R
        #UART
        echo 800 > $tracefs/instances/hsuart/buffer_size_kb
        echo 1 > $tracefs/instances/hsuart/events/serial/enable
        echo 1 > $tracefs/instances/hsuart/tracing_on
    fi
}

changeSsrFilePermission()
{
    if [ -d $ssrdumpfs ]; then

        #Add permission for user bluetooth
        chmod 0644 $ssrdumpfs/*
        setprop persist.vendor.bluetooth.ssrfile.chgperm "0"
    fi
}

disable_debug()
{
    if [ -d $tracefs/instances/hsuart ]; then
        echo 0 > $tracefs/instances/hsuart/events/serial/enable
        echo 0 > $tracefs/instances/hsuart/tracing_on
    fi
}

if [ "$(getprop persist.vendor.tracing.hsuart.enabled)" -eq "1" ]; then
    enable_debug
else
    disable_debug
fi

if [ "$(getprop persist.vendor.bluetooth.ssrfile.chgperm)" -eq "1" ]; then
    changeSsrFilePermission
else
    changeSsrFilePermission
fi

#endif OPLUS_FEATURE_BT_EAP_LOG
