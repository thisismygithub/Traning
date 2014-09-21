﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Jsonp-1.aspx.vb" Inherits="JSONP_Jsonp_1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN">
<html>
    <head>
        <meta content="text/html; charset=Big5" http-equiv="content-type">
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript">
            window.onload = function() {
                function param(obj) {
                    var pairs = [];
                    for(var name in obj) {
                        var pair = encodeURIComponent(name) + '=' + 
                                   encodeURIComponent(obj[name]);
                        pairs.push(pair.replace('/%20/g', '+'));
                    }
                    return pairs.join('&');
                }
                
                function getScript(url, callback) {
                    var script = document.createElement('script');
                    script.type = 'text/javascript';
                    script.src = url;
                    
                    // 跨瀏覽器處理 script 下載完成後的事件
                    script.onload = script.onreadystatechange = function() {
                        if (!this.readyState ||
                            this.readyState === "loaded" || 
                            this.readyState === "complete") {
                            this.onload = this.onreadystatechange = null;
                            document.getElementsByTagName('head')[0]
                                    .removeChild(this);
                            callback();
                        }
                    };
                    
                    document.getElementsByTagName('head')[0]
                            .appendChild(script);
                }
                
                function jsonp(option, callbackName) {
                    // 沒有url或伺服端要求的callbackName就結束
                    if(!option.url || !callbackName) {
                        return;
                    }
                    var data = option.data || {};
                    
                    // 建立暫時的函式
                    data[callbackName] = 'XD' + jsonp.jsc++;
                    window[data[callbackName]] = function(json) {
                        option.callback(json);
                    };
                    var url = option.url + '?' + param(data);
                    
                    // 取得 script 檔案
                    getScript(url, function() {
                         // script 下載並執行完後移除暫時的函式
                         window[data[callbackName]] = undefined;
                         try {
                             delete window[data[callbackName]];
                         }
                         catch(e) {}
                    });
                }
                jsonp.jsc = new Date().getTime();
                
                document.getElementById('test').onclick = function() {
                    jsonp({
                        url      : 'http://openhome.cc/Gossip/' +
                                   'JavaScript/samples/JSONP-1.php',
                        data     : {
                            id   : document.getElementById('id').value,
                        },
                        callback : function(person) {
                            document.getElementById('result').innerHTML = 
                                person.name + ',' + person.age;
                        }
                    }, 'jsoncallback');
                };
            };
        </script>        
    </head>
    <body>
        ID：<input id="id">
        <button id="test">JSONP 測試</button>
        <span id="result"></span>
    </body>
</html>