#!/usr/bin/env bash

function help {
    echo "-h 打开帮助文档"
    echo "-a 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
    echo "-p 统计不同场上位置的球员数量、百分比"
    echo "-n 查看名字最长和最短的球员名字"
    echo "-c 查看年龄最大和最小的球员名字 "
    echo "-d 下载相应数据文件"
}

#使用wget将数据文件下载到当前目录
function download {
    wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/worldcupplayerinfo.tsv"
}

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function count_age {
    awk -F "\t" '
        BEGIN{low=0;mid=0;high=0}
        $6!="Age"{
            if($6>=0&&$6<20) {low++;}
            else if($6>30) {high++;}
            else {mid++;}
        }
        END{
            sum=low+mid+high;
            printf ("Age\tCount\tPercentage\n");
            printf("<20\t%d\t%f%%\n",low,low*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",mid,mid*100.0/sum);
            printf(">30\t%d\t%f%%\n",hihg,high*100.0/sum);
        }' worldcupplayerinfo.tsv
}

#统计不同场上位置的球员数量、百分比
function count_position {
    awk -F "\t" '
        BEGIN{sum=0}
        $5!="Position"{
            pos[$5]++;
            sum++;
        }
        END{
            printf ("Position\tCount\tPercentage\n");
            for( i in pos ){
                printf("%13s\t%d\t%f%%n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

#名字最长的球员是谁？名字最短的球员是谁？
function long_name {
    awk -F "\t" '
        BEGIN{longname=0,shortname=0}
        $9!="Player"{
            len=length($9)
            name[$9]=len;
            if(len>longname){longname=len}
            if(len<minname){shortname=len}
        }
        END{
            printf ("名字最长的球员有：\n",longname);
            for( i in name ){
               if(name[i]==longname){printf"%s\t",i}
            }
            printf("\n");
            printf ("名字最短的球员有：\n",shortname);
            for( j in name ){
               if(name[j]==shortname){printf"%s\t",j}
            }
            printf("\n");
        }' worldcupplayerinfo.tsv
}
#年龄最大的球员是谁？年龄最小的球员是谁？
function max_age {
    awk -F "\t" '
        BEGIN{maxage=0,minage=0}
        $6!="Age"{
            playerage=$6;
            name[$9]=playerage;
            if(playerage>maxage){maxage=playerage}
            if(playerage<minname){minage=playerage}
        }
        END{
            printf ("名字最大的球员有：\n",maxage);
            for( i in name ){
               if(name[i]==maxage){printf"%s\t",i}
            }
            printf("\n");
            printf ("名字最小的球员有：\n",minage);
            for( j in name ){
               if(name[j]==minage){printf"%s\t",j}
            }
            printf("\n");
        }' worldcupplayerinfo.tsv
}

while [ "$1" != "" ] ; do
    case "$1" in
    "-h")
    echo "这是帮助文档"
    help
    exit 0
    ;;

    "-a")
    echo "这是有关不同年龄区间范围的统计"
    count_age
    exit 0
    ;;

    "-p")
    echo "这是有关不同场上位置的统计"
    count_position
    exit 0
    ;;

    "-n")
    echo "这是有关名字最长和最短的球员的统计"
    long_name
    exit 0
    ;;

    "-c")
    echo "这是有关年龄最大和最小的球员的统计"
    max_age
    exit 0
    ;;

    "-d")
    echo "下载相关数据文件"
    download
    exit 0
    ;;
esac
done