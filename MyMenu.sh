# https://billie66.github.io/TLCL/book/


#!/bin/bash
# 如有侵权，请联系admin@fxzhuji.com删除
Font_Black="\033[30m"
Font_Red="\033[31m"
Font_Green="\033[32m"
Font_Yellow="\033[33m"
Font_Blue="\033[34m"
Font_Purple="\033[35m"
Font_SkyBlue="\033[36m"
Font_White="\033[37m"
Font_Suffix="\033[0m"


#科技lion的一键脚本
#官网版一键脚本
#curl -sS -O https://kejilion.pro/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh


# 调用方法
#source ./MyMenu.sh   或   . ./MyMenu.sh


function get_char()
{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}





###########################################################
#
#
#
#
#
#                       Local
#
#
#
#
#
###########################################################


function local_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " Local"
		echo "-------------------------------------------"
		echo "1.ffmpeg系列"
		echo "2.N305专用"
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	  1)  local_ffmpeg_m
	  ;;
	  2)  local_n305_m
	  ;;
	  0)  break
     	  ;;
     	esac
     done
}



###########################################################
#
#
#
#
#
#                       Local > ffmpeg系列
#
#
#
#
#
###########################################################


function local_ffmpeg_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " ffmpeg系列"
		echo "-------------------------------------------"
		echo "h.ffmpeg_hwacc"
		echo ""
		echo "11.list gen"
		echo "12.list gen less than 12h"
		echo "13.chapter_gen"
		echo ""
		echo "141.convert"
		echo "142.convert fake4k"		
		echo "143.convert CPU"
		echo "144.convert CPU fake4k"
		echo "145.convert+chapter"
		echo "146.convert+chapter fake4k"
		echo "147.convert+chapter CPU"
		echo "148.convert+chapter CPU fake4k"
		echo ""
		echo "1491.del /root/*.mp4 from _outfiles.txt"
		echo "1492.del /root/*.mp4 + _out_*.txt"
		echo ""
		echo "151.fake 4k60 - h264 cpu"
		echo "152.fake 4k60 - h264 vaapi"
		echo "153.fake 4k60 - h265 vaapi"
		echo ""
		echo "154.vp9"
		echo "155.vp9_vaapi"
		echo "156.x264"
		echo "157.x264_vaapi"
		echo "158.x265"
		echo "159.x265_vaapi"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	  h)  ffmpeg_hwacc
	  ;;
	  11)  list_gen
	  ;;
	  12)  list_gen__less_than_12h
	  ;;
	  13)  chapter_gen
	  ;;
	  141)  convert
	  ;;
	  142)  convert_fake4k
	  ;;
	  143)  convert_CPU
	  ;;
	  144)  convert_CPU_fake4k
	  ;;
	  145)  convert+chapter
	  ;;
	  146)  convert+chapter_fake4k
	  ;;
	  147)  convert+chapter_CPU
	  ;;
	  148)  convert+chapter_CPU_fake4k
	  ;;
	  1491)  del_root_mp4_from__outfiles_txt
	  ;;
	  1492)  del_root_mp4_with_out_x_txt
	  ;;
	  151)  fake_4k60__h264_cpu
	  ;;
	  152)  fake_4k60__h264_vaapi
	  ;;
	  153)  fake_4k60__h265_vaapi
	  ;;
	  154)  vp9
	  ;;
	  155)  vp9_vaapi
	  ;;
	  156)  x264
	  ;;
	  157)  x264_vaapi
	  ;;
	  158)  x265
	  ;;
	  159)  x265_vaapi
	  ;;
	  0)break
     	 ;;
     	esac
     done
}



function ffmpeg_hwacc(){
ffmpeg -encoders | grep vaapi
# echo "按任意键继续." && char=`get_char`
read -n 1 -s -r -p "按任意键继续."
}




function list_gen(){
mkdir -p /root/conv/ && find /root/ -maxdepth 1 -type f -name '*.mp4' | sort -V | awk '{print "file '\''" $0 "'\''"}' > /root/_outfiles.txt
read -n 1 -s -r -p "按任意键继续."
}





function list_gen__less_than_12h(){
mkdir -p /root/conv/  # 自动创建文件夹（如果已存在则不提示）

max_duration=41400  # 11.5小时（秒）
#max_duration=43200  # 12小时（秒）
total_duration=0
> /root/_outfiles.txt  # 清空输出文件

while read -r file; do
    # 获取文件时长（浮点数）
    duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 "$file")
    
    # 确保 `duration` 变量不是空的，否则跳过该文件
    if [[ -z "$duration" ]]; then
        echo "❌ 获取 $file 时长失败，跳过..."
        continue
    fi

    # 更新总时长（浮点数）
    total_duration=$(awk -v td="$total_duration" -v d="$duration" 'BEGIN {print td + d}')

    # 格式化单个文件时长为小时、分钟、秒
    file_hours=$(awk -v d="$duration" 'BEGIN {printf "%d", d / 3600}')
    file_minutes=$(awk -v d="$duration" 'BEGIN {printf "%d", (d % 3600) / 60}')
    file_seconds=$(awk -v d="$duration" 'BEGIN {printf "%d", d % 60}')

    # 打印文件时长
    echo "文件: $file, 时长: ${file_hours}小时 ${file_minutes}分钟 ${file_seconds}秒"

    # 检查是否超出最大时长
    is_valid=$(awk -v td="$total_duration" -v md="$max_duration" 'BEGIN {print (td <= md) ? 1 : 0}')
    if [[ "$is_valid" -eq 1 ]]; then
        echo "file '$file'" >> /root/_outfiles.txt
    else
        echo "⚠️ 已达到 12 小时限制，跳过 $file"
        break
    fi
done < <(find /root/ -maxdepth 1 -type f -name "*.mp4" | sort -V)

# 格式化输出总时长（小时、分钟、秒）
total_hours=$(awk -v td="$total_duration" 'BEGIN {printf "%d", td / 3600}')
total_minutes=$(awk -v td="$total_duration" 'BEGIN {printf "%d", (td % 3600) / 60}')
total_seconds=$(awk -v td="$total_duration" 'BEGIN {printf "%d", td % 60}')

echo "✅ 总合并时长: ${total_hours}小时 ${total_minutes}分钟 ${total_seconds}秒"
read -n 1 -s -r -p "按任意键继续."
}




function chapter_gen(){
    # Check if input file exists
    input_file="/root/_outfiles.txt"
    if [ ! -f "$input_file" ]; then
        echo "❌ 错误：$input_file 文件不存在，退出脚本。"
        return 1
    fi

    # Initialize output files
    chapters_file="/root/_outchapters.txt"
    yt_file="/root/_out_yt.txt"
    
    echo ";FFMETADATA1" > "$chapters_file"
    > "$yt_file"

    start_time=0
    timebase=1000  # Time unit: milliseconds

    # Read files from _outfiles.txt
    while IFS= read -r line; do
        # Extract file path (remove 'file ' prefix and quotes)
        filepath=$(echo "$line" | sed -e "s/^file '//" -e "s/'$//")
        
        # Check if file exists
        if [ ! -f "$filepath" ]; then
            echo "⚠️ 文件不存在，跳过: $filepath"
            continue
        fi

        # Get video duration (seconds)
        duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 "$filepath")
        duration_ms=$(awk "BEGIN {print int($duration * $timebase)}")  # Convert to milliseconds

        end_time=$((start_time + duration_ms))

        # Get filename without extension
        filename=$(basename "$filepath" .mp4)

        # Write to _outchapters.txt
        echo "[CHAPTER]" >> "$chapters_file"
        echo "TIMEBASE=1/1000" >> "$chapters_file"
        echo "START=$start_time" >> "$chapters_file"
        echo "END=$end_time" >> "$chapters_file"
        echo "title=$filename" >> "$chapters_file"
        echo "" >> "$chapters_file"  # Add empty line between chapters

        # Write to _out_yt.txt (format: HH:MM:SS Title)
        start_time_seconds=$((start_time / 1000))
        hours=$((start_time_seconds / 3600))
        minutes=$(( (start_time_seconds % 3600) / 60 ))
        seconds=$((start_time_seconds % 60))
        printf "%02d:%02d:%02d %s\n" $hours $minutes $seconds "$filename" >> "$yt_file"

        # Update start_time
        start_time=$end_time
    done < "$input_file"

    echo "✅ 章节文件生成完成:"
    echo "   - 元数据文件: $chapters_file"
    echo "   - YouTube章节: $yt_file"
    read -n 1 -s -r -p "按任意键继续."
}




function chapter_gen_old(){   #老版本,不根据_outfiles.txt生成章节
# 初始化 _outchapters.txt 文件
echo ";FFMETADATA1" > _outchapters.txt

# 初始化 _out_yt.txt 文件
> _out_yt.txt

start_time=0
timebase=1000  # 时间单位：毫秒

# 使用 find 命令获取文件列表，并按自然排序法排序
while IFS= read -r -d '' file; do
    # 获取视频时长（秒）
    duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of csv=p=0 "$file")
    duration_ms=$(awk "BEGIN {print int($duration * $timebase)}")  # 转换为毫秒

    end_time=$((start_time + duration_ms))

    # 输出到 _outchapters.txt
    echo "[CHAPTER]" >> _outchapters.txt
    echo "TIMEBASE=1/1000" >> _outchapters.txt
    echo "START=$start_time" >> _outchapters.txt
    echo "END=$end_time" >> _outchapters.txt
    echo "title=$(basename "$file" .mp4)" >> _outchapters.txt  # 去掉扩展名

    # 输出到 _out_yt.txt
    # 将毫秒转换为时间码（HH:MM:SS）
    start_time_seconds=$((start_time / 1000))
    timecode=$(date -u -d @$start_time_seconds +"%H:%M:%S")
    echo "$timecode $(basename "$file" .mp4)" >> _out_yt.txt

    # 更新 start_time
    start_time=$end_time
done < <(find /root/ -maxdepth 1 -type f -name "*.mp4" -print0 | sort -V -z)
read -n 1 -s -r -p "按任意键继续."
}




function convert(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264_vaapi）: " filename
  filename=${filename:-_out_x264_vaapi}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf "scale_vaapi=w=1920:h=1080" -r 60 \
    -c:v h264_vaapi -b:v 6M -preset:v speed -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert_old(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf "scale_vaapi=w=1920:h=1080" -r 60 \
    -c:v h264_vaapi -b:v 6M -c:a copy -movflags faststart -y "/root/conv/_out_x264_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}





function convert_fake4k(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_fake4k_x264_vaapi）: " filename
  filename=${filename:-_out_fake4k_x264_vaapi}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf 'scale_vaapi=4096:-2' \
    -c:v h264_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -preset:v speed \
    -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert_fake4k_old(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf 'scale_vaapi=4096:-2' \
    -c:v h264_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -c:a copy -movflags faststart -y "/root/conv/_out_fake4k_x264_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}







function convert_CPU(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264）: " filename
  filename=${filename:-_out_x264}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=60" -r 60 -c:v h264 -b:v 6M -preset:v veryfast -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert_CPU_old(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=60" -r 60 -c:v h264 -preset:v fast -b:v 6M -c:a copy -movflags faststart -y "/root/conv/_out_x264.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}







function convert_CPU_fake4k(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_fake4k_x264_vaapi）: " filename
  filename=${filename:-_out_fake4k_x264_vaapi}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -filter_complex "[0:0]scale=4096:-2" -c:v libx264 -b:v 25000k -minrate:v 20000k -maxrate:v 60000k -bufsize:v 25000k -threads auto -preset:v ultrafast -keyint_min 10 -g 10 -fps_mode cfr -r 60 -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert_CPU_fake4k_old(){
# 检查 /root/_outfiles.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner \
    -f concat -safe 0 -i /root/_outfiles.txt \
    -filter_complex "[0:0]scale=4096:-2" -c:v libx264 -b:v 25000k -minrate:v 20000k -maxrate:v 60000k -bufsize:v 25000k -threads auto -preset:v ultrafast -keyint_min 10 -g 10 -fps_mode cfr -r 60 -c:a copy -movflags faststart -y "/root/conv/_out_fake4k_x264.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}










function convert+chapter(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264_chap_vaapi）: " filename
  filename=${filename:-_out_x264_chap_vaapi}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 \
    -vf "scale_vaapi=w=1920:h=1080" -r 60 \
    -c:v h264_vaapi -b:v 6M -preset:v speed -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert+chapter_old(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 \
    -vf "scale_vaapi=w=1920:h=1080" -r 60 \
    -c:v h264_vaapi -b:v 6M -c:a copy -movflags faststart -y "/root/conv/_out_x264_chap_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}












function convert+chapter_fake4k(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264_chap_fake4k_vaapi）: " filename
  filename=${filename:-_out_x264_chap_fake4k_vaapi}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 \
    -vf 'scale_vaapi=4096:-2' \
    -c:v h264_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -preset:v speed \
    -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert+chapter_fake4k_old(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi


time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 \
    -vf 'scale_vaapi=4096:-2' \
    -c:v h264_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -c:a copy -movflags faststart -y "/root/conv/_out_x264_chap_fake4k_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}














function convert+chapter_CPU(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264_chap）: " filename
  filename=${filename:-_out_x264_chap}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=60" -r 60 -c:v h264 -b:v 6M -preset:v veryfast -c:a copy -movflags faststart -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert+chapter_CPU_old(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=60" -r 60 -c:v h264 -preset:v fast -b:v 6M -c:a copy -movflags faststart -y "/root/conv/_out_x264_chap.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
















function convert+chapter_CPU_fake4k(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

# 获取用户输入的文件名
while true; do
  read -p "请输入输出文件名（不含扩展名，留空则默认 _out_x264_chap_fake4k）: " filename
  filename=${filename:-_out_x264_chap_fake4k}  # 如果用户未输入，使用默认值
  output_file="/root/conv/${filename}.mp4"

  # 检查文件是否已存在
  if [[ -f "$output_file" ]]; then
    echo "⚠️ 文件已存在: $output_file"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      break  # 覆盖文件，退出循环
    else
      echo "请重新输入文件名。"
    fi
  else
    break  # 文件不存在，可以使用
  fi
done

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 -filter_complex "[0:0]scale=4096:-2" -c:v libx264 -b:v 25000k -minrate:v 20000k -maxrate:v 60000k -bufsize:v 25000k -threads auto -preset:v ultrafast -keyint_min 10 -g 10 -fps_mode cfr -r 60 -c:a copy -movflags faststart -c:a copy -y "$output_file"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}
function convert+chapter_CPU_fake4k_old(){
# 检查 /root/_outfiles.txt 和 /root/_outchapters.txt 是否存在
if [[ ! -f /root/_outfiles.txt ]] || [[ ! -f /root/_outchapters.txt ]]; then
  echo "❌ 错误：/root/_outfiles.txt 或 /root/_outchapters.txt 文件不存在，退出脚本。"
  exit 1
fi

time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -f concat -safe 0 -i /root/_outfiles.txt -i /root/_outchapters.txt -map_metadata 1 -filter_complex "[0:0]scale=4096:-2" -c:v libx264 -b:v 25000k -minrate:v 20000k -maxrate:v 60000k -bufsize:v 25000k -threads auto -preset:v ultrafast -keyint_min 10 -g 10 -fps_mode cfr -r 60 -c:a copy -movflags faststart -c:a copy -y "/root/conv/_out_x264_chap_fake4k.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ 合并转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}

















function del_root_mp4_from__outfiles_txt(){
if [ -f "/root/_outfiles.txt" ]; then
    grep -oP "(?<=file ')/root/.*?\.mp4" "/root/_outfiles.txt" | xargs -I{} rm -f {}
    find /root/ -maxdepth 1 -type f -name "_out*.txt" -delete
else
    find /root/ -maxdepth 1 -type f \( -name "*.mp4" -o -name "_out*.txt" \) -delete
fi
read -n 1 -s -r -p "按任意键继续."
}





function del_root_mp4_with_out_x_txt(){
find /root/ -maxdepth 1 -type f \( -name "*.mp4" -o -name "_out*.txt" \) -delete && \
find /root/conv/ -type f -name "_out*.mp4" -delete
#find /root/conv/ -type f -name "*.mp4" -delete
read -n 1 -s -r -p "按任意键继续."
}







function fake_4k60__h264_cpu(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
    ffmpeg -hide_banner -i "$file" -filter_complex "[0:0]scale=4096:-2" -c:v libx264 -b:v 25000k -minrate:v 20000k -maxrate:v 60000k -bufsize:v 25000k -threads auto -preset:v ultrafast -keyint_min 10 -g 10 -fps_mode cfr -r 60 -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x264_fake4k.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}





function fake_4k60__h264_vaapi(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
    ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -i "$file" \
    -vf 'scale_vaapi=4096:-2' \
    -c:v h264_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x264_vaapi_fake4k.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}




function fake_4k60__h265_vaapi(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
    ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -i "$file" \
    -vf 'scale_vaapi=4096:-2' \
    -c:v hevc_vaapi -crf 28 -g 10 -r 60 -fps_mode cfr \
    -b:v 25000k -minrate 20000k -maxrate 60000k -bufsize 25000k \
    -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x265_vaapi_fake4k.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}




function vp9(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -i "$file" \
    -vf 'scale=1920:1080' \
    -c:v libvpx-vp9 -b:v 5000k -crf 28 -row-mt 1 -cpu-used 8 \
    -c:a libopus -b:a 128k \
    -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_vp9.webm"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}



function vp9_vaapi(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -i "$file" \
    -vf 'scale_vaapi=w=1920:h=1080' \
    -c:v vp9_vaapi -b:v 5000k -maxrate 6000k -bufsize 10000k \
    -c:a libopus -b:a 128k \
    -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_vp9_vaapi.webm"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}




function x264(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
   ffmpeg -hide_banner -i "$file" -c:v libx264 -threads auto -preset:v veryfast -crf 28 -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x264.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}





function x264_vaapi(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -i "$file" \
    -vf 'scale_vaapi=w=1920:h=1080' \
    -c:v h264_vaapi -b:v 5000k -maxrate 6000k -bufsize 10000k -crf 28 \
    -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x264_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}




function x265(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
   ffmpeg -hide_banner -i "$file" -c:v libx265 -threads auto -preset:v veryfast -crf 28 -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x265.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}





function x265_vaapi(){
total_start=$(date +%s)  # 记录整个批量转码的开始时间

for file in /root/*.mp4; do
time_start=$(date +%s)  # 记录当前视频的开始时间
  ffmpeg -hide_banner -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi \
    -i "$file" \
    -vf 'scale_vaapi=w=1920:h=1080' \
    -c:v hevc_vaapi -b:v 5000k -maxrate 6000k -bufsize 10000k -crf 28 \
    -c:a copy -movflags faststart -y "/root/conv/$(basename "$file" .mp4)_x265_vaapi.mp4"

  time_end=$(date +%s)
  elapsed=$((time_end - time_start))

  printf "✅ %s 转码完成，耗时: %02d小时 %02d分 %02d秒\n\n" \
    "$file" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
done

total_end=$(date +%s)  # 记录整个流程的结束时间
total_elapsed=$((total_end - total_start))

printf "🎉 所有视频转码完成！总耗时: %02d小时 %02d分 %02d秒\n" \
  $((total_elapsed / 3600)) $(((total_elapsed % 3600) / 60)) $((total_elapsed % 60))
read -n 1 -s -r -p "按任意键继续."
}






###########################################################
#
#
#
#
#
#                       Local > N305专用
#
#
#
#
#
###########################################################



function local_n305_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " N305专用"
		echo "-------------------------------------------"
		echo "11.N305 auto iptable @systemd"
		echo "12.N305 ip route temp"
		echo ""
		echo "21.mihomo debug run"
		echo "22.mihomo restart"
		echo "23.mihomo status"
		echo "24.mihomo stop"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	  11)  N305_auto_iptable_systemd
	  ;;
	  12)  N305_ip_route
	  ;;
	  21)  mihomo_debug_run
	  ;;
	  22)  mihomo_restart
	  ;;
	  23)  mihomo_status
	  ;;
	  24)  mihomo_stop
	  ;;
	  0)break
     	 ;;
     	esac
     done
}




function N305_auto_iptable_systemd(){
cat > /etc/systemd/system/MyIPTables.service <<EOF
[Unit]
Description=Set up network routes and firewall rules
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "sleep 10 && ip route add 172.17.3.6 via 192.168.100.1 dev enp2s0 && ip route add 107.155.88.234 via 192.168.100.1 dev enp2s0 && iptables -A INPUT -s 192.168.100.0/24 -j ACCEPT && iptables -A OUTPUT -d 192.168.100.0/24 -j ACCEPT"
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable MyIPTables.service && systemctl start MyIPTables.service


# Note:
# systemctl daemon-reload && systemctl enable MyIPTables.service && systemctl start MyIPTables.service
# systemctl daemon-reload && systemctl restart MyIPTables.service
# systemctl status MyIPTables.service
# systemctl stop MyIPTables.service
read -n 1 -s -r -p "按任意键继续."
}




function N305_ip_route(){
ip route add 172.17.3.6 via 192.168.100.1 dev enp2s0
ip route add 107.155.88.234 via 192.168.100.1 dev enp2s0
iptables -A INPUT -s 192.168.100.0/24 -j ACCEPT && iptables -A OUTPUT -d 192.168.100.0/24 -j ACCEPT
read -n 1 -s -r -p "按任意键继续."
}





function mihomo_debug_run(){
/root/.config/mihomo/mihomo -d /root/.config/mihomo/
read -n 1 -s -r -p "按任意键继续."
}


function mihomo_restart(){
systemctl restart mihomo.service
read -n 1 -s -r -p "按任意键继续."
}


function mihomo_status(){
systemctl status mihomo.service
read -n 1 -s -r -p "按任意键继续."
}


function mihomo_stop(){
systemctl stop mihomo.service
read -n 1 -s -r -p "按任意键继续."
}



###########################################################
#
#
#
#
#
#                       test
#
#
#
#
#
###########################################################


function test_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " test"
		echo "-------------------------------------------"
		echo "1.Backtrace test"
		echo "2.io speed check"
		echo "3.ip quality check"
		echo "4.stream_unlock_test"
		echo "41.stream_unlock_test(1)"
		echo "5.NS测评脚本"
		echo "6.speedtest"
		echo "7.test port 80"
		echo "8.占空间"
		echo "9.网络质量检测(完整路由模式) https://www.nodeseek.com/post-300167-1"
		echo "91.网络质量检测(低流量模式) https://www.nodeseek.com/post-300167-1"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	  1)  Backtrace_test
	  ;;
	  2)  io_speed_check
	  ;;
	  3)  ip_quality_check
	  ;;
	  4)  stream_unlock_test
	  ;;
	  41) stream_unlock_test_1
	  ;;
	  5)  nodeseek_test_script
	  ;;
	  6)  speedtest
	  ;;
	  7)  test_port_80
	  ;;
	  8)  fill_space
	  ;;
	  9)  net_quality_test
	  ;;
	  91) net_quality_test_low
	  ;;
	  0)break
     	 ;;
     	esac
     done
}



function Backtrace_test(){
curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
read -n 1 -s -r -p "按任意键继续."
}



function io_speed_check(){
dd bs=64k count=4k if=/dev/zero of=test oflag=dsync
read -n 1 -s -r -p "按任意键继续."
}




function ip_quality_check(){
bash <(curl -sL IP.Check.Place) -l cn
read -n 1 -s -r -p "按任意键继续."
}




function stream_unlock_test(){
bash <(curl -L -s https://git.io/JRw8R)
read -n 1 -s -r -p "按任意键继续."
}



function stream_unlock_test_1(){
bash <(curl -Ls unlock.icmp.ing/test.sh)
read -n 1 -s -r -p "按任意键继续."
}




function nodeseek_test_script(){
bash <(curl -sL https://run.NodeQuality.com)
read -n 1 -s -r -p "按任意键继续."
}



function speedtest(){
wget -qO- network-speed.xyz | bash
read -n 1 -s -r -p "按任意键继续."
}



function test_port_80(){
netstat -ano -p tcp | find "80" >nul 2>nul && echo Found || echo NotFound
read -n 1 -s -r -p "按任意键继续."
}



function fill_space(){
dd if=/dev/zero of=/tmp/fillup.zeros bs=100M count=100
read -n 1 -s -r -p "按任意键继续."
}


function net_quality_test(){
bash <(curl -Ls Net.Check.Place) -R
read -n 1 -s -r -p "按任意键继续."
}

function net_quality_test_low(){
bash <(curl -Ls Net.Check.Place) -L
read -n 1 -s -r -p "按任意键继续."
}






###########################################################
#
#
#
#
#
#                       新机必备
#
#
#
#
#
###########################################################


function newdevice_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " 新机必备"
		echo "-------------------------------------------"
		echo "111.view current BBR info"
		echo "112.BBR_auto_set"
		echo ""
		echo "11.SSH Key/Port/vnstat/日志清除"
		echo "12.vnstat/日志清除(LXC专用, 最后会reboot)"
		echo "13.vnstat/日志清除(含SSH Key,不改端口)"
		echo "14.vnstat/日志清除(不含SSH Key,不改端口)"
		echo ""
		echo "2.warp"
		echo "24.warp +IPv4"
		echo "26.warp +IPv6"
		echo "28.warp 卸载"		
		echo "21.warp-go"
		echo "214.warp-go +IPv4"
		echo "216.warp-go +IPv6"
		echo "218.warp-go 卸载"
		echo ""
		echo "31.vasma"
		echo "32.old"
		echo "33.facarmen"
		echo "34.hy2_v4"
		echo "35.hy1+hy2"
		echo ""
		echo "9.openssh更新"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	     111) view_curr_BBR_info
	     ;;
	     112) BBR_auto_set
	     ;;
	     11) KVM_Key_Port
	     ;;
	     12) LXC_use
	     ;;
	     13) KVM_Key_Only
	     ;;
	     14) KVM_Optimize_Only
	     ;;
	     2)  warp
	     ;;
	     24) warp_v4
	     ;;
	     26) warp_v6
	     ;;
	     28) warp_u
	     ;;
	     21) warpgo
	     ;;
	     214) warpgo_v4
	     ;;
	     216) warpgo_v6
	     ;;
	     218) warpgo_u
	     ;;
	     31) ladder_vasma
	     ;;
	     32) ladder_old
	     ;;
	     33) ladder_fscarmen
	     ;;
	     34) hy2_v4
	     ;;
	     35) hy1_hy2
	     ;;
	     9) openssh_update
	     ;;
	     0)  break
     	     ;;
     	esac
     done
}





function view_curr_BBR_info(){
sysctl net.ipv4.tcp_congestion_control
read -n 1 -s -r -p "按任意键继续."
}



function BBR_auto_set(){
modprobe tcp_bbr && echo -e "\ntcp_bbr" | tee -a /etc/modules-load.d/modules.conf && echo -e "\nnet.core.default_qdisc=fq\nnet.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf && sysctl -p
read -n 1 -s -r -p "按任意键继续."
}




function KVM_Key_Port(){
apt clean
apt autoclean
#           清理日志
find /var/log -type f \( -name "*.log.*" -o -name "*.log-[0-9]*" -o -name "*.log.[0-9]*" -o -name "*.gz" -o -name "*.1" -o -name "*.2" -o -name "*.3" -o -name "*.4" -o -name "*.5" -o -name "*.6" -o -name "*.7" -o -name "*.8" -o -name "*.9" \) -delete
# 清空当前 .log 文件（保留文件本身，防止进程写日志时报错）
find /var/log -type f -name "*.log" -exec sh -c ': > "$1"' _ {} \;
# 安全清空二进制日志（保持结构不破坏）
: > /var/log/btmp
: > /var/log/debug
: > /var/log/lastlog
: > /var/log/messages
: > /var/log/secure
: > /var/log/syslog
: > /var/log/wtmp
# alternatives
tee /etc/logrotate.d/alternatives > /dev/null <<'EOF'
/var/log/alternatives.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# apt
tee /etc/logrotate.d/apt > /dev/null <<'EOF'
/var/log/apt/*.log {
    size 100K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# btmp
tee /etc/logrotate.d/btmp > /dev/null <<'EOF'
/var/log/btmp {
    size 100K
    rotate 1
    missingok
    create 0660 root utmp
}
EOF
# dpkg
tee /etc/logrotate.d/dpkg > /dev/null <<'EOF'
/var/log/dpkg.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# rsyslog
tee /etc/logrotate.d/rsyslog > /dev/null <<'EOF'
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/auth.log
/var/log/daemon.log
/var/log/debug
/var/log/user.log {
    size 200K
    rotate 1
    daily
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# wtmp
tee /etc/logrotate.d/wtmp > /dev/null <<'EOF'
/var/log/wtmp {
    size 100K
    rotate 1
    monthly
    missingok
    create 0664 root utmp
}
EOF
# 立即执行一次轮转，确保生效
logrotate -f /etc/logrotate.conf

            # 显示所有限制
            #ulimit -a
            # 设置core文件大小为0,禁止生成core
	    #ulimit -c 0
tee -a /etc/systemd/system.conf /etc/systemd/user.conf > /dev/null <<'EOF'
DefaultLimitCORE=0
EOF
systemctl daemon-reexec

apt update
apt install -y curl
bash <(curl -fsSL git.io/key.sh) -o -g ttlttc -p 32641 -d
apt install -y vnstat
 sed -i -E 's/^[;]*UnitMode [01]/UnitMode 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnit [01]/RateUnit 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnitMode [01]/RateUnitMode 0/' /etc/vnstat.conf
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart
timedatectl set-timezone Australia/Perth
timedatectl set-ntp true
# 日志优化
CONF=/etc/systemd/journald.conf
grep -q '^\[Journal\]' "$CONF" || echo '[Journal]' >> "$CONF"
for kv in "Storage=volatile" "RuntimeMaxUse=10M" "RuntimeMaxFileSize=1M"; do
    key=${kv%%=*}
    grep -q "^$key=" "$CONF" && sed -i "s|^$key=.*|$kv|" "$CONF" || sed -i "/^\[Journal\]/a $kv" "$CONF"
done
systemctl restart systemd-journald
rm -rf /var/log/journal/*
journalctl --disk-usage

read -n 1 -s -r -p "新端口: 32641, 按任意键继续!"
}




function LXC_use(){
		    apt clean
            apt autoclean
#           清理日志
find /var/log -type f \( -name "*.log.*" -o -name "*.log-[0-9]*" -o -name "*.log.[0-9]*" -o -name "*.gz" -o -name "*.1" -o -name "*.2" -o -name "*.3" -o -name "*.4" -o -name "*.5" -o -name "*.6" -o -name "*.7" -o -name "*.8" -o -name "*.9" \) -delete
# 清空当前 .log 文件（保留文件本身，防止进程写日志时报错）
find /var/log -type f -name "*.log" -exec sh -c ': > "$1"' _ {} \;
# 安全清空二进制日志（保持结构不破坏）
: > /var/log/btmp
: > /var/log/debug
: > /var/log/lastlog
: > /var/log/messages
: > /var/log/secure
: > /var/log/syslog
: > /var/log/wtmp
# alternatives
tee /etc/logrotate.d/alternatives > /dev/null <<'EOF'
/var/log/alternatives.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# apt
tee /etc/logrotate.d/apt > /dev/null <<'EOF'
/var/log/apt/*.log {
    size 100K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# btmp
tee /etc/logrotate.d/btmp > /dev/null <<'EOF'
/var/log/btmp {
    size 100K
    rotate 1
    missingok
    create 0660 root utmp
}
EOF
# dpkg
tee /etc/logrotate.d/dpkg > /dev/null <<'EOF'
/var/log/dpkg.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# rsyslog
tee /etc/logrotate.d/rsyslog > /dev/null <<'EOF'
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/auth.log
/var/log/daemon.log
/var/log/debug
/var/log/user.log {
    size 200K
    rotate 1
    daily
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# wtmp
tee /etc/logrotate.d/wtmp > /dev/null <<'EOF'
/var/log/wtmp {
    size 100K
    rotate 1
    monthly
    missingok
    create 0664 root utmp
}
EOF
# 立即执行一次轮转，确保生效
logrotate -f /etc/logrotate.conf

            # 显示所有限制
            #ulimit -a
            # 设置core文件大小为0,禁止生成core
	    #ulimit -c 0
tee -a /etc/systemd/system.conf /etc/systemd/user.conf > /dev/null <<'EOF'
DefaultLimitCORE=0
EOF
systemctl daemon-reexec

		    apt update
		    apt install -y curl
		    bash <(curl -fsSL git.io/key.sh) -o -g ttlttc -p 32641 -d
		    apt install -y vnstat
 sed -i -E 's/^[;]*UnitMode [01]/UnitMode 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnit [01]/RateUnit 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnitMode [01]/RateUnitMode 0/' /etc/vnstat.conf
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart
		    timedatectl set-timezone Australia/Perth
timedatectl set-ntp true
# 日志优化
CONF=/etc/systemd/journald.conf
grep -q '^\[Journal\]' "$CONF" || echo '[Journal]' >> "$CONF"
for kv in "Storage=volatile" "RuntimeMaxUse=10M" "RuntimeMaxFileSize=1M"; do
    key=${kv%%=*}
    grep -q "^$key=" "$CONF" && sed -i "s|^$key=.*|$kv|" "$CONF" || sed -i "/^\[Journal\]/a $kv" "$CONF"
done
systemctl restart systemd-journald
rm -rf /var/log/journal/*
journalctl --disk-usage

# LXC专用,要不然改端口不生效,而且必须重启
		    systemctl mask ssh.socket
            systemctl mask sshd.socket
            systemctl disable sshd
            systemctl enable ssh
            reboot
read -n 1 -s -r -p "新端口: 32641, 按任意键继续!"
}





function KVM_Key_Only(){
            apt clean
            apt autoclean
#           清理日志
find /var/log -type f \( -name "*.log.*" -o -name "*.log-[0-9]*" -o -name "*.log.[0-9]*" -o -name "*.gz" -o -name "*.1" -o -name "*.2" -o -name "*.3" -o -name "*.4" -o -name "*.5" -o -name "*.6" -o -name "*.7" -o -name "*.8" -o -name "*.9" \) -delete
# 清空当前 .log 文件（保留文件本身，防止进程写日志时报错）
find /var/log -type f -name "*.log" -exec sh -c ': > "$1"' _ {} \;
# 安全清空二进制日志（保持结构不破坏）
: > /var/log/btmp
: > /var/log/debug
: > /var/log/lastlog
: > /var/log/messages
: > /var/log/secure
: > /var/log/syslog
: > /var/log/wtmp
# alternatives
tee /etc/logrotate.d/alternatives > /dev/null <<'EOF'
/var/log/alternatives.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# apt
tee /etc/logrotate.d/apt > /dev/null <<'EOF'
/var/log/apt/*.log {
    size 100K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# btmp
tee /etc/logrotate.d/btmp > /dev/null <<'EOF'
/var/log/btmp {
    size 100K
    rotate 1
    missingok
    create 0660 root utmp
}
EOF
# dpkg
tee /etc/logrotate.d/dpkg > /dev/null <<'EOF'
/var/log/dpkg.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# rsyslog
tee /etc/logrotate.d/rsyslog > /dev/null <<'EOF'
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/auth.log
/var/log/daemon.log
/var/log/debug
/var/log/user.log {
    size 200K
    rotate 1
    daily
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# wtmp
tee /etc/logrotate.d/wtmp > /dev/null <<'EOF'
/var/log/wtmp {
    size 100K
    rotate 1
    monthly
    missingok
    create 0664 root utmp
}
EOF
# 立即执行一次轮转，确保生效
logrotate -f /etc/logrotate.conf

            # 显示所有限制
            #ulimit -a
            # 设置core文件大小为0,禁止生成core
	    #ulimit -c 0
tee -a /etc/systemd/system.conf /etc/systemd/user.conf > /dev/null <<'EOF'
DefaultLimitCORE=0
EOF
systemctl daemon-reexec
	        apt update
		    apt install -y curl
	        bash <(curl -fsSL git.io/key.sh) -o -g ttlttc -d
	        apt install -y vnstat
 sed -i -E 's/^[;]*UnitMode [01]/UnitMode 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnit [01]/RateUnit 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnitMode [01]/RateUnitMode 0/' /etc/vnstat.conf
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart
	        timedatectl set-timezone Australia/Perth
timedatectl set-ntp true
# 日志优化
CONF=/etc/systemd/journald.conf
grep -q '^\[Journal\]' "$CONF" || echo '[Journal]' >> "$CONF"
for kv in "Storage=volatile" "RuntimeMaxUse=10M" "RuntimeMaxFileSize=1M"; do
    key=${kv%%=*}
    grep -q "^$key=" "$CONF" && sed -i "s|^$key=.*|$kv|" "$CONF" || sed -i "/^\[Journal\]/a $kv" "$CONF"
done
systemctl restart systemd-journald
rm -rf /var/log/journal/*
journalctl --disk-usage

read -n 1 -s -r -p "按任意键继续."
}




function KVM_Optimize_Only(){
            apt clean
            apt autoclean
#           清理日志
find /var/log -type f \( -name "*.log.*" -o -name "*.log-[0-9]*" -o -name "*.log.[0-9]*" -o -name "*.gz" -o -name "*.1" -o -name "*.2" -o -name "*.3" -o -name "*.4" -o -name "*.5" -o -name "*.6" -o -name "*.7" -o -name "*.8" -o -name "*.9" \) -delete
# 清空当前 .log 文件（保留文件本身，防止进程写日志时报错）
find /var/log -type f -name "*.log" -exec sh -c ': > "$1"' _ {} \;
# 安全清空二进制日志（保持结构不破坏）
: > /var/log/btmp
: > /var/log/debug
: > /var/log/lastlog
: > /var/log/messages
: > /var/log/secure
: > /var/log/syslog
: > /var/log/wtmp
# alternatives
tee /etc/logrotate.d/alternatives > /dev/null <<'EOF'
/var/log/alternatives.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# apt
tee /etc/logrotate.d/apt > /dev/null <<'EOF'
/var/log/apt/*.log {
    size 100K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# btmp
tee /etc/logrotate.d/btmp > /dev/null <<'EOF'
/var/log/btmp {
    size 100K
    rotate 1
    missingok
    create 0660 root utmp
}
EOF
# dpkg
tee /etc/logrotate.d/dpkg > /dev/null <<'EOF'
/var/log/dpkg.log {
    size 50K
    rotate 1
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# rsyslog
tee /etc/logrotate.d/rsyslog > /dev/null <<'EOF'
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/auth.log
/var/log/daemon.log
/var/log/debug
/var/log/user.log {
    size 200K
    rotate 1
    daily
    missingok
    notifempty
    copytruncate
    compress
}
EOF
# wtmp
tee /etc/logrotate.d/wtmp > /dev/null <<'EOF'
/var/log/wtmp {
    size 100K
    rotate 1
    monthly
    missingok
    create 0664 root utmp
}
EOF
# 立即执行一次轮转，确保生效
logrotate -f /etc/logrotate.conf

            # 显示所有限制
            #ulimit -a
            # 设置core文件大小为0,禁止生成core
	    #ulimit -c 0
tee -a /etc/systemd/system.conf /etc/systemd/user.conf > /dev/null <<'EOF'
DefaultLimitCORE=0
EOF
systemctl daemon-reexec
	        apt update
		    apt install -y curl
	        apt install -y vnstat
 sed -i -E 's/^[;]*UnitMode [01]/UnitMode 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnit [01]/RateUnit 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnitMode [01]/RateUnitMode 0/' /etc/vnstat.conf
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart
	        timedatectl set-timezone Australia/Perth
timedatectl set-ntp true
# 日志优化
CONF=/etc/systemd/journald.conf
grep -q '^\[Journal\]' "$CONF" || echo '[Journal]' >> "$CONF"
for kv in "Storage=volatile" "RuntimeMaxUse=10M" "RuntimeMaxFileSize=1M"; do
    key=${kv%%=*}
    grep -q "^$key=" "$CONF" && sed -i "s|^$key=.*|$kv|" "$CONF" || sed -i "/^\[Journal\]/a $kv" "$CONF"
done
systemctl restart systemd-journald
rm -rf /var/log/journal/*
journalctl --disk-usage

read -n 1 -s -r -p "按任意键继续."
}




function warp(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh -P /root/ && bash /root/menu.sh
read -n 1 -s -r -p "按任意键继续."
}
function warp_v4(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh -P /root/ && bash /root/menu.sh 4
read -n 1 -s -r -p "按任意键继续."
}
function warp_v6(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh -P /root/ && bash /root/menu.sh 6
read -n 1 -s -r -p "按任意键继续."
}
function warp_u(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh -P /root/ && bash /root/menu.sh u
read -n 1 -s -r -p "按任意键继续."
}


function warpgo(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh -P /root/ && bash /root/warp-go.sh
read -n 1 -s -r -p "按任意键继续."
}
function warpgo_v4(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh -P /root/ && bash /root/warp-go.sh 4
read -n 1 -s -r -p "按任意键继续."
}
function warpgo_v6(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh -P /root/ && bash /root/warp-go.sh 6
read -n 1 -s -r -p "按任意键继续."
}
function warpgo_u(){
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/warp-go.sh -P /root/ && bash /root/warp-go.sh u
read -n 1 -s -r -p "按任意键继续."
}



function ladder_vasma(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
read -n 1 -s -r -p "按任意键继续."
}

function ladder_old(){
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/wulabing/Xray_onekey/nginx_forward/install.sh" && chmod +x install.sh && bash install.sh
read -n 1 -s -r -p "按任意键继续."
}

function ladder_fscarmen(){
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh) -c
read -n 1 -s -r -p "按任意键继续."
}

function hy2_v4(){
wget -O install.sh https://raw.githubusercontent.com/seagullz4/hysteria2/main/install.sh && chmod +x install.sh && bash install.sh
read -n 1 -s -r -p "按任意键继续."
}

function hy1_hy2(){
bash <(curl -fsSL https://git.io/hysteria.sh)
read -n 1 -s -r -p "按任意键继续."
}

function openssh_update(){
# https://www.nodeseek.com/post-419078-1
wget -O upgrade_openssh.sh https://gist.github.com/Seameee/2061e673132b05e5ed8dd6eb125f1fd1/raw/upgrade_openssh.sh && sudo chmod +x ./upgrade_openssh.sh && sudo ./upgrade_openssh.sh
read -n 1 -s -r -p "按任意键继续."
}




###########################################################
#
#
#
#
#
#                         Soft
#
#
#
#
#
###########################################################



function soft_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " Soft"
		echo "-------------------------------------------"
		echo "11.tmux安装+自定义设置 | 12.tmux 仅改变设置"
		echo "100.tmux attach -t 0 | 支持 100~109"
		echo "110.tmux new -s 0 | 支持110~119"
		echo ""
		echo "21.openlist install"
		echo "22.restart | 23.stop | 24.status | 25.update"
		echo ""
		echo "31.yt-dlp-U"
		echo "32.yt-dlp-DL"
		echo "33.yt-dlp-DL_shortname"
		echo "34.yt-dlp-DL Playlist"
		echo ""
		echo "41.curl 1000GB"
		echo "42.wget 1000GB"
		echo "43.webbenchmark 手动加链接"
		echo "44.preset 1 | 45.preset 2 | 46.preset 3"
		echo ""
		echo "511.ServerStatus Client restart | 512.enable"
		echo "513.ServerStatus Server restart"
		echo ""
		echo "521.vnstat_rm db"
		echo "522.vnstat restart"
		echo "523.vnstat status"
		echo "524.vnstat -h YYYY-MM-DD -e YYYY-MM-DD"
		echo "525.vnstat -h | 526. -d| 527. -m | 528. -y"
		echo "529.vnstat 改设置"
		echo ""
		echo "531.vocechat cron重启,看备注"
		echo "532.restart | 533.start | 534.stop"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	     11)  tmux_install_with_user_config
	     ;;
	     12)  tmux_ONLY_user_config
	     ;;
	     100) tmux_attach_-t_0
	     ;;
	     101) tmux_attach_-t_1
	     ;;
	     102) tmux_attach_-t_2
	     ;;
	     103) tmux_attach_-t_3
	     ;;
	     104) tmux_attach_-t_4
	     ;;
	     105) tmux_attach_-t_5
	     ;;
	     106) tmux_attach_-t_6
	     ;;
	     107) tmux_attach_-t_7
	     ;;
	     108) tmux_attach_-t_8
	     ;;
	     109) tmux_attach_-t_9
	     ;;
	     110) tmux_new_-s_0
	     ;;
	     111) tmux_new_-s_1
	     ;;
	     112) tmux_new_-s_2
	     ;;
	     113) tmux_new_-s_3
	     ;;
	     114) tmux_new_-s_4
	     ;;
	     115) tmux_new_-s_5
	     ;;
	     116) tmux_new_-s_6
	     ;;
	     117) tmux_new_-s_7
	     ;;
	     118) tmux_new_-s_8
	     ;;
	     119) tmux_new_-s_9
	     ;;
	     21)  openlist_install
	     ;;
	     22)  openlist_restart
	     ;;
	     23)  openlist_stop
	     ;;
	     24)  openlist_status
	     ;;
	     25)  openlist_update
	     ;;
	     31)  yt-dlp-U
	     ;;
	     32)  yt-dlp-DL
	     ;;
	     33)  yt-dlp-DL_shortname
	     ;;
	     34)  yt-dlp-DL_playlist
	     ;;
	     41)  curl_1000GB
	     ;;
	     42)  wget_1000GB
	     ;;
	     43)  webbenchmark
	     ;;
	     44)  webbenchmark1
	     ;;
	     45)  webbenchmark2
	     ;;
	     46)  webbenchmark3
	     ;;
	     511)  ServerStatus_client_restart
	     ;;
	     512)  ServerStatus_client_enable
	     ;;
	     513)  ServerStatus_server_restart
	     ;;
	     521)  vnstat_rm_db
	     ;;
	     522)  vnstat_restart
	     ;;
	     523)  vnstat_status
	     ;;
	     524)  vnstat_-h_custom_date_range
	     ;;
	     525)  vnstat_-h
	     ;;
	     526)  vnstat_-d
	     ;;
	     527)  vnstat_-m
	     ;;
	     528)  vnstat_-y
	     ;;
	     529)  vnstat_change_config
	     ;;
	     531)  vocechat_cron_info
	     ;;
	     532)  vocechat_restart
	     ;;
	     533)  vocechat_start
	     ;;
	     534)  vocechat_stop
	     ;;
	     0)
	     break
     	     ;;
     	esac
     done
}



function tmux_install_with_user_config(){
apt install -y tmux
cat > /root/.tmux.conf <<EOF
# 禁用鼠标滚轮切换历史命令
unbind -n WheelUpPane
unbind -n WheelDownPane
# 启用鼠标支持（用于选择窗口、调整窗格大小等）
set -g mouse on
# 启用滚动条
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
# 设置滚动历史缓冲区大小（默认是 2000 行）
set -g history-limit 5000
EOF
tmux source-file /root/.tmux.conf
read -n 1 -s -r -p "按任意键继续."
}





function tmux_ONLY_user_config(){
cat > /root/.tmux.conf <<EOF
# 禁用鼠标滚轮切换历史命令
unbind -n WheelUpPane
unbind -n WheelDownPane
# 启用鼠标支持（用于选择窗口、调整窗格大小等）
set -g mouse on
# 启用滚动条
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
# 设置滚动历史缓冲区大小（默认是 2000 行）
set -g history-limit 5000
EOF
tmux source-file /root/.tmux.conf
read -n 1 -s -r -p "按任意键继续."
}





function tmux_attach_-t_0(){
tmux attach -t 0
}
function tmux_attach_-t_1(){
tmux attach -t 1
}
function tmux_attach_-t_2(){
tmux attach -t 2
}
function tmux_attach_-t_3(){
tmux attach -t 3
}
function tmux_attach_-t_4(){
tmux attach -t 4
}
function tmux_attach_-t_5(){
tmux attach -t 5
}
function tmux_attach_-t_6(){
tmux attach -t 6
}
function tmux_attach_-t_7(){
tmux attach -t 7
}
function tmux_attach_-t_8(){
tmux attach -t 8
}
function tmux_attach_-t_9(){
tmux attach -t 9
}
function tmux_new_-s_0(){
tmux new -s 0
}
function tmux_new_-s_1(){
tmux new -s 1
}
function tmux_new_-s_2(){
tmux new -s 2
}
function tmux_new_-s_3(){
tmux new -s 3
}
function tmux_new_-s_4(){
tmux new -s 4
}
function tmux_new_-s_5(){
tmux new -s 5
}
function tmux_new_-s_6(){
tmux new -s 6
}
function tmux_new_-s_7(){
tmux new -s 7
}
function tmux_new_-s_8(){
tmux new -s 8
}
function tmux_new_-s_9(){
tmux new -s 9
}



function openlist_install(){
# curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install /root

# systemctl stop alist
# curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s uninstall

# openlist原版一键安装
# curl -fsSL https://res.oplist.org/script/v4.sh > install-openlist-v4.sh && bash install-openlist-v4.sh
# gpt改进版静默安装
curl -fsSL https://res.oplist.org/script/v4.sh -o install-openlist-v4.sh && bash install-openlist-v4.sh install /root


systemctl stop openlist
echo ""
     		echo "后面会自动重启openlist,先删除 /root/openlist/data/ 里面的文件,然后从备份中覆盖."
     		echo ""
     		read -p "按任意键继续!"
     		systemctl restart openlist
     		read -n 1 -s -r -p "按任意键继续."
}


function openlist_restart(){
systemctl restart openlist
read -n 1 -s -r -p "按任意键继续."
}

function openlist_restart(){
systemctl stop openlist
read -n 1 -s -r -p "按任意键继续."
}

function openlist_status(){
systemctl status openlist
read -n 1 -s -r -p "按任意键继续."
}


function openlist_update(){
#curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s update /root
curl -fsSL https://res.oplist.org/script/v4.sh -o install-openlist-v4.sh && bash install-openlist-v4.sh update
read -n 1 -s -r -p "按任意键继续."
}




function yt-dlp-U(){
./yt-dlp -U
read -n 1 -s -r -p "按任意键继续."
}


function yt-dlp-DL(){
echo ""
read -p "请输入yt视频链接最后的编码: " yt_url_last_address
./yt-dlp -o "/root/%(upload_date>%Y%m%d)s_%(title)s_%(display_id)s.%(ext)s" --no-overwrites -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" https://www.youtube.com/watch?v=$yt_url_last_address
read -n 1 -s -r -p "按任意键继续."
}


function yt-dlp-DL_shortname(){
echo ""
read -p "请输入yt视频链接最后的编码: " yt_url_last_address
./yt-dlp -o "/root/%(upload_date>%Y%m%d)s__%(display_id)s.%(ext)s" --no-overwrites -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" https://www.youtube.com/watch?v=$yt_url_last_address
read -n 1 -s -r -p "按任意键继续."
}

function yt-dlp-DL_playlist(){
echo ""
read -p "请输入yt playlist链接最后的编码: playlist?list=xxxxxxxxx" yt_playlist_last_address

./yt-dlp -o "/root/%(playlist_index)s_%(title)s_%(display_id)s.%(ext)s" \
    --no-overwrites \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best" \
    "https://www.youtube.com/playlist?list=$yt_playlist_last_address"
#    --playlist-reverse \    
read -n 1 -s -r -p "按任意键继续."
}




function curl_1000GB(){
curl -o /dev/null http://speedtest.tele2.net/1000GB.zip
read -n 1 -s -r -p "按任意键继续."
}


function wget_1000GB(){
wget -O /dev/null http://speedtest.tele2.net/1000GB.zip
read -n 1 -s -r -p "按任意键继续."
}

function webbenchmark(){
read -p "请输入链接: " webbenchmark_dl_link_url
./webBenchmark_linux_x64 -c 32 -s $webbenchmark_dl_link_url
read -n 1 -s -r -p "按任意键继续."
}

function webbenchmark1(){
./webBenchmark_linux_x64 -c 32 -s http://speedtest4.tele2.net/1000GB.zip
read -n 1 -s -r -p "按任意键继续."
}

function webbenchmark2(){
./webBenchmark_linux_x64 -c 32 -s http://la.lg.cloudc.one/1000MB.test
read -n 1 -s -r -p "按任意键继续."
}

function webbenchmark3(){
./webBenchmark_linux_x64 -c 32 -s https://looking-glass.charityhost.org/1000.mb
read -n 1 -s -r -p "按任意键继续."
}


function ServerStatus_client_restart(){
systemctl daemon-reload && systemctl restart stat_client.service
read -n 1 -s -r -p "按任意键继续."
}

function ServerStatus_client_enable(){
chmod +x ./stat_client && systemctl enable stat_client.service && systemctl start stat_client.service
read -n 1 -s -r -p "按任意键继续."
}

function ServerStatus_server_restart(){
systemctl daemon-reload && systemctl restart stat_server.service
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_rm_db(){
echo 运行后重启vnstat和ServerStatus
rm -f /var/lib/vnstat/vnstat.db
chown -R vnstat:vnstat /var/lib/vnstat
vnstat_restart
ServerStatus_client_restart
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_restart(){
service vnstat restart
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_status(){
service vnstat status
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_-h(){
vnstat -h
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_-h_custom_date_range(){
read -p "开始日期(YYYY-MM-DD): " vnstat_h_start_date
read -p "结束日期(YYYY-MM-DD): " vnstat_h_end_date
vnstat -h -b $vnstat_h_start_date -e $vnstat_h_end_date
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_-d(){
vnstat -d
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_-m(){
vnstat -m
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_-y(){
vnstat -y
read -n 1 -s -r -p "按任意键继续."
}

function vnstat_change_config(){
sed -i -E 's/^[;]*UnitMode [01]/UnitMode 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnit [01]/RateUnit 0/' /etc/vnstat.conf && sed -i -E 's/^[;]*RateUnitMode [01]/RateUnitMode 0/' /etc/vnstat.conf
chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart
read -n 1 -s -r -p "按任意键继续."
}

function vocechat_cron_info(){
cat <<EOF
crontab -e

0 8 * * * /etc/init.d/vocechat-server.sh restart
0 18 * * * /etc/init.d/vocechat-server.sh restart

如果使用 nano 编辑器：
按 Ctrl + O 保存文件。
按 Ctrl + X 退出编辑器。

如果使用 vim 编辑器：
按 Esc 键，然后输入 :wq 保存并退出。

crontab -l
确保任务已正确添加。
EOF
read -n 1 -s -r -p "按任意键继续."
}

function vocechat_restart(){
/etc/init.d/vocechat-server.sh restart
read -n 1 -s -r -p "按任意键继续."
}

function vocechat_start(){
/etc/init.d/vocechat-server.sh start
read -n 1 -s -r -p "按任意键继续."
}

function vocechat_stop(){
/etc/init.d/vocechat-server.sh stop
read -n 1 -s -r -p "按任意键继续."
}








###########################################################
#
#
#
#
#
#                         大盘鸡管理
#
#
#
#
#
###########################################################





function big_storage_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " 大盘鸡管理"
		echo "-------------------------------------------"
		echo "10.qbittorrent EE install"
		echo "11.qbittorrent EE restart"
		echo "12.qbittorrent EE stop"
		echo ""
		echo "20.syncthing install"
		echo "21.syncthing restart"
		echo "22.syncthing stop"
		echo ""
		echo "30.rclone install"
		echo "31.rclone_background_restart"
		echo "32.rclone_background_shutdown"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
		10) qBittorrent_Enhanced_Edition		
		;;
		11) qBittorrent_restart
		 ;;
                12) qBittorrent_shutdown
		 ;;
                20) syncthing_install
		 ;;
		21) syncthing_restart
		 ;;
                22) syncthing_stop
		 ;;
                30) rclone_install
		 ;;
		31) rclone_background_restart
		 ;;
                32) rclone_background_shutdown
		 ;;
	        0)
	        break
                ;;
     	esac
     done
}






function qBittorrent_Enhanced_Edition(){
mkdir -p /root/BT
echo "1.先去下载最新的linux包并解压上传到root下:"
echo "(qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip)"
echo "https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases"
echo ""
echo "2.配置文件也拷到/root/.config/qbittorrent 下面"
echo ""
echo ""
read -p "结束了?按回车键,开始写入服务并运行..."

# 改权限
chmod +x /root/qbittorrent-nox

# 写入服务文件
cat > /etc/systemd/system/qbittorrent-nox.service <<EOF
[Unit]
#Description=qbittorrent-nox
Description=qBittorrent-Enhanced-Edition-nox
#https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases
After=network.target

[Service]
User=root
Group=root
#WorkingDirectory=/root
#ExecStart=/usr/bin/qbittorrent-nox
ExecStart=/root/qbittorrent-nox
ExecReload=/bin/kill -HUP $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/qbittorrent-nox.service
EOF

# 启用并启动服务
systemctl enable qbittorrent-nox.service
systemctl start qbittorrent-nox.service

read -n 1 -s -r -p "按任意键继续."
}




function qBittorrent_restart(){
systemctl restart qbittorrent-nox.service
read -n 1 -s -r -p "按任意键继续."
}



function qBittorrent_shutdown(){
systemctl stop qbittorrent-nox.service
read -n 1 -s -r -p "按任意键继续."
}




function syncthing_install(){
            mkdir -p /root/syncthing
	        cd /root/syncthing
	        echo "手动拷贝最新版本下载地址(apt安装的不支持自动更新):"
	        echo "https://syncthing.net/downloads/" 
	        echo ""
	        read -p "请输入官网Linux最新版本下载地址: " new_syncthing_dl_addr
	        wget -P /root/syncthing $new_syncthing_dl_addr

            filename=$(basename "$new_syncthing_dl_addr")

            # 去掉最后两个扩展名 .tar.gz
            name="${filename%.*}"
            name="${name%.*}"
            # 将第一个扩展名加回来

            echo "文件名:$filename"
            echo "去除后两个扩展名=文件夹名:$name"
	        tar -zxvf $filename
	        mv /root/syncthing/$name/* /root/syncthing/
	        # 清理文件
	        rm "/root/syncthing/$filename"
	        rm -rf "/root/syncthing/$name"

            echo "准备开始首次运行生成配置文件"
            echo "稍后直接按Ctrl-C退出前台syncthing程序,继续执行脚本"
#您好,在脚本中前台运行syncthing,然后按Ctrl+C,会有以下不同情况:
#1.如果syncthing是脚本的最后一个命令,那么按Ctrl+C会同时退出syncthing和脚本。
#2.如果syncthing之后还有其他命令,那么按Ctrl+C只会退出syncthing,但脚本会继续执行后续命令。
            read -p "按回车键,开始前台运行..."
            /root/syncthing/syncthing
            
            echo "已经退出syncthing"
            echo ""
            echo "把大盘鸡配置还原到/root/.config/下面"
            echo "或者..."
            echo ""
            echo "手动进入文件夹修改配置:"
            echo "/root/.config/syncthing/config.xml"
            echo ""
            echo "将 127.0.0.1:8384 改成 0.0.0.0:32357"
            echo ""
            read -p "改好了? 按回车键继续后台运行syncthing"


            # 后台方式运行syncthing            
            #nohup /root/syncthing/syncthing &> /dev/null &
# https://blog.csdn.net/qq_41355314/article/details/116694273
cat > /etc/systemd/system/syncthing.service <<EOF
[Unit]
Description=syncthing
After=network.target

[Service]
User=root
Group=root
#Environment="RUST_BACKTRACE=1"
#WorkingDirectory=/root
ExecStart=/root/syncthing/syncthing
ExecReload=/bin/kill -HUP $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/syncthing.service

EOF
        systemctl enable syncthing.service && systemctl start syncthing.service
read -n 1 -s -r -p "按任意键继续."
}



function syncthing_restart(){
systemctl restart qbittorrent-nox.service
read -n 1 -s -r -p "按任意键继续."
}


function syncthing_stop(){
systemctl stop syncthing.service
read -n 1 -s -r -p "按任意键继续."
}




function rclone_install(){
apt install unzip -y && \
curl https://rclone.org/install.sh | bash && \
read -p "是否要运行rclone config按照提示一步步初始化配置?或者用已有文件放在 /root/.config/rclone/rclone.conf (y/n，默认为n): " enable_proxy && \
if [[ "$enable_proxy" == "y" || "$enable_proxy" == "Y" ]]; then
    rclone config
else
    echo "开始建立 /root/.config/rclone" && \
    mkdir -p /root/.config/rclone && \
    read -p "建立完毕,现在把 rclone.conf 放在 /root/.config/rclone 下面,回车后脚本会自动改权限为 600 (User: Read+Write)" && \
    rclone_conf="/root/.config/rclone/rclone.conf" && \
    if [ -f "$rclone_conf" ]; then
        chmod 600 "$rclone_conf" && \
        echo "$rclone_conf 权限改为 600"
    else
        echo "$rclone_conf 不存在!"
    fi
fi && \
read -n 1 -s -r -p "按任意键继续."
}



function rclone_background_restart(){
pkill rclone && nohup rclone rcd --rc-web-gui --rc-web-gui-no-open-browser --rc-web-gui-force-update --rc-addr :41511 --rc-user v7b8ybo3hvi3500599qv3uiqh39viuguwo29vjkg --rc-pass jkbvwrjWF[!~pl2562T#0+lmop2w6t2bw84tqptjqv9t3jh0jwjtjnopwj3tpdfgjmtm8480y4sn0-b30q-kosrrjr]37g8v --no-check-certificate --transfers=4 --ignore-existing --retries 5 &> /dev/null &
read -n 1 -s -r -p "如果改了用户名和密码, 需要退出登录/删除cookie"
}



function rclone_background_shutdown(){
pkill rclone
read -n 1 -s -r -p "按任意键继续."
}







###########################################################
#
#
#
#
#
#                       Docker管理
#
#
#
#
#
###########################################################



function docker_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo "Docker管理"
		echo "-------------------------------------------"
		echo "11.安装Docker"
		echo "12.安装Docker-compose"
		echo "13.Docker容器管理"
		echo "14.清理无用的镜像容器"
		echo ""
		echo "99.tar backup setting"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	     11)  docker_install
	     ;;
	     12)  docker_compose_install
	     ;;
	     13)  docker_container_maintain
	     ;;
	     14)  docker_clear_unused
     	     ;;
	     99) docker_tar_setting
     	     ;;
	     0)  break
     	     ;;
     	esac
     done
}






function docker_install(){
echo "开始安装Docker"; if [ -x "$(command -v docker)" ]; then echo "Docker 已安装，无需重复安装"; echo "按任意键继续!"; read -n 1 -s; else cat > /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "1k",
        "max-file": "1"
    },
    "ipv6": true,
    "fixed-cidr-v6": "fd00:dead:beef:c0::/80",
    "experimental":true,
    "ip6tables":true
}
EOF
wget -qO- get.docker.com | bash; if [ -x "$(command -v docker)" ]; then systemctl start docker; systemctl enable docker; echo "Docker 安装成功"; else echo "Docker 安装失败"; fi; fi


#注意: 安装以后才改的要重启docker
#systemctl restart docker
#json-file 日志的路径位于 /var/lib/docker/containers/container_id/container_id-json.log

#json-file 的 日志驱动支持以下选项:
#选项描述示例值max-size切割之前日志的最大大小。可取值单位为(k,m,g)， 默认为-1（表示无限制）。--log-opt max-size=10mmax-file可以存在的最大日志文件数。如果切割日志会创建超过阈值的文件数，则会删除最旧的文件。仅在max-size设置时有效。正整数。默认为1。--log-opt max-file=3labels适用于启动Docker守护程序时。此守护程序接受的以逗号分隔的与日志记录相关的标签列表。--log-opt labels=production_status,geoenv适用于启动Docker守护程序时。此守护程序接受的以逗号分隔的与日志记录相关的环境变量列表。--log-opt env=os,customerenv-regex类似于并兼容env。用于匹配与日志记录相关的环境变量的正则表达式。--log-opt env-regex=^(os|customer).compress切割的日志是否进行压缩。默认是disabled。--log-opt compress=true
read -n 1 -s -r -p "按任意键继续."	
}




function docker_compose_install(){
echo "开始安装Docker-compose"
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
read -n 1 -s -r -p "按任意键继续."
}



function docker_container_maintain(){
echo "以下是您的容器列表"; ids=($(docker ps -a --format "{{.ID}}")); images=($(docker ps -a --format "{{.Image}}")); cmds=($(docker ps -a --format "{{.Command}}")); createds=($(docker ps -a --format "{{.CreatedAt}}")); statuses=($(docker ps -a --format "{{.Status}}")); ports=($(docker ps -a --format "{{.Ports}}")); names=($(docker ps -a --format "{{.Names}}")); container_count=${#ids[@]}; printf "%-4s %-16s %-36s %-24s %-16s %-16s %-24s %s\n" "ID" "CONTAINER ID" "IMAGE" "COMMAND" "CREATED" "STATUS" "PORTS" "NAMES"; for ((i=0; i<$container_count; i++)); do printf "%-4s %-16s %-36s %-24s %-16s %-16s %-24s %s\n" "${i}" "${ids[$i]}" "${images[$i]}" "${cmds[$i]}" "${createds[$i]}" "${statuses[$i]}" "${ports[$i]}" "${names[$i]}"; done; echo -n "请输入您要操作的容器ID："; read c_id; if [ -z "$c_id" ]; then echo "无输入，按任意键继续!"; read -n 1 -s; else echo -n -e "1.重启\t2.停止\t3.设置开启自启\t4.取消开机自启\t5.删除\n请选择："; read x_id; case $x_id in 1) docker restart "${ids[$c_id]}"; echo "重启成功，按任意键继续!"; read -n 1 -s;; 2) docker stop "${ids[$c_id]}"; echo "停止成功，按任意键继续!"; read -n 1 -s;; 3) docker update --restart=always "${names[$c_id]}"; echo "设置成功，按任意键继续!"; read -n 1 -s;; 4) docker update --restart=no "${names[$c_id]}"; echo "设置成功，按任意键继续!"; read -n 1 -s;; 5) echo -n "是否要删除？ [Y/N]："; read answer; case $answer in [yY]) docker stop "${ids[$c_id]}" && docker rm "${ids[$c_id]}"; echo "删除成功，按任意键继续!"; read -n 1 -s;; *) echo "用户取消，按任意键继续!"; read -n 1 -s;; esac;; esac; fi
}

function docker_clear_unused(){
docker system prune -af --volumes
read -n 1 -s -r -p "删除成功, 按任意键继续"
}




function docker_tar_setting(){
docker stop vaultwarden
tar -zcvf /root/dockerCfg_backup-$(date +%Y%m%d_%H%M%S).tar.gz /root/.dockerCfg
docker start vaultwarden
read -n 1 -s -r -p "按任意键继续."
}







###########################################################
#
#
#
#
#
#                           IP
#
#
#
#
#
###########################################################



function ip_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " IP"
		echo "-------------------------------------------"
		echo "11.ipv4 1"
		echo "12.ipv4 2"
		echo "13.ipv4 3"
		echo "14.ipv4 优先"
		echo ""
		echo "21.ipv6_1"
		echo "22.ipv6_2"
		echo "23.ipv6_3"
		echo ""
		echo "31.测试访问优先级1"
		echo "32.测试访问优先级2"
		echo "33.测试访问优先级3"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	     11)  ipv4_1
	     ;;
	     12)  ipv4_2
	     ;;
	     13)  ipv4_3
	     ;;
	     14)  ipv4_优先
	     ;;
	     21)  ipv6_1
	     ;;
	     22)  ipv6_2
	     ;;
	     23)  ipv6_3
	     ;;
	     31)  ip_test_v4_or_v6_1
	     ;;
	     32)  ip_test_v4_or_v6_2
	     ;;
	     33)  ip_test_v4_or_v6_3
	     ;;
	     0)   break
     	     ;;
     	esac
     done
}







function ipv4_1(){
curl -4 icanhazip.com
read -n 1 -s -r -p "按任意键继续."
}
function ipv4_2(){
curl ipv4.ip.sb
read -n 1 -s -r -p "按任意键继续."
}
function ipv4_3(){
ip -4 addr show scope global
read -n 1 -s -r -p "按任意键继续."
}
function ipv4_优先(){
echo "precedence ::ffff:0:0/96 100" >>/etc/gai.conf
read -n 1 -s -r -p "按任意键继续."
}
function ipv6_1(){
curl -6 icanhazip.com
read -n 1 -s -r -p "按任意键继续."
}
function ipv6_2(){
curl ipv6.ip.sb
read -n 1 -s -r -p "按任意键继续."
}
function ipv6_3(){
ip -6 addr show scope global
read -n 1 -s -r -p "按任意键继续."
}
function ip_test_v4_or_v6_1(){
ping google.com
read -n 1 -s -r -p "按任意键继续."
}
function ip_test_v4_or_v6_2(){
curl -v http://google.com
read -n 1 -s -r -p "按任意键继续."
}
function ip_test_v4_or_v6_3(){
getent ahosts google.com
read -n 1 -s -r -p "按任意键继续."
}






###########################################################
#
#
#
#
#
#                          快捷命令
#
#
#
#
#
###########################################################




function quickcmd_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " 快捷命令"
		echo "-------------------------------------------"
		echo "1.建立任意深度的文件夹"
		echo "2.压缩任意目录,保存到/root下"
		
		

		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择:"
		read aNum2
		case $aNum2 in
		1)  echo ""
#			mkdir -p /root/.cache/rclone-temp &>/dev/null
            read -p "请输入文件夹全路径(如/root/a/b/c/d): " new_folder
			mkdir -p $new_folder
			read -n 1 -s -r -p "按任意键继续."
	     ;;
	     2) read -p "请输入要压缩的目录完整路径:" inputDir 
# 校验路径是否存在
if [ ! -d "$inputDir" ]; then
  echo "错误:目录 $inputDir 不存在!"
  exit 1
fi
#进入目录,避免目录本身也被打包进去
cd $inputDir
# 获取输入目录的基本名作为文件名
fileName=$(basename "$inputDir")
# 构建压缩命令
cmd="tar -zcvf ${fileName}.tar.gz *"
# 执行压缩命令
echo "正在压缩 $inputDir" 
eval $cmd
mv $fileName.tar.gz /root
cd /root

#===下面的方法会造成目录一层也被压缩进去
# 构建压缩命令 
#cmd="tar -zcvf /root/${fileName}.tar.gz -C $(dirname "$inputDir") -c ${fileName}"
# 执行压缩命令
#echo "正在压缩 $inputDir" 
#eval $cmd
read -n 1 -s -r -p "压缩完成!"
	     ;;
	     0)
	     	break
     	 ;;
     	esac
     done
}











###########################################################
#
#
#
#
#
#                       dd系统
#
#
#
#
#
###########################################################





function dd_sys_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " 新机必备"
		echo "-------------------------------------------"
		echo "dd11.KVM VPS安装debian11 密码741963 端口32641"
		echo "dd12.KVM VPS安装debian12 密码741963 端口32641"
		echo "w10.Win10 LTSC JA-JP"

		echo ""
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
		 dd11) wget https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh && chmod a+x InstallNET.sh && bash InstallNET.sh -debian 12 -pwd '741963' -port "32641"
		    read -n 1 -s -r -p "按任意键开始reboot!"
		    reboot
	     ;;
		 dd12) wget https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh && chmod a+x InstallNET.sh && bash InstallNET.sh -debian 12 -pwd '741963' -port "32641"
		    read -n 1 -s -r -p "按任意键开始reboot!"
		    reboot
	     ;;
	     w10) curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh windows --image-name='Windows 10 Enterprise LTSC 2021' --iso 'https://drive.massgrave.dev/ja-jp_windows_10_enterprise_ltsc_2021_x64_dvd_ef58c6a1.iso'
		    read -n 1 -s -r -p "按任意键开始reboot!"
		    reboot
	     ;;


	     0)
	     	break
     	 ;;
     	esac
     done
}














###########################################################
#
#
#
#
#
#                       主菜单(需要放最后)
#
#
#
#
#
###########################################################

function menu(){
	clear
	echo "-------------------------------------------"
	echo "自用装机脚本"
	echo ""
	echo "基于 Af_Box 常用脚本工具箱 v0.0.2 修改"
	echo "https://github.com/aafang/afbox"
	echo "https://raw.githubusercontent.com/aafang/afbox/main/afbox.sh"
	echo "-------------------------------------------"
	echo "1.Local"
	echo "2.test"
	echo "3.新机必备"	
	echo "4.Soft"
	echo "5.大盘鸡管理"
	echo "6.Docker管理"	
	#echo "7."
	#echo "8."
	#echo "9."
	echo ""
	echo "i.IP"
	echo "q.快捷命令"	
	echo "dd.dd系统"
	echo ""
	echo "=========================="
	echo ""
	echo ""
	echo "-------------------------------------------"
	echo "若中途有输入错误，按ctrl+backpace删除"
	echo "-------------------------------------------"
}


# 先定义所有 function，最后处理参数
if [ $# -gt 0 ]; then
    function_name=$1

    # 确保函数已经定义
    if typeset -f "$function_name" > /dev/null; then
        "$function_name"  # 直接执行
        exit 0
    else
        echo "❌ 错误：未找到函数 $function_name"
        exit 1
    fi
fi

# 交互式菜单，只有在没有参数传入时才会进入
while true
do
	menu
	echo -n "请选择："
	read aNum1
	case $aNum1 in
     1)  local_m
     ;;
     2)  test_m
     ;;
     3)  newdevice_m
     ;;
     4)  soft_m
     ;;
     5)  big_storage_m
     ;;
     6)  docker_m
     ;;
     

     i)  ip_m
     ;;
     q)  quickcmd_m
     ;;
     dd) dd_sys_m
     ;;
     0)  echo "用户选择退出"
	     break
     ;;
     *)  echo -e "${Font_Red}输入错误，请重新输入${Font_Suffix}"
     	sleep 2
     ;;
     esac
done













<<EOF


############################################################
############################################################
############################################################




###########################################################
#
#
#
#
#
#                       aaaaaaaaaa
#
#
#
#
#
###########################################################



function bbr_m(){
	while true
	do
		clear
		echo "-------------------------------------------"
		echo " 加速管理"
		echo "-------------------------------------------"
		echo "111111111.卸载内核版"
		echo "22222222.不卸载内核版"
		echo ""
		echo "0.返回主菜单"
		echo "-------------------------------------------"
		echo -n "请选择："
		read aNum2
		case $aNum2 in
	     1)  
	     ;;
	     2)  
	     ;;
	     0)
	     break
     	     ;;
     	esac
     done
}







function xxx(){

read -n 1 -s -r -p "按任意键继续."
}




function xxx(){

read -n 1 -s -r -p "按任意键继续."
}






测试80端口是否被占用
ss -ltnp | grep ':80'
netstat -tlnp | grep ':80'
lsof -i :80
上面的没有返回说明没占用

curl -I http://localhost
如果有服务监听 80 端口，会返回 HTTP 头；否则会报错。


=======================================================

带参运行列表




./MyMenu.sh ffmpeg_hwacc
./MyMenu.sh list_gen
./MyMenu.sh list_gen__less_than_12h
./MyMenu.sh chapter_gen
./MyMenu.sh convert
./MyMenu.sh convert_fake4k
./MyMenu.sh convert_CPU
./MyMenu.sh convert_CPU_fake4k
./MyMenu.sh convert+chapter
./MyMenu.sh convert+chapter_fake4k
./MyMenu.sh convert+chapter_CPU
./MyMenu.sh convert+chapter_CPU_fake4k
./MyMenu.sh del_root_mp4_from__outfiles_txt
./MyMenu.sh del_root_mp4_with_out_x_txt
./MyMenu.sh fake_4k60__h264_cpu
./MyMenu.sh fake_4k60__h264_vaapi
./MyMenu.sh fake_4k60__h265_vaapi
./MyMenu.sh vp9
./MyMenu.sh vp9_vaapi
./MyMenu.sh x264
./MyMenu.sh x264_vaapi
./MyMenu.sh x265
./MyMenu.sh x265_vaapi


./MyMenu.sh N305_auto_iptable_systemd
./MyMenu.sh N305_ip_route
./MyMenu.sh mihomo_debug_run
./MyMenu.sh mihomo_restart
./MyMenu.sh mihomo_status
./MyMenu.sh mihomo_stop


./MyMenu.sh Backtrace_test
./MyMenu.sh io_speed_check
./MyMenu.sh ip_quality_check
./MyMenu.sh stream_unlock_test
./MyMenu.sh stream_unlock_test_1
./MyMenu.sh nodeseek_test_script
./MyMenu.sh speedtest
./MyMenu.sh test_port_80
./MyMenu.sh fill_space
./MyMenu.sh net_quality_test


./MyMenu.sh view_curr_BBR_info
./MyMenu.sh BBR_auto_set
./MyMenu.sh KVM_Key_Port
./MyMenu.sh LXC_use
./MyMenu.sh KVM_Key_Only
./MyMenu.sh KVM_Optimize_Only
./MyMenu.sh warp
./MyMenu.sh warp_v4
./MyMenu.sh warp_v6
./MyMenu.sh warp_u
./MyMenu.sh warpgo
./MyMenu.sh warpgo_v4
./MyMenu.sh warpgo_v6
./MyMenu.sh warpgo_u
./MyMenu.sh ladder_vasma
./MyMenu.sh ladder_old
./MyMenu.sh ladder_fscarmen
./MyMenu.sh hy2_v4
./MyMenu.sh hy1_hy2
./MyMenu.sh openssh_update


./MyMenu.sh tmux_install_with_user_config
./MyMenu.sh tmux_ONLY_user_config
./MyMenu.sh tmux_attach_-t_0
./MyMenu.sh tmux_attach_-t_1
./MyMenu.sh tmux_attach_-t_2
./MyMenu.sh tmux_attach_-t_3
./MyMenu.sh tmux_attach_-t_4
./MyMenu.sh tmux_attach_-t_5
./MyMenu.sh tmux_attach_-t_6
./MyMenu.sh tmux_attach_-t_7
./MyMenu.sh tmux_attach_-t_8
./MyMenu.sh tmux_attach_-t_9
./MyMenu.sh tmux_new_-s_0
./MyMenu.sh tmux_new_-s_1
./MyMenu.sh tmux_new_-s_2
./MyMenu.sh tmux_new_-s_3
./MyMenu.sh tmux_new_-s_4
./MyMenu.sh tmux_new_-s_5
./MyMenu.sh tmux_new_-s_6
./MyMenu.sh tmux_new_-s_7
./MyMenu.sh tmux_new_-s_8
./MyMenu.sh tmux_new_-s_9
./MyMenu.sh openlist_install
./MyMenu.sh openlist_restart
./MyMenu.sh openlist_stop
./MyMenu.sh openlist_status
./MyMenu.sh openlist_update
./MyMenu.sh yt-dlp-U
./MyMenu.sh yt-dlp-DL
./MyMenu.sh yt-dlp-DL_shortname
./MyMenu.sh curl_1000GB
./MyMenu.sh wget_1000GB
./MyMenu.sh webbenchmark
./MyMenu.sh webbenchmark1
./MyMenu.sh webbenchmark2
./MyMenu.sh webbenchmark3
./MyMenu.sh ServerStatus_client_restart
./MyMenu.sh ServerStatus_client_enable
./MyMenu.sh ServerStatus_server_restart
./MyMenu.sh vnstat_rm_db
./MyMenu.sh vnstat_restart
./MyMenu.sh vnstat_status
./MyMenu.sh vnstat_-h_custom_date_range
./MyMenu.sh vnstat_-h
./MyMenu.sh vnstat_-d
./MyMenu.sh vnstat_-m
./MyMenu.sh vnstat_-y
./MyMenu.sh vnstat_change_config
./MyMenu.sh vocechat_cron_info
./MyMenu.sh vocechat_restart
./MyMenu.sh vocechat_start
./MyMenu.sh vocechat_stop


./MyMenu.sh qBittorrent_Enhanced_Edition
./MyMenu.sh qBittorrent_restart
./MyMenu.sh qBittorrent_shutdown
./MyMenu.sh syncthing_install
./MyMenu.sh syncthing_restart
./MyMenu.sh syncthing_stop
./MyMenu.sh rclone_install
./MyMenu.sh rclone_background_restart
./MyMenu.sh rclone_background_shutdown


./MyMenu.sh docker_install
./MyMenu.sh docker_compose_install
./MyMenu.sh docker_container_maintain
./MyMenu.sh docker_clear_unused
./MyMenu.sh docker_tar_setting


./MyMenu.sh ipv4_1
./MyMenu.sh ipv4_2
./MyMenu.sh ipv4_3
./MyMenu.sh ipv4_优先
./MyMenu.sh ipv6_1
./MyMenu.sh ipv6_2
./MyMenu.sh ipv6_3
./MyMenu.sh ip_test_v4_or_v6_1
./MyMenu.sh ip_test_v4_or_v6_2
./MyMenu.sh ip_test_v4_or_v6_3



./MyMenu.sh quickcmd_m

./MyMenu.sh dd_sys_m









=============================Changelog==============================


v0.02
250903
偷懒了很久,终于还是把openlist代替了alist


v0.01
250322
在Mymenu.py摸索的基础上,最终还是决定改回sh的脚本,python实在有太多不可控的地方了














补充网络调用说明:

你现在本地用的是：

. ./MyMenu.sh openlist_restart


意思是 source 脚本 然后执行函数。

如果脚本放在网上（例如 aaa.com/MyMenu.sh），你要做到“一步下载并执行函数”，就可以这样写：

✅ 方法 1：curl + bash + 参数
bash -c "$(curl -fsSL aaa.com/MyMenu.sh)" openlist_restart


这样 curl 下载到的脚本内容会作为 bash 脚本执行，后面的 openlist_restart 就是传给脚本的参数。
但注意：如果你的 MyMenu.sh 是定义了函数，而不是直接根据 $1 去调用函数，那这个方法不一定能直接执行函数。

✅ 方法 2：下载后用 source 执行函数（推荐）
curl -fsSL aaa.com/MyMenu.sh -o /tmp/MyMenu.sh \
  && . /tmp/MyMenu.sh \
  && openlist_restart


逻辑是：
下载脚本到 /tmp
source 脚本，让函数定义加载到当前 shell
直接调用 openlist_restart
这个和你本地 . ./MyMenu.sh openlist_restart 效果最接近。

✅ 方法 3：curl 后直接 pipe 给当前 shell（inline）
eval "$(curl -fsSL aaa.com/MyMenu.sh)" 
openlist_restart

这样脚本内容会被当成 当前 shell 的定义（包含函数），然后你就能直接用 openlist_restart。

🔍 总结：

如果脚本是 通过参数判断执行什么 → 用 方法 1。

如果脚本只是定义函数，你要手动调用 → 用 方法 2 或方法 3。


EOF






