#!/usr/bin/env bash

function help {
    echo "-h 打开帮助文档"
    echo "-c p 对jpeg格式图片进行图片质量因子为p的压缩"
    echo "-r q 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩q分辨率"
    echo "-w size text 对图片批量添加自定义文本内容为text,字体大小为size的水印"
    echo "-p pretext 不影响原始文件扩展名的前提下，统一添加文件名前缀"
    echo "-s suftext 不影响原始文件扩展名的前提下，统一添加文件名后缀"
    echo "-j 将png/svg图片统一转换为jpg格式图片"
}

#对jpeg格式图片进行图片质量压缩
function quality_compression {
    p=$1 #质量因子
    for img in *.jpeg;
    do
    convert "${img}" -quality "${p}" "qc-${img}"
    echo "${img}图片质量压缩成功"
    done
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function compression_resolution {
    q=$2 #
    for img in *.jpg *.jpeg *.svg;
    do
    convert "${img}" -resize "${q}" "cr-${img}"
    echo "${img}压缩成功"
    done
}

#对图片批量添加自定义文本水印
function add_watermark {
    size=$1
    text=$2
    for img in *.jpg *.jpeg *.png *.svg;
    do
    convert "${img}" -pointsize "${size}" -fill black -gravity center -draw "text 10,10 '${text}'" "ad-${img}"
    echo "${img}添加水印成功"
    done
}

#批量重命名（不影响原始文件扩展名的前提下）
#统一添加文件名前缀
function add_pretext {
    pretext=$1
    for img in *.jpg *.jpeg *.png *.svg;
    do
    mv "${img}" "$1" "${img}"
    echo "${img}成功添加前缀${pretext}"
    done
}
#统一添加文件名后缀
function add_suftext {
    suftext=$1
    for img in *.jpg *.jpeg *.png *.svg;
    do
    type=${img##*.}
    filename=${img%.*}$1"."${type}
    mv "${img}" "${filename}"
    echo "${img}成功添加后缀${suftext}"
    done
}

#将png/svg图片统一转换为jpg格式图片
function change_type {

    for img in *.png *.svg;
    do
    filename="${img%.*}"".""jpg"
    convert "${img}" "${filename}"
    echo "${img}成功转换为jpg格式图片"
    done
}

while [ "$1" != "" ] ;do
case "$1" in
    "-h")
    echo"这是帮助文档"
    help
    exit 0
    ;;

    "-c")
    echo"这是图片质量压缩"
    quality_compression "$2"
    exit 0
    ;;

    "-r")
    echo"这是将图片压缩至相应分辨率"
    compression_resolution "$2"
    exit 0
    ;;

    "-w")
    echo"这是为图片添加水印"
    add_watermark "$2" "$3"
    exit 0
    ;;

    "-p")
    echo"这是为文件加前缀名"
    add_pretext "$2"
    exit 0
    ;;

    "-s")
    echo"这是为文件加后缀名"
    add_suftext "$2"
    exit 0
    ;;

    "-j")
    echo"这是将图片改成jpg格式"
    change_type
    exit 0
    ;;
esac
done