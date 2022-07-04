#!/usr/bin/env bash

function help {
    echo "-h 打开帮助文档"
    echo "-d 下载并解压相应数据文件"
    echo "-H 统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i 统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u 统计最频繁被访问的URL TOP 100"
    echo "-s 统计不同响应状态码的出现次数和对应百分比"
    echo "-c 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-p 给定URL输出TOP 100访问来源主机"
}

#使用wget将数据文件下载到当前目录
function download_unzip {
    wget  "https://c4pr1c3.github.io/LinuxSysAdmin/exp/chap0x04/web_log.tsv.7z"
    7z x web_log.tsv.7z
}

#统计访问来源主机TOP 100和分别对应出现的总次数
function top_host {
    printf "%-50s\t%-20s\n" "top100_host" "Count"
    awk -F "\t" '
    NR>1 { host[$1]++;}
    END{ for (i in host) {
        printf ("%-50s\t%-20d\n",i,host[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -100
}

#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function top_ip {
    printf "%-50s\t%-20s\n" "top100_ip" "Count"
    awk -F "\t" '
    NR>1 {if(match($1,/^((2(5[0-5]|[0-4][0-9]))|[0-1]?[0-9]{1,2})(\.((2(5[0-5]|[0-4][0-9]))|[0-1]?[0-9]{1,2})){3}$/)) ipnum[$1] ++ ;}
    END{ for (i in ip) {
        printf ("%-50s\t%-20d\n",i,ip[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -100
}

#统计最频繁被访问的URL TOP 100
function top_url {
    printf "%-50s\t%-20s\n" "top100_url" "Count"
    awk -F "\t" '
    NR>1 {urlnum[$5]++;}
    END{ for (i in url) {
        printf ("%-50s\t%-20d\n",i,url[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -100
}
#统计不同响应状态码的出现次数和对应百分比
function recode_status {
    printf "%-50s%-10s%-10s\n" "Range" "Count" "Percentage"
    awk -F "\t" '
    NR>1 {status[$6]++;}
    END{ for (i in status) {
        printf ("%-50s%-10s-.4f%%\n",i,status[i]，status[i]*100.0/(NR-1);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -100
}

#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function recode_code4 {
    printf "%-10s%-70s%-20s\n" "Status" "top10_url" "Count"
    awk -F "\t" '
    NR>1 {if($6=="404") code404[$5]++; }
    END{ for (i in code404) {
         printf ("%-10s%-70s%-20d\n","404",i,code404[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -10

    awk -F "\t" '
    NR>1 {if($6=="403") code[$5]++; }
    END{ for (i in code403) {
         printf ("%-10s%-70s%-20d\n","403",i,code403[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -10
}

#给定URL输出TOP 100访问来源主机
function url_host {
    printf "%-50s\t%-20s\n" "top100_host" "Count"
    awk -F "\t" '
    NR>1 {if("'"$1"'"==$5){host[$1]++};}
    END{ for (i in host) {
        printf ("%-50s\t%-20d\n",i,host[i]);
    }
    }'web_log.tsv | sort -g -k 2 -r | head -100
}

while [ "$1" != "" ] ; do
    case "$1" in
    "-h")
    echo "这是帮助文档"
    help
    exit 0
    ;;

    "-d")
        echo "下载并解压相关数据文件"
        download_unzip
        exit 0
        ;;

    "-H")
    echo "这是有关访问来源主机TOP 100和分别对应出现的总次数的统计"
    top_host
    exit 0
    ;;

    "-i")
    echo "这是有关访问来源主机TOP 100 IP和分别对应出现的总次数的统计"
    top_ip
    exit 0
    ;;

    "-u")
    echo "这是有关最频繁被访问TOP 100的URL 的统计"
    top_url
    exit 0
    ;;

    "-s")
    echo "这是有关不同响应状态码的出现次数和对应百分比的统计"
    recode_status
    exit 0
    ;;

    "-c")
    echo "这是分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    recode_code4
    exit 0
    ;;
     "-p")
    echo "这是给定URL输出TOP 100访问来源主机"
    url_host "$2"
    exit 0
    ;;

    
esac
done