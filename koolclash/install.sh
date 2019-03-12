#! /bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export koolclash)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

# 判断路由架构和平台
# Modified from koolss plugin (https://github.com/koolshare/ledesoft/blob/master/koolclash/koolss/install.sh)
case $(uname -m) in
armv7l)
    echo_date "KoolClash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，arm 平台尚未适配！！！"
    echo_date "退出安装！"
    exit 1
    ;;
mips)
    echo_date "KoolClash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，mips 平台尚未适配！！！"
    echo_date "退出安装！"
    exit 1
    ;;
x86_64)
    fw867=$(cat /etc/banner | grep fw867)
    if [ -d "/koolshare" ] && [ -n "$fw867" ]; then
        echo_date "固件平台【koolshare OpenWRT/LEDE x86_64】符合安装要求，开始安装插件！"
        rm -rf $KSROOT/bin/clash >/dev/null 2>&1
        rm -rf $KSROOT/bin/yq >/dev/null 2>&1
        cp -rf /tmp/koolclash/bin/clash-linux-amd64 $KSROOT/bin/clash
        cp -rf /tmp/koolclash/bin/yq_linux_amd64 $KSROOT/bin/yq
    else
        echo_date "KoolClash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，其它固件未做适配！！！"
        echo_date "退出安装！"
        exit 1
    fi
    ;;
*)
    echo_date "KoolClash 插件用于 koolshare OpenWRT/LEDE x86_64 固件平台，其它固件未做适配！！！"
    echo_date "退出安装！"
    exit 1
    ;;
esac

if [ -n "$(pidof clash)" ]; then
    # 停止 KoolClash
    echo_date '停止 KoolClash 以更新。注意更新完成以后 KoolClash 不会自动恢复，需要手动启动 Clash！'
    echo_date '【更新 KoolClash 过程中可能会出现「软件中心异常」的提示，是正常现象！】'
    echo_date '【请不要刷新或关闭页面，务必等待安装完成、页面自动跳转！】'
    sleep 2
    sh $KSROOT/scripts/koolclash_control.sh stop
fi

# 清理 旧文件夹
echo_date "KoolClash: 清理旧版文件..."
rm -rf $KSROOT/scripts/koolclash_* >/dev/null 2>&1
rm -rf $KSROOT/init.d/S99koolclash.sh >/dev/null 2>&1
rm -rf $KSROOT/webs/Module_koolclash.asp >/dev/null 2>&1
rm -rf $KSROOT/webs/res/icon-koolclash* >/dev/null 2>&1
rm -rf $KSROOT/webs/res/koolclash_* >/dev/null 2>&1
[ -f "/koolshare/webs/files/koolclash.tar.gz" ] && rm -rf /koolshare/webs/files/koolclash.tar.gz >/dev/null 2>&1

# 创建相关的文件夹
echo_date "KoolClash: 创建文件夹..."
mkdir -p $KSROOT/koolclash/config
mkdir -p $KSROOT/init.d

# 复制文件
cd /tmp

echo_date "KoolClash: 复制安装包内的文件到路由器..."

#cp -rf /tmp/koolclash/bin/* $KSROOT/bin/
cp -rf /tmp/koolclash/scripts/* $KSROOT/scripts/
cp -rf /tmp/koolclash/init.d/* $KSROOT/init.d/
cp -rf /tmp/koolclash/webs/* $KSROOT/webs/
cp -rf /tmp/koolclash/koolclash/config/Country.mmdb $KSROOT/koolclash/config/Country.mmdb
cp /tmp/koolclash/install.sh $KSROOT/scripts/koolclash_install.sh
cp /tmp/koolclash/uninstall.sh $KSROOT/scripts/uninstall_koolclash.sh
# 删除 Luci 缓存
rm -rf /tmp/luci-*

# 为新安装文件赋予执行权限...
echo_date "KoolClash: 设置可执行权限"
chmod 755 $KSROOT/bin/*
chmod 755 $KSROOT/scripts/koolclash_*
chmod 755 $KSROOT/init.d/S99koolclash.sh

local_version=$(cat $KSROOT/webs/res/koolclash_.version)
echo_date "KoolClash: 设置版本号为 $local_version..."
dbus set koolclash_version=$local_version

sleep 1

echo_date "KoolClash: 删除相关安装包..."
rm -rf /tmp/koolclash* >/dev/null 2>&1

echo_date "KoolClash: 设置一些安装信息..."

dbus set softcenter_module_koolclash_description="基于规则的代理程序 Clash"
dbus set softcenter_module_koolclash_install=1
dbus set softcenter_module_koolclash_name=koolclash
dbus set softcenter_module_koolclash_title=koolclash
dbus set softcenter_module_koolclash_version=$local_version

sleep 1
echo_date "KoolClash: 插件安装完成..."
