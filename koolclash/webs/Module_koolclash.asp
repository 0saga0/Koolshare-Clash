<title>KoolShare Clash 插件</title>
<content>
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script type="text/javascript" src="/js/tomato.js"></script>
    <script type="text/javascript" src="/js/advancedtomato.js"></script>
    <script type="text/javascript" src="/layer/layer.js"></script>
    <style type="text/css">
        .box,
        #clash_tabs {
            min-width: 720px;
        }

        .koolclash-divider {
            content: '|';
            margin: 0 5px;
        }

        .koolclash-btn-container {
            padding: 4px;
            padding-left: 8px;
        }
    </style>
    <div class="box">
        <div class="heading">
            <a style="padding-left: 0" href="https://github.com/SukkaW/Koolshare-Clash" target="_blank">KoolClash</a>
            <a href="#/soft-center.asp" class="btn" style="float:right; border-radius:3px; margin-right:5px; margin-top:0px;">返回</a>
            <!--<a href="https://github.com/koolshare/ledesoft/blob/master/v2ray/Changelog.txt" target="_blank"
                class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">更新日志</a>-->
            <!--<button type="button" id="updateBtn" onclick="check_update()" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">检查更新 <i class="icon-upgrade"></i></button>-->
        </div>
        <div class="content">
            <div class="col" style="line-height:30px;">
                <p>Clash 是一个基于规则的代理程序，兼容 Shadowsocks、V2Ray 等协议，拥有像 Surge 一样强大的代理规则。</p>
                <p>KoolClash 是 Clash 在 Koolshare OpenWrt 上的客户端</p>

                <p style="margin-top: 10px"><a href="https://github.com/Dreamacro/clash">Clash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/SukkaW/Koolshare-Clash" target="_blank">KoolClash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://koolclash.skk.moe" target="_blank">KoolClash 使用文档</a></p>
            </div>
        </div>
    </div>

    <div class="box">
        <div class="heading" style="color: red">
            ！！请注意！！
            <br>
            以下内容务必仔细阅读！
        </div>
        <div class="content">
            <div class="col" style="line-height:30px; color: brown">
                <p>KoolClash 插件将会修改 Clash Config 文件中的部分设置（如代理端口、透明代理端口、外部控制端口等）。如果你正在购买并使用商业性质的公共代理服务，请务必先仔细阅读相关服务商的 服务条款与条件（ToS）。部分公共代理服务商（如 rixCloud）的服务条款与条件规定，如果用户更改了服务商提供的托管配置将会被视为自动放弃 SLA 和技术支持服务。</p>
                <p>如果你使用的公共代理服务提供商有诸如此类的限制性条款（如 rixCloud），我会耸耸肩、然后表示很遗憾。你应该向你正在使用的公共代理服务提供商提交技术支持请求，并在支持请求中附上 <a href="https://graph.org/%E5%85%B3%E4%BA%8E-KoolClash-%E6%8F%92%E4%BB%B6-02-11" target="_blank">这篇文章</a> 的链接，询问使用本插件是否违背了他们的条款和条件。然后由您自行做出选择是否继续使用本插件。</p>
            </div>
        </div>
    </div>

    <div class="box">
        <div class="heading">KoolClash 配置</div>

        <div class="content">

            <!-- ### KoolClash 运行状态 ### -->
            <div id="koolclash-field"></div>

            <!-- ### KoolClash 运行配置设置 ### -->
            <div id="koolclash-config"></div>
            <div class="koolclash-btn-container">
                <button type="button" id="koolclash-btn-save-config" onclick="saveRemoteConfigUrl()" class="btn btn-primary">提交 Clash 托管配置 URL</button>
            </div>
            <div class="koolclash-btn-container">
                <button type="button" id="koolclash-btn-save-config" onclick="updateRemoteConfig()" class="btn btn-primary">更新 Clash 托管配置</button>
                <small>该操作将重新下载 Clash 托管配置、并生效 Clash 运行配置</small>
            </div>
        </div>
    </div>

    <script>
        let KoolClash = {
            defaultConfig: `
port: 8888
socks-port: 8889
redir-port: 23456
allow-lan: true
mode: Rule
log-level: info
external-controller: '0.0.0.0:6170'
dns:
  enable: true
  listen: 0.0.0.0:53
  enhanced-mode: redir-host
  nameserver:
    - 119.29.29.29
    - 223.5.5.5
    - tls://dns.rubyfish.cn:853
  fallback:
    - tls://dns.google
    - tls://1dot1dot1dot1.cloudflare-dns.com
`,
        };




        $('#koolclash-field').forms([
            {
                title: '<b>KoolClash 开关</b>',
                name: 'koolclash-enable',
                type: 'checkbox',
                value: 1 //((Clash.status_enable) ? 1 : 0)
            },
            {
                title: '<b>Clash 运行状态</b>',
                text: '<span id="_koolclash_status" name="koolclash_status" color="#1bbf35">正在获取 Clash 进程状态...</span>'
            },
            {
                title: '&nbsp;',
                text: '<p>查看代理运行状态请访问 <a href="https://ip.skk.moe/?from=koolclash_plugin" target="_blank">IP.SKK.MOE</a> 查看自己的 IP</p>'
            },
            {
                title: '<b>Clash 面板</b>',
                text: '<p>请使用 Chrome 浏览器访问 <a href="https://clashx.skk.moe" target="_blank">Clash Dashboard</a></p>'
            },
        ]);

        $('#koolclash-field').forms([
            {
                title: '<b>KoolClash 托管配置 URL</b>',
                name: 'koolclash-remote-config-url',
                type: 'text',
                value: 'https://example.com/clash', // Clash.remote_config_url || '';
                style: `width:100%`,
                placeholder: 'https://example.com/clash'
            }
        ]);

        $('#koolclash-config').forms([
            {
                title: '<b>Clash 运行配置</b>',
                name: 'koolclash-config-headeer',
                type: 'textarea',
                value: Base64.decode(dbus.ss_isp_website_web) || KoolClash.defaultConfig,
                style: 'width: 100%; height: 300px;'
            },
        ]);
    </script>
    <div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
    <div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
    <div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
</content>
