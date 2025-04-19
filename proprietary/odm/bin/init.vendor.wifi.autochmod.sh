#!/vendor/bin/sh
#***********************************************************
#** Copyright (C), 2019-2029, OPLUS Mobile Comm Corp., Ltd
#** All rights reserved.
#**
#** File: - vendor.wifi.autochmod.sh
#** Description: vendor domain operation
#**
#** Version: 1.1
#** Date : 2020/02/20
#** Author: JiaoBo
#** TAG: CONNECTIVITY.WIFI.BASIC.HARDWARE
#** ---------------------Revision History: ---------------------
#**  <author>    <data>       <version >       <desc>
#**  Jiao.Bo       2020/02/20     1.0     build this module
#****************************************************************/

config="$1"


#ifdef OPLUS_FEATURE_WIFI_RUSUPGRADE
#JiaoBo@CONNECTIVITY.WIFI.BASIC.HARDWARE.2795386, 2020/02/20
#add for: support auto update function, include mtk fw, mtk wifi.cfg, qcom fw, qcom bdf, qcom ini
#common info
defaultVersion="20190101000000"
nullVersion="null"
rusEntityConfigXmlfile=/odm/etc/vendor_wifi_rus_config.xml
isConfigXmlParseDone="false"
#mtk platform info
mtkWifirusEntityVersionList="null;null;null;null;null"
mtkWifirusEntityTypeList=("wifi.cfg" "wifi.fw" "wifi.nv")
mtkWifirusEntityVersionFileNameList=(
"wifi.cfg"
"WIFI_RAM_CODE_soc2_0_3a_1.bin"
"WIFI")
mtkWifirusEntityFileNameList=(
"wifi.cfg"
"WIFI_RAM_CODE_soc2_0_3a_1.bin;soc2_0_ram_wifi_3a_1_hdr.bin;soc2_0_ram_bt_3a_1_hdr.bin;soc2_0_ram_mcu_3a_1_hdr.bin;soc2_0_patch_mcu_3a_1_hdr.bin"
"WIFI")
mtkWifirusEntityVendorPathList=(
"/vendor/firmware/"
"/vendor/firmware/"
"/vendor/firmware/")
#qcom paltform info
qcomWifirusEntityVersionList="null;null;null"
qcomWifirusEntityTypeList=("wifi.ini" "wifi.fw" "wifi.bdf")
qcomWifirusEntityVersionFileNameList=(
"WCNSS_qcom_cfg.ini"
"wlandsp.mbn"
"bin_version")
qcomWifirusEntityFileNameList=(
"WCNSS_qcom_cfg.ini"
"wlandsp.mbn"
"bin_version;bdwlan.bin")
qcomWifirusEntityVendorPathList=(
"/vendor/firmware_mnt/"
"/vendor/firmware_mnt/"
"/vendor/firmware_mnt/")

#function: get the entity type index
function getrusEntityTypeIdx() {
    local platform=$1
    local type=$2
    if [ "$platform" = "mtk" ]; then
        if [ "$type" = "wifi.cfg" ]; then
            return 0
        elif [ "$type" = "wifi.fw" ]; then
            return 1
        elif [ "$type" = "wifi.nv" ]; then
            return 2
        fi
    elif [ "$platform" = "qcom" ]; then
        if [ "$type" = "wifi.ini" ]; then
            return 0
        elif [ "$type" = "wifi.fw" ]; then
            return 1
        elif [ "$type" = "wifi.bdf" ]; then
            return 2
        fi
    fi
    return 0
}

#function: get the vendor suppprt Entity file name which include version information
function parseSupportrusEntityConfigXml() {
    local board=`getprop ro.board.platform`
    if [ "$isConfigXmlParseDone" = "false" ]; then
        local cmd=`sed -n -e 's/<Entity //' -e 's/\/>//p' $rusEntityConfigXmlfile | sed -e 's/platform="//' -e 's/type="//' -e 's/versionFileName="//' -e 's/fileNameList="//' -e 's/"//g'`
        execute=($(echo $cmd))
        local length=${#execute[*]}
        local i=0
        while [ i -lt length ]
        do
            local platform=${execute[i]}
            local type=${execute[++i]}
            local versionFileName=${execute[++i]}
            local fileNameList=${execute[++i]}
            local typeIdx
            if [[ $board == *"mt"* ]] || [[ $board == *"Mt"*  ]] || [[ $board == *"MT"*  ]];then
                getrusEntityTypeIdx "mtk" $type
                typeIdx=$?
                if [ "$platform" = "$board" ]; then
                    mtkWifirusEntityVersionFileNameList[typeIdx]=$versionFileName
                    mtkWifirusEntityFileNameList[typeIdx]=$fileNameList
                    echo "index=$i Entity$typeIdx: platform:$platform type:$type"
                    echo "         versionFileName:${mtkWifirusEntityVersionFileNameList[typeIdx]}"
                    echo "         fileNameList:${mtkWifirusEntityFileNameList[typeIdx]}"
                fi
            else
                getrusEntityTypeIdx "qcom" $type
                typeIdx=$?
                if [ "$platform" = "$board" ]; then
                    qcomWifirusEntityVersionFileNameList[typeIdx]=$versionFileName
                    qcomWifirusEntityFileNameList[typeIdx]=$fileNameList
                    echo "index=$i Entity$typeIdx: platform:$platform type:$type"
                    echo "         versionFileName:${qcomWifirusEntityVersionFileNameList[typeIdx]}"
                    echo "         fileNameList:${qcomWifirusEntityFileNameList[typeIdx]}"
                fi
            fi
            i=$((i+1))
        done
        isConfigXmlParseDone="true"
    else
        echo "already parse done."
    fi
}

#function: get all vendor suppprt Entity version for mtk
function rusMtkWifiObjsVendorVerGet() {
    parseSupportrusEntityConfigXml
    mtkWifirusEntityVersionList=""
    local length=${#mtkWifirusEntityTypeList[@]}
    local i=0
    while [ i -lt length ]
    do
        local type=${mtkWifirusEntityTypeList[i]}
        local file=${mtkWifirusEntityVendorPathList[i]}${mtkWifirusEntityVersionFileNameList[i]}
        if [ -f $file ]; then
            if [ "$type" = "wifi.cfg" ]; then
                str=`head -c 25 $file`
                version=${str:9:14}
            elif [ "$type" = "wifi.fw" ]; then
                str=`tail -c 19 $file`
                version=${str:0:14}
            elif [ "$type" = "wifi.nv" ]; then
                #default not support update this entity
                version=$nullVersion
            else
                version=$nullVersion
            fi
        else
            version=$nullVersion
        fi
        mtkWifirusEntityVersionList+=$version";"
        i=$((i+1))
    done
    mtkWifirusEntityVersionList=${mtkWifirusEntityVersionList%;*}
    echo "mtkWifirusEntityVersionList=$mtkWifirusEntityVersionList"
}

#function: get all vendor suppprt Entity version for qcom
function rusQcomWifiObjsVendorVerGet() {
    parseSupportrusEntityConfigXml
    qcomWifirusEntityVersionList=""
    local length=${#qcomWifirusEntityTypeList[@]}
    local i=0
    while [ i -lt length ]
    do
        local type=${qcomWifirusEntityTypeList[i]}
        local file=${qcomWifirusEntityVendorPathList[i]}${qcomWifirusEntityVersionFileNameList[i]}
        if [ -f $file ]; then
            if [ "$type" = "wifi.ini" ]; then
                #default not support update this entity
                version=$nullVersion
            elif [ "$type" = "wifi.fw" ]; then
                #default not support update this entity
                version=$nullVersion
            elif [ "$type" = "wifi.bdf" ]; then
                #default not support update this entity
                version=$nullVersion
            else
                version=$nullVersion
            fi
        else
            version=$nullVersion
        fi
        qcomWifirusEntityVersionList+=$version";"
        i=$((i+1))
    done
    qcomWifirusEntityVersionList=${qcomWifirusEntityVersionList%;*}
    echo "qcomWifirusEntityVersionList=$qcomWifirusEntityVersionList"
}

#function: set the versionlist to attribute when bootup
function rusWifiVendorVerBootCheck() {
    local platform
    local board=`getprop ro.board.platform`
    if [[ $board == *"mt"* ]] || [[ $board == *"Mt"*  ]] || [[ $board == *"MT"*  ]];then
        platform="mtk"
    else
        platform="qcom"
    fi

    if [ "$platform" = "mtk" ]; then
        rusMtkWifiObjsVendorVerGet
        setprop vendor.oppo.wifi.rus.version $mtkWifirusEntityVersionList
    elif [ "$platform" = "qcom" ]; then
        rusQcomWifiObjsVendorVerGet
        setprop vendor.oppo.wifi.rus.version $qcomWifirusEntityVersionList
    fi
    setprop vendor.oppo.wifi.rus.upgrade.ctl "vendor-bootcheck-done"
}

#function: set the versionlist to attribute when rus upgrade
function rusWifiVendorVerUpgradeCheck() {
    local platform
    local board=`getprop ro.board.platform`
    if [[ $board == *"mt"* ]] || [[ $board == *"Mt"*  ]] || [[ $board == *"MT"*  ]];then
        platform="mtk"
    else
        platform="qcom"
    fi
    echo "rusWifiVendorVerUpgradeCheck platform=$platform"

    if [ "$platform" = "mtk" ]; then
        rusMtkWifiObjsVendorVerGet
        setprop vendor.oppo.wifi.rus.version $mtkWifirusEntityVersionList
    elif [ "$platform" = "qcom" ]; then
        rusQcomWifiObjsVendorVerGet
        setprop vendor.oppo.wifi.rus.version $qcomWifirusEntityVersionList
    fi
    setprop vendor.oppo.wifi.rus.upgrade.ctl "vendor-upgradeCheck-done"
}
#endif /* OPLUS_FEATURE_WIFI_RUSUPGRADE */

#ifdef OPLUS_FEATURE_WIFI_DUMP
#JiaoBo@CONNECTIVITY.WIFI.BASIC.LOG.1162003, 2018/7/02
#add for wifi dump related log collection and DCS handle, dynamic enable/disable wifi core dump, offer trigger wifi dump API.
QCOM_DUMP_PATH="/data/vendor/tombstones/rfs/modem/*"
QCOM_KONA_DUMP_PATH="/data/vendor/ramdump/ramdump_wlan*"
MTK_DUMP_PATH="/data/vendor/connsyslog/wifi/*"
function clearWifiDumpFile() {
    local platform=`getprop ro.board.platform`
    if [[ $platform == *"mt"* ]] || [[ $platform == *"Mt"*  ]] || [[ $platform == *"MT"*  ]];then
        rm -rf $MTK_DUMP_PATH
    else
        if [ "x${platform}" == "xkona" ];then
            rm -rf $QCOM_KONA_DUMP_PATH
        else
            rm -rf $QCOM_DUMP_PATH
        fi
    fi
}

# suppot: 1. qcom minidump; 2. mtk soc3 coredump; 3. mtk soc2 coredump
function triggerwifidump() {
    platform=`getprop ro.board.platform`
    if [[ $platform == *"mt"* ]] || [[ $platform == *"Mt"*  ]] || [[ $platform == *"MT"*  ]];then
        echo "mtk trigger firmware assert"
        if ["$platform" = 'mt6779'] || ["$platform" = 'mt6853'] || ["$platform" = 'mt6873'] || ["$platform" = 'mt6771'] ; then
            echo DB9DB9 > /proc/driver/wmt_dbg
            echo 4 0 > /proc/driver/wmt_dbg
        elif ["$platform" = 'mt6885'] || ["$platform" = 'mt6889']; then
            /odm/bin/iwpriv_vendor wlan0 driver 'SET_WFSYS_RESET'
        else
            echo "unsupport platform."
        fi
    else
        echo "qcom trigger firmware assert"
        if [ "x${platform}" == "xlahaina" -o "x${platform}" == "xtaro" -o "x${platform}" == "xblair" ];then
            /odm/bin/iwpriv wlan0 setUnitTestCmd 19 1 4
        elif [ "x$platform" == "xpineapple" ] || [ "x$platform" == "xsun" ] || [ "x$platform" == "xvolcano" ]; then
            echo 1 1 > /sys/class/net/wlan0/crash_inject
        else
            /odm/bin/iwpriv wlan0 crash_inject 1 0
        fi
    fi
}
#endif /* OPLUS_FEATURE_WIFI_DUMP */

#ifdef OPLUS_WIFI_POWER_DYNAMIC_PCIE_GEN_SWITCH
function pcie_switch_to_normal_speed() {
    echo "oplus wiif pci switch to normal" > /dev/kmsg
    echo 19 3 45 2 2 > /sys/class/net/wlan0/unit_test_target
}

function pcie_switch_to_high_speed() {
    echo "oplus wiif pci switch to high" > /dev/kmsg
    echo 19 3 45 3 2 > /sys/class/net/wlan0/unit_test_target
}
#endif OPLUS_WIFI_POWER_DYNAMIC_PCIE_GEN_SWITCH

#ifdef OPLUS_FEATURE_WIFI_LOG
#YuanZhiqiang@CONNECTIVITY.WIFI.HARDWARE.LOG.5916929,2023/07/18, Add for enable QCOM wifi BTC log
function enablebtclog() {
    echo "qcom enable wifi btc log"
    local iwpriv_support=`/odm/bin/iwpriv wlan0`
    if [ -z "$iwpriv_support" ]; then
        echo "not support iwpriv"
        echo 4 2 11 1 > /sys/class/net/wlan0/unit_test_target
        echo 4 2 12 1 > /sys/class/net/wlan0/unit_test_target
    else
        echo "support iwpriv"
        odm/bin/iwpriv wlan0 setUnitTestCmd 4 2 11 1
        odm/bin/iwpriv wlan0 setUnitTestCmd 4 2 12 1
    fi
}

function disablebtclog() {
    echo "qcom disable wifi btc log"
    local iwpriv_support=`/odm/bin/iwpriv wlan0`
    if [ -z "$iwpriv_support" ]; then
        echo "not support iwpriv"
        echo 4 2 11 0 > /sys/class/net/wlan0/unit_test_target
        echo 4 2 12 0 > /sys/class/net/wlan0/unit_test_target
    else
        echo "support iwpriv"
        odm/bin/iwpriv wlan0 setUnitTestCmd 4 2 11 0
        odm/bin/iwpriv wlan0 setUnitTestCmd 4 2 12 0
    fi
}
#endif /* OPLUS_FEATURE_WIFI_LOG */

#CaoShifeng@CONNECTIVITY.WIFI.HARDWARE.7129504,2024/06/17, Add for enable QCOM wifi fixrate
function enablefixrate() {
    local rate=`getprop vendor.wifi.max_tx_rate.value`
    echo 10 2 87 ${rate} > /sys/class/net/wlan0/unit_test_target
}

function disablefixrate() {
    echo 10 2 87 0 > /sys/class/net/wlan0/unit_test_target
}

#ifdef OPLUS_FEATURE_WLAN_LOW_LATENCY
#YangJiang@CONNECTIVITY.WIFI.NETWORK.7158651,2024/05/15, Add for Media Boost LLM
function disableRAControlInULLMode() {
    local iwpriv_support=`/odm/bin/iwpriv wlan0`
    if [ -z "$iwpriv_support" ]; then
        echo 10 8 35 50 8 37 150 100 400 3 > /sys/class/net/wlan0/unit_test_target
    else
        echo "support iwpriv"
        odm/bin/iwpriv wlan0 setUnitTestCmd 10 8 35 50 8 37 150 100 400 3
    fi
}

function enableRAControlInULLMode() {
    local iwpriv_support=`/odm/bin/iwpriv wlan0`
    if [ -z "$iwpriv_support" ]; then
        echo 10 8 35 30 4 75 300 200 800 2 > /sys/class/net/wlan0/unit_test_target
    else
        echo "support iwpriv"
        odm/bin/iwpriv wlan0 setUnitTestCmd 10 8 35 30 4 75 300 200 800 2
    fi
}
#endif /* OPLUS_FEATURE_WLAN_LOW_LATENCY */

function wifiFixedTxpower() {
    local txpower=`getprop vendor.wifi.fixed.txpower`
    echo "oplus wifiFixedTxpower ${txpower}" > /dev/kmsg
    echo 67 4 88 1 0 ${txpower} > /sys/class/net/wlan0/unit_test_target
    echo 67 4 88 1 1 ${txpower} > /sys/class/net/wlan0/unit_test_target
    echo 0x48 2 1 6 > /sys/class/net/wlan0/unit_test_target
}

#ifdef OPLUS_FEATURE_WIFI_BEAM_SWITCH
#YangJiang@CONNECTIVITY.WIFI.NETWORK.8255777, 2024/9/12, add for beam switch
function setBeamSwitchGPIOHigh() {
    echo `vendor_cmd_tool -f /vendor/etc/wifi/vendor_cmd.xml -i wlan0 --START_CMD --GPIO_CONFIG --GPIO_COMMAND 1 --GPIO_PINNUM 71 --GPIO_VALUE 1 --END_CMD`
}

function setBeamSwitchGPIOLow() {
    echo `vendor_cmd_tool -f /vendor/etc/wifi/vendor_cmd.xml -i wlan0 --START_CMD --GPIO_CONFIG --GPIO_COMMAND 1 --GPIO_PINNUM 71 --GPIO_VALUE 0 --END_CMD`
}
#endif /* OPLUS_FEATURE_WIFI_BEAM_SWITCH */

case "$config" in
    #ifdef OPLUS_FEATURE_WIFI_DUMP
    #JiaoBo@CONNECTIVITY.WIFI.BASIC.LOG.1162003, 2018/7/02
    #add for wifi dump related log collection and DCS handle, dynamic enable/disable wifi core dump, offer trigger wifi dump API.
    "clearWifiDumpFile")
    clearWifiDumpFile
    ;;
    "triggerwifidump")
    triggerwifidump
    ;;
    #endif /* OPLUS_FEATURE_WIFI_DUMP */
    #ifdef OPLUS_FEATURE_WIFI_RUSUPGRADE
    #JiaoBo@CONNECTIVITY.WIFI.BASIC.HARDWARE.2795386, 2020/02/20
    #add for: support auto update function, include mtk fw, mtk wifi.cfg, qcom fw, qcom bdf, qcom ini
    "rusWifiVendorVerBootCheck")
    rusWifiVendorVerBootCheck
    ;;
    "rusWifiVendorVerUpgradeCheck")
    rusWifiVendorVerUpgradeCheck
    ;;
    #endif /* OPLUS_FEATURE_WIFI_RUSUPGRADE */
    #ifdef OPLUS_WIFI_POWER_DYNAMIC_PCIE_GEN_SWITCH
    #fangbinghua@CONNECTIVITY.WIFI.HARDWARE.POWER, 2024/0/02, add for pcie gen switch
    "pcie_switch_to_normal_speed")
    pcie_switch_to_normal_speed
    ;;
    "pcie_switch_to_high_speed")
    pcie_switch_to_high_speed
    ;;
    #endif OPLUS_WIFI_POWER_DYNAMIC_PCIE_GEN_SWITCH
    #ifdef OPLUS_FEATURE_WIFI_LOG
    #YuanZhiqiang@CONNECTIVITY.WIFI.HARDWARE.LOG.5916929,2023/07/18, Add for enable QCOM wifi BTC log
    "enablebtclog")
    enablebtclog
    ;;
    "disablebtclog")
    disablebtclog
    ;;
    #endif /* OPLUS_FEATURE_WIFI_LOG */
    #CaoShifeng@CONNECTIVITY.WIFI.HARDWARE.7129504,2024/06/17, Add for enable QCOM wifi fixrate
    "enablefixrate")
    enablefixrate
    ;;
    "disablefixrate")
    disablefixrate
    ;;
    #ifdef OPLUS_FEATURE_WLAN_LOW_LATENCY
    #YangJiang@CONNECTIVITY.WIFI.NETWORK.7158651,2024/05/15, Add for Media Boost LLM
    "disableRAControlInULLMode")
    disableRAControlInULLMode
    ;;
    "enableRAControlInULLMode")
    enableRAControlInULLMode
    ;;
    #endif /* OPLUS_FEATURE_WLAN_LOW_LATENCY */
    "wifiFixedTxpower")
    wifiFixedTxpower
    ;;
    #ifdef OPLUS_FEATURE_WIFI_BEAM_SWITCH
    #YangJiang@CONNECTIVITY.WIFI.NETWORK.8255777, 2024/9/12, add for beam switch
    "setBeamSwitchGPIOHigh")
    setBeamSwitchGPIOHigh
    ;;
    "setBeamSwitchGPIOLow")
    setBeamSwitchGPIOLow
    ;;
    #endif /* OPLUS_FEATURE_WIFI_BEAM_SWITCH */
esac
