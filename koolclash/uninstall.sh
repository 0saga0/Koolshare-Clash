#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

sleep 1

rm -rf $KSROOT/koolclash
rm -rf $KSROOT/scripts/koolclash_*
rm -rf $KSROOT/init.d/S99koolclash.sh
rm -rf $KSROOT/bin/clash-*
rm -rf $KSROOT/webs/Module_koolclash.asp
rm -rf $KSROOT/webs/res/icon-koolclash*

rm -rf /tmp/luci-*

dbus remove softcenter_module_koolclash_description
dbus remove softcenter_module_koolclash_install
dbus remove softcenter_module_koolclash_name
dbus remove softcenter_module_koolclash_title
dbus remove softcenter_module_koolclash_version
