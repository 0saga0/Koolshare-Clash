<title>KoolClash - Clash for Koolshare OpenWrt/LEDE</title>
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

        hr {
            opacity: 1;
            border: 1px solid #ddd;
            margin: 1rem 0;
        }

        #koolclash-ip .ip-title {
            font-weight: bold;
            color: #444;
        }

        #koolclash-ip .sk-text-success {
            color: #32b643
        }

        #koolclash-ip .sk-text-error {
            color: #e85600
        }

        #koolclash-ip p {
            margin: 2px 0;
        }

    </style>
    <div class="box">
        <div class="heading">
            <a style="padding-left: 0; color: #0099FF; font-size: 20px;" href="https://koolclash.js.org" target="_blank">KoolClash</a>
            <a href="#/soft-center.asp" class="btn" style="float: right; margin-right: 5px; border-radius:3px; margin-top: 0px;">返回</a>
            <!--<a href="https://github.com/koolshare/ledesoft/blob/master/v2ray/Changelog.txt" target="_blank"
                class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">更新日志</a>-->
            <!--<button type="button" id="updateBtn" onclick="check_update()" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">检查更新 <i class="icon-upgrade"></i></button>-->
        </div>
        <div class="content">
            <div class="col" style="line-height:30px;">
                <p>Clash 是一个基于规则的代理程序，兼容 Shadowsocks、V2Ray 等协议，拥有像 Surge 一样强大的代理规则。</p>
                <p>KoolClash 是 Clash 在 Koolshare OpenWrt 上的客户端</p>

                <p style="margin-top: 10px"><a href="https://github.com/Dreamacro/clash">Clash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/SukkaW/Koolshare-Clash" target="_blank">KoolClash on GitHub</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://koolclash.js.org" target="_blank">KoolClash 使用文档</a></p>
            </div>
        </div>
    </div>

    <div class="box">
        <div class="heading">KoolClash 运行状态</div>

        <div class="content">
            <!-- ### KoolClash 运行状态 ### -->
            <div id="koolclash-field"></div>
            <div class="koolclash-btn-container">
                <button type="button" id="koolclash-btn-save-config" onclick="restartClash()" class="btn btn-primary">启动/重启 Clash</button>
                <button type="button" id="koolclash-btn-save-config" onclick="stopClash()" class="btn">停止 Clash</button>
            </div>
        </div>
    </div>

    <div id="koolclash-ip" class="box">
        <div class="heading" style="padding-right: 20px;">
            <div style="display: flex;">
                <div style="width: 61.8%">IP 地址检查</div>
                <div style="width: 31.2%">网站访问检查</div>
            </div>
        </div>

        <div class="content">
            <!-- ### KoolClash IP ### -->
            <div style="display: flex;">
                <div style="width: 61.8%">
                    <p><span class="ip-title">IPIP&nbsp;&nbsp;国内</span>:&nbsp;<span id="ip-ipipnet"></span></p>
                    <p><span class="ip-title">淘宝&nbsp;&nbsp;国内</span>:&nbsp;<span id="ip-taobao">&nbsp;</span><span id="ip-taobao-ipip"></span></p>
                    <p><span class="ip-title">IP.SB&nbsp;海外</span>:&nbsp;<span id="ip-ipsb"></span>&nbsp;<span id="ip-ipsb-geo"></span></p>
                    <p><span class="ip-title">ipify&nbsp;&nbsp;海外</span>:&nbsp;<span id="ip-ipify"></span>&nbsp;<span id="ip-ipify-ipip"></span></p>
                </div>
                <div style="width: 38.2%">
                    <p><span class="ip-title">百度搜索</span>&nbsp;:&nbsp;<span id="http-baidu"></span></p>
                    <p><span class="ip-title">网易 163</span>&nbsp;:&nbsp;<span id="http-163"></span></p>
                    <p><span class="ip-title">GitHub</span>&nbsp;:&nbsp;<span id="http-github"></span></p>
                    <p><span class="ip-title">YouTube</span>&nbsp;:&nbsp;<span id="http-youtube"></span></p>
                </div>
            </div>
            <p><span style="float: right">Powered by <a href="https://ip.skk.moe" target="_blank">ip.skk.moe</a></span></p>
        </div>
    </div>

    <div class="box">
        <div class="heading">KoolClash 配置</div>

        <div class="content">
            <!-- ### KoolClash 运行配置设置 ### -->
            <div id="koolclash-config"></div>
            <div class="koolclash-btn-container">
                <button type="button" id="koolclash-btn-save-config" onclick="saveRemoteConfigUrl()" class="btn btn-primary">提交 Clash 托管配置 URL</button>
                <button type="button" id="koolclash-btn-save-config" onclick="updateRemoteConfig()" class="btn btn-primary">更新 Clash 配置</button>
            </div>
        </div>
    </div>
    <script>
        if (!window.fetch) {
            window.alert('KoolClash 不支持你的浏览器！是时候去用 Chrome 浏览器了！')
        }

        let noop = () => { };
        if (typeof noop !== 'function') {
            window.alert('KoolClash 不支持你的浏览器！是时候去用 Chrome 浏览器了！')
        }
    </script>
    <script>
        if (typeof softcenter === undefined) {
            let softcenter = 0;
        } else {
            softcenter = 0;
        }

        let KoolClash = {
            // KoolClash 默认头部配置
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
            // getClashPid
            // 获取 Clash 进程 PID
            getClashPid: () => {
                let id = parseInt(Math.random() * 100000000),
                    postData = JSON.stringify({
                        "id": id,
                        "method": "koolclash_get_clash_pid.sh",
                        "params": [],
                        "fields": ""
                    });

                $.ajax({
                    type: "POST",
                    cache: false,
                    url: "/_api/",
                    data: postData,
                    dataType: "json",
                    success: (resp) => {
                        if (softcenter === 1) {
                            return false;
                        }
                        document.getElementById("koolclash_status").innerHTML = resp.result;
                    },
                    error: () => {
                        if (softcenter === 1) {
                            return false;
                        }
                        document.getElementById("koolclash_status").innerHTML = `<span style="color: red">获取 Clash 进程运行状态失败！`;
                    }
                });
            },
            submitConfig: () => {
                Base64.encode(E('_koolclash-config-headeer').value);
            }
        };

        // 创建 KoolClash 界面
        $('#koolclash-field').forms([
            {
                title: '<b>Clash 运行状态</b>',
                text: '<span id="koolclash_status" name="koolclash_status" color="#1bbf35">正在获取 Clash 进程状态...</span>'
            },
            {
                title: '<b>Clash 面板</b>',
                text: '<p><a href="https://clashx.skk.moe" target="_blank">Clash Dashboard</a>（请 <span style="font-weight: bold">务必使用 Chrome 浏览器</span> 访问）</p>'
            },
        ]);
        $('#koolclash-config').forms([
            {
                title: '<b>Clash 托管配置 URL</b>',
                name: 'koolclash-remote-config-url',
                type: 'text',
                value: 'https://example.com/clash', // KoolClash.remote_config_url || '';
                style: `width:100%`,
                placeholder: 'https://example.com/clash'
            },
            {
                title: `<b>Clash 运行配置</b>`,
                name: 'koolclash-config-headeer',
                type: 'textarea',
                value: KoolClash.defaultConfig, //Base64.decode(dbus.ss_isp_website_web) || KoolClash.defaultConfig,
                style: 'width: 100%; height: 300px;'
            },
        ]);
    </script>

    <script>
        // IP 检查
        let IP = {
            get: (url, type) =>
                fetch(url, { method: 'GET' }).then((resp) => {
                    if (type === 'text')
                        return Promise.all([resp.ok, resp.status, resp.text(), resp.headers]);
                    else {
                        return Promise.all([resp.ok, resp.status, resp.json(), resp.headers]);
                    }
                }).then(([ok, status, data, headers]) => {
                    if (ok) {
                        let json = {
                            ok,
                            status,
                            data,
                            headers
                        }
                        return json;
                    } else {
                        throw new Error(JSON.stringify(json.error));
                    }
                }).catch(error => {
                    throw error;
                }),
            parseIPIpip: (ip, elID) => {
                IP.get(`https://api.skk.moe/network/parseIp/ipip/${ip}`, 'json')
                    .then(resp => {
                        let x = '';
                        x += (resp.data[0] !== '') ? `${resp.data[0]} ` : '';
                        x += (resp.data[1] !== '') ? `${resp.data[1]} ` : '';
                        x += (resp.data[2] !== '') ? `${resp.data[2]} ` : '';
                        x += (resp.data[3] !== '') ? `${resp.data[3]} ` : '';
                        x += (resp.data[4] !== '') ? `${resp.data[4]} ` : '';
                        document.getElementById(elID).innerHTML = x;
                        //document.getElementById(elID).innerHTML = `${resp.data.country} ${resp.data.regionName} ${resp.data.city} ${resp.data.isp}`;
                    })
            },
            getIpipnetIP: () => {
                IP.get('https://myip.ipip.net', 'text')
                    .then(resp => document.getElementById('ip-ipipnet').innerHTML = resp.data);
            },
            getTaobaoIP: (data) => {
                document.getElementById('ip-taobao').innerHTML = data.ip;
                IP.parseIPIpip(data.ip, 'ip-taobao-ipip');
            },
            getIpsbIP: (data) => {
                document.getElementById('ip-ipsb').innerHTML = data.address;
                document.getElementById('ip-ipsb-geo').innerHTML = `${data.country} ${data.province} ${data.city} ${data.operator}`
            },
            getIpifyIP: () => {
                IP.get('https://api.ipify.org/?format=json', 'json')
                    .then(resp => {
                        document.getElementById('ip-ipify').innerHTML = resp.data.ip;
                        return resp.data.ip;
                    })
                    .then(ip => {
                        IP.parseIPIpip(ip, 'ip-ipify-ipip');
                    })
            },
        };
        // 将淘宝的 jsonp 回调给 IP 函数
        window.ipCallback = (data) => IP.getTaobaoIP(data);
        // 网站访问检查
        let HTTP = {
            checker: (domain, cbElID) => {
                let img = new Image;
                let timeout = setTimeout(() => {
                    img.onerror = img.onload = null;
                    document.getElementById(cbElID).innerHTML = '<span class="sk-text-error">连接超时</span>'
                }, 6000);

                img.onerror = () => {
                    clearTimeout(timeout);
                    document.getElementById(cbElID).innerHTML = '<span class="sk-text-error">无法访问</span>'
                }

                img.onload = () => {
                    clearTimeout(timeout);
                    document.getElementById(cbElID).innerHTML = '<span class="sk-text-success">连接正常</span>'
                }

                img.src = `https://${domain}/favicon.ico?${+(new Date)}`
            },
            runcheck: () => {
                HTTP.checker('www.baidu.com', 'http-baidu');
                HTTP.checker('www.163.com', 'http-163');
                HTTP.checker('github.com', 'http-github');
                HTTP.checker('www.youtube.com', 'http-youtube');
            }
        };

        IP.getIpipnetIP();
        IP.getIpifyIP();
        HTTP.runcheck();
    </script>

    <script>
        
    </script>
    <script src="https://www.taobao.com/help/getip.php"></script>
    <script src="https://ipv4.ip.sb/addrinfo.php?callback=IP.getIpsbIP"></script>

    <div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
    <div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
    <div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
</content>
