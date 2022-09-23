#!/bin/bash
test ! -e /usr/bin/aria2c || test ! -e ./lux  && { echo 缺少部件，请安装好aria2并把lux下载放到脚本旁边; sleep 5; exit; }
export GREP_COLOR='1;32'
export iid=$$
num1=0 && num2=0 && num3=0
chmod 755 ./lux
spath="$PWD"
clear

#检查一下lux版本更新
lux_check () {
#[ "$(($(expr `date +%d` + 0)%3))" != "2" ] && exit
lux_newv=`curl -s https://github.com/iawia002/lux/releases/latest|grep -o 'v0.[0-9.]\+'`
lux_oldv=`"./lux" -v|grep -o 'v0.[0-9.]\+'`
[ "$lux_newv" == "" ] && exit
[ "$lux_oldv" != "$lux_newv" ] && echo -e "\e[1;33mlux有新版本--$lux_newv\e[0m"
}

#每分钟统计情况
TJQK () {
while true
do
echo -e "\e[1;32m每分钟统计情况：已访问网站${webnum:-0}个，下载网页${pgnum:-0}个，下载媒体${menum:-0}个，总流量${size2:-0}M，总耗时${num1:-0}分，平均速度${speed:-0}KB\e[0m"
sleep 1m
num1=$(($num1+1))
size=`du /root/缓存文件夹/|awk '{print $1}'`
size2=$((${size:-0}/1024+${os:-0}))
webnum=`wc -l /root/缓存文件夹/weebsite|awk '{print $1}'`
speed=$((${size}/($num1*60)))
if [ "$((${size:-0}/1024))" -gt "2500" ]; then rm -rf /root/缓存文件夹/*.mp4 /root/缓存文件夹/*.flv /root/缓存文件夹/*.ts /root/缓存文件夹/*.mkv /root/缓存文件夹/*.f4v; os=$size2; fi
pgnum=`ls -l /root/缓存文件夹/|grep -e 'page' -e '\.html'|wc -l|awk '{print $1}'`
menum=`ls -l /root/缓存文件夹/|grep -e '\.\(mp3\|mp4\|flv\|f4v\)$' -e '\.\(jpg\|png\)$'|wc -l|awk '{print $1}'`
done
}

#随机下载网页，图片，音频
WYXZ () {
sleep 1
test ! -e ./site && echo -e "\e[0;33m脚本路径下没有发现'site'文档,将不会随机下载网页和图片等\e[0m" && exit
website=`cat ./site`
wlink=`echo "$website"|sed -n ''$(($RANDOM%$(echo "$website"|wc -l)+1))'p'`
while true; do
num3=$(($num3+1)); sleep 15
test -e /root/缓存文件夹 || exit
echo "随机下载网页$wlink"
curl -A "$UA1" -s $wlink -o "/root/缓存文件夹/page_w_$num3" && { grep -q "$wlink" /root/缓存文件夹/weebsite; [ "$?" == "1" ] && echo "$wlink" >> /root/缓存文件夹/weebsite; }
seclink=`cat "/root/缓存文件夹/page_w_$num3" 2>/dev/null|grep -o 'href="*https*://[a-zA-Z0-9.]\{,20\}\.com/*'|awk -F 'href="*' '{print $2}'|sort -u`
piclink=`cat "/root/缓存文件夹/page_w_$num3" 2>/dev/null|grep -o 'src="https*://.\+\.\(jpg\|png\|gif\|jpeg\)"'|awk -F '"' '{print $2}'`
audlink=`cat "/root/缓存文件夹/page_w_$num3" 2>/dev/null|grep -o 'src="https*://.\+\.\(mp3\|wav\|flv\|pdf\)"'|awk -F '"' '{print $2}'`
chilink=`cat "/root/缓存文件夹/page_w_$num3" 2>/dev/null|grep -o 'href="*https*://[a-zA-Z0-9./_]\+\.html'|awk -F 'href="*' '{print $2}'`
[ "$piclink" != "" ] || [ "$audlink" != "" ] || [ "$chilink" != "" ] && echo "随机下载子页面图片音频等$wlink"
[ "$piclink" != "" ] && aria2c -c -Z `echo "$piclink"|sed -n ''$(($RANDOM%$(echo "$piclink"|wc -l)+1))',+5p'` -d /root/缓存文件夹/ &> /dev/null
sleep 1
[ "$audlink" != "" ] && aria2c -c -Z `echo "$audlink"|sed -n ''$(($RANDOM%$(echo "$audlink"|wc -l)+1))',+5p'` -d /root/缓存文件夹/ &> /dev/null
sleep 1
[ "$chilink" != "" ] && aria2c -c -Z `echo "$chilink"|sed -n ''$(($RANDOM%$(echo "$chilink"|wc -l)+1))',+5p'` -d /root/缓存文件夹/ &> /dev/null
sleep 1
[ "$seclink" == "" ] || [ "$((${num3}%3))" == "2" ] && wlink=`echo "$website"|sed -n ''$(($RANDOM%$(echo "$website"|wc -l)+1))'p'` && continue
wlink=`echo "$seclink"|sed -n ''$(($RANDOM%$(echo "$seclink"|wc -l)+1))'p'`
done
}

#检查脚本是否关闭，就删除缓存
echo '#!/bin/bash
while kill -0 $iid; do sleep 1; done
rm -rf /root/缓存文件夹/' > /tmp/checkit && chmod +x /tmp/checkit
nohup /tmp/checkit &>/dev/null &

#mount -t tmpfs -o size=1g none /tmp

#限速450KB，换算300/s×1.5
iptables -I INPUT -i eth1 -j DROP
iptables -I INPUT -i eth1 -m limit --limit=300/s -j ACCEPT

#随机选择一个useragent
UA=`echo "\
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36
Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.164 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15"`
UA1=`echo "$UA"|sed -n ''$(($RANDOM%$(echo "$UA"|wc -l)+1))'p'`

rm -rf /root/缓存文件夹/
mkdir -p /root/缓存文件夹/
touch /root/缓存文件夹/weebsite
sleep 1
TJQK &
WYXZ &
lux_check &

#随机选择一个视频网站
videosite=`echo "\
https://haokan.baidu.com/
https://www.mgtv.com/
https://www.iqiyi.com/
https://yule.iqiyi.com/
https://www.bilibili.com/
https://www.bilibili.com/v/game/
https://movie.youku.com/"`
link1=`echo "$videosite"|sed -n ''$(($RANDOM%$(echo "$videosite"|wc -l)+1))'p'`

#下载页面
while true
do
echo -e "正在下载网页$link1"
curl -A "$UA1" "$link1" -o "/root/缓存文件夹/page_$num2" -#
#aria2c --allow-overwrite=true $link1 -d /root/缓存文件夹/ -o "page_$num2" &> /dev/null
if [ "$?" == "0" ]; then
cat /root/缓存文件夹/weebsite|grep -q "`echo $link1|grep -o '^https://.*/$'`"
[ $? == 1 ] && echo "$link1" >> /root/缓存文件夹/weebsite
fi

#各网站提取规则
if echo "$link1"|grep -q '\.bilibili\.com'; then
link2=`cat "/root/缓存文件夹/page_$num2" 2>/dev/null|grep -o '/video/BV\w\{8,15\}'|sed 's/^/https:\/\/www.bilibili.com/g'|sort -u`
fi
if echo "$link1"|grep -q '\.youku\.com'; then
link2=`cat "/root/缓存文件夹/page_$num2" 2>/dev/null|grep -o '/v_show/id_\w\{5,35\}==.html'|sed 's/^/https:\/\/v.youku.com/g'|sort -u`
fi
if echo "$link1"|grep -q '\.iqiyi\.com'; then
link2=`cat "/root/缓存文件夹/page_$num2" 2>/dev/null|grep -o '/v_\w\{5,25\}.html'|sed 's/^/https:\/\/www.iqiyi.com/g'|sort -u`
fi
if echo "$link1"|grep -q '\.baidu\.com'; then
link2=`cat "/root/缓存文件夹/page_$num2" 2>/dev/null|grep -o '/v?vid=[0-9]*'|sed 's/^/https:\/\/haokan.baidu.com/g'|sort -u`
fi
if echo "$link1"|grep -q '\.mgtv\.com'; then
link2=`cat "/root/缓存文件夹/page_$num2" 2>/dev/null|grep -o '\\\u002Fb\\\u002F[0-9]*\\\u002F[0-9]*\.html'|sed 's/\\\u002F/\//g'|sed 's/^/https:\/\/www.mgtv.com/g'|sort -u`
fi

[ "$link2" == "" ] || [ `echo "$link2"|wc -l` == "1" ]  && echo -e "\e[1;33m网页下载失败，换网站下载\e[0m" && link1=`echo "$videosite"|sed -n ''$(($RANDOM%$(echo "$videosite"|wc -l)+1))'p'` && continue

s_link2=`echo "$link2"|sed -n ''$(($RANDOM%$(echo "$link2"|wc -l)+1))',+2p'`
#echo "$link2"
cd /root/缓存文件夹/
"${spath}"/lux -o /root/缓存文件夹/ `echo $s_link2`|grep --color=always "Site:.\+"
cd "${spath}"
link1=`echo "$link2"|sed -n ''$(($RANDOM%$(echo "$link2"|wc -l)+1))'p'` #随机选一个子页面循环
if echo $link1|grep -q "baidu.com"; then link1=https://haokan.baidu.com/; fi # 百度视频返回首页循环
[ "$((${num2}%5))" == "3" ] && echo -e "\e[1;33m循环了4遍，换网站下载\e[0m" && link1=`echo "$videosite"|sed -n ''$(($RANDOM%$(echo "$videosite"|wc -l)+1))'p'` #循环4遍换网站循环

num2=$(($num2+1)) && sleep 1
done
}

#Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0
