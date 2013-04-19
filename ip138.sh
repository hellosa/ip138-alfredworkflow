ip=$1

# get the result
url="http://www.ip138.com/ips138.asp?ip=${ip}&action=2"
result=`curl -s $url | grep '<ul class="ul1">' | iconv -f gbk -t utf8`
#echo $result

# how many results ?
n=`echo $result | awk -F "<li>" '{print NF-1}'`
#echo $n

/bin/echo '<?xml version="1.0"?>'
/bin/echo '<items>'
i=0
while [ $i -lt $n ] ; do
    j=$[ $i + 2]
    #echo $j
    addr=`echo $result |  awk -F '<li>' '{print $"'"$j"'" }' | awk -F '</li>' '{print $1}' | awk -F '：' '{print $2}'`
    subtitle=`echo $result |  awk -F '<li>' '{print $"'"$j"'" }' | awk -F '</li>' '{print $1}' | awk -F '：' '{print $1}'`
    uid=`echo $addr | md5sum | awk '{print $1}'`

    echo '<item uid="'$uid'" arg="'$addr'">'
    echo '<title>'$addr'</title>'
    echo '<subtitle>'$subtitle'</subtitle>'
    echo '<icon>icon.png</icon>'
    echo '</item>'
    let i++
done
/bin/echo '</items>'
