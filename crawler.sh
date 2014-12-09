#!/bin/bash

#http://edyfox.codecarver.org/html/bash_url_encode.html
export LANG=C

urlencode() {
    # urlencode <string>
    if [ $# -lt 1 ]; then
        echo Usage: urlencode string
        exit 1
    fi

    j="0"
    for arg in $*; do

        i="0"

        while [ "$i" -lt ${#arg} ]; do
            c=${arg:$i:1}
            if echo "$c" | grep -q '[a-zA-Z0-9:_\.\-\(\)]'; then
                echo -n "$c"
            elif [ "$c" == " " ]; then
                printf "+"
            elif [ "$c" = " " ]; then
                printf "+"
            else
                printf "%%%x" "'$c'"
            fi
            i=$((i+1))
        done
        printf "+"
    done

}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\x}"
}


URL=http://ting.hujiang.com/
CLASS=xbryxdb1
OUTPUT=new/
mkdir $OUTPUT

pages=()
for c in `curl $URL$CLASS/'page'[1-13]/`
do 
    if echo $c | grep -E "/$CLASS/[0-9]{12}" > /dev/null
    then 
        pages+=(`echo $c | grep -oP "$CLASS\/[0-9]{12}\/"`)
    fi
done

#echo ${pages[@]}
#pages=(xbryxdb1/161509091726/)

for p in ${pages[@]}
do
    echo $URL$p
    #title=`curl -s $URL$p | sed -e 's///g'|sed -n "/<h3 id=\"listenTitle\">/,/<\/h3>/p" | grep -oP "新编日语.*"`
    #title=`curl -s $URL$p | sed -e 's///g' | tr '' ' ' | tr '\n' ' ' | tr '\r' ' '|sed -n "/<h3 id=\"listenTitle\">/,/<\/h3>/p" | grep -oP "<h3 id=\"listenTitle\">.*<\/h3>" `
    title=`curl -s $URL$p | sed -e 's///g' | sed -n "/<h3 id=\"listenTitle\">/,/<\/h3>/p" | tr '' ' ' | tr '\n' ' ' | tr '\r' ' '| grep -oP "<\/a>.*<\/h3>" `
    title=${title:4}
    title=${title%%</\h3>}
    #title=`echo $title | tr -d ' ' | tr '(' '[' | tr ')' ']'`
    title=`echo $title | sed -e 's/^ *//' -e 's/ *$//'`

    #title=`curl -s $URL$p | sed -e 's///g' | grep -E '<h3 id=\"listenTitle\".*</h3>'`
    #title=`curl -s $URL$p | grep -oP '>\"新编日语.*\"'`
    #title=`curl -s $URL$p | grep -oP '(?<=<h3 id="listenTitle"> ).*?(?= </h3>)'`
    echo $title

    echo "Downloading "$title".mp3 ..."
    mp3=`curl -s $URL$p | grep -oP "http:\/\/t1.g.hjfile.cn\/listen\/[0-9]{6}\/[0-9]{21}.mp3"`
    #mp3=$mp3"?attach="`urlencode 沪江听写酷_$title`
    #mp3=${mp3%%\+}
    #mp3="http://t1.g.hjfile.cn/listen/201307/201307011014384405433.mp3?attach=%e6%b2%aa%e6%b1%9f%e5%90%ac%e5%86%99%e9%85%b7_%e6%96%b0%e7%bc%96%e6%97%a5%e8%af%ad%e7%ac%ac%e4%b8%80%e5%86%8c(%e4%bf%ae%e8%ae%a2%e7%89%88)+%e7%ac%ac09%e8%af%be+%e5%89%8d%e6%96%87"
    echo URL: $mp3
    title=`echo $title | tr -d ' ' | tr '/' '\' `
    curl -L -l $mp3 > $OUTPUT"$title".mp3 
    echo "$OUTPUT""$title".mp3 Done
    sleep 30
done

