#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export clash)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

# 判断路由架构和平台
# Modified from koolss plugin (https://github.com/koolshare/ledesoft/blob/master/koolclash/koolss/install.sh)
case $(uname -m) in
armv7l)
    logger "本 Clash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，arm 平台尚未适配！！！"
    logger "退出安装！"
    exit 1
    ;;
mips)
    logger "本 Clash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，mips 平台尚未适配！！！"
    logger "退出安装！"
    exit 1
    ;;
x86_64)
    fw867=$(cat /etc/banner | grep fw867)
    if [ -d "/koolshare" ] && [ -n "$fw867" ]; then
        logger "固件平台【koolshare OpenWRT/LEDE x86_64】符合安装要求，开始安装插件！"
    else
        logger "本 Clash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，其它固件未做适配！！！"
        logger "退出安装！"
        exit 1
    fi
    ;;
*)
    logger "本 Clash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，其它固件未做适配！！！"
    logger "退出安装！"
    exit 1
    ;;
esac

# 创建相关的文件夹
logger "KoolClash: 创建文件夹..."
mkdir -p $KSROOT/koolclash
mkdir -p $KSROOT/init.d

# 停止 KoolClash

# 清理 旧文件夹

# 复制文件
cd /tmp

logger "KoolClash: 复制安装包内的文件到路由器..."

cp -rf /tmp/koolclash/bin/* $KSROOT/bin/
cp -rf /tmp/koolclash/koolclash/* $KSROOT/koolclash/
cp -rf /tmp/koolclash/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolclash/init.d/* $KSROOT/init.d/
cp -rf /tmp/koolclash/webs/* $KSROOT/webs/
cp /tmp/koolclash/install.sh $KSROOT/scripts/koolclash_install.sh
cp /tmp/koolclash/uninstall.sh $KSROOT/scripts/uninstall_koolclash.sh
# 删除 Luci 缓存
rm -rf /tmp/luci-*

# 为新安装文件赋予执行权限...
logger "KoolClash: 设置可执行权限"
chmod 755 $KSROOT/bin/*

local_version=$(cat $KSROOT/koolclash/version)
logger "KoolClash: 设置版本号为 $local_version..."
dbus set clash_version=$local_version

sleep 2

logger "KoolClash: 删除相关安装包..."
rm -rf /tmp/koolclash* >/dev/null 2>&1

logger "KoolClash: 设置一些安装信息..."

dbus set softcenter_module_koolclash_description="基于规则的代理程序 Clash"
dbus set softcenter_module_koolclash_install=1
dbus set softcenter_module_koolclash_name=koolclash
dbus set softcenter_module_koolclash_title=koolclash
dbus set softcenter_module_koolclash_version=$local_version

sleep 1
logger "KoolClash: 插件安装完成..."
