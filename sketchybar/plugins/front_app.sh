#!/bin/bash

case "$1" in
"WhatsApp")
  icon_result="􀌾"
  ;;
"Terminal" | "ITerm" | "kitty" | "Alacritty" | "Hyper" | "iTerm2" | "终端" | "WezTerm")
  icon_result="􀆍"
  ;;
"Code" | "Visual Studio Code" | "VSCodium")
  icon_result="􀤙"
  ;;
"Safari" | "Safari Browser" | "Safari Technology Preview")
  icon_result="􀤇"
  ;;
"Google Chrome" | "Chromium" | "Google Chrome Canary")
  icon_result="􀼺"
  ;;
"Firefox" | "Firefox Developer Edition" | "Firefox Nightly")
  icon_result="􀤆"
  ;;
"Finder" | "访达")
  icon_result="􀉟"
  ;;
"Mail" | "Apple Mail" | "Airmail" | "Spark")
  icon_result="􀍜"
  ;;
"Messages" | "iMessage" | "信息")
  icon_result="􀌥"
  ;;
"Slack")
  icon_result="􀑮"
  ;;
"Spotify")
  icon_result="􀼱"
  ;;
"Discord" | "Discord Canary" | "Discord PTB")
  icon_result="􀌆"
  ;;
"Telegram")
  icon_result="􀐵"
  ;;
"Calendar" | "日历" | "Fantastical" | "Cron" | "Amie")
  icon_result="􀉉"
  ;;
"Notes" | "备忘录")
  icon_result="􀓕"
  ;;
"Notion")
  icon_result="􀘡"
  ;;
"Xcode")
  icon_result="􀨋"
  ;;
"System Preferences" | "System Settings" | "系统设置")
  icon_result="􀣩"
  ;;
"Photos" | "照片")
  icon_result="􀑦"
  ;;
"Preview" | "预览" | "PDF")
  icon_result="􀉨"
  ;;
"1Password")
  icon_result="􀑰"
  ;;
"Obsidian")
  icon_result="􀌚"
  ;;
"Sublime Text")
  icon_result="􀀃"
  ;;
"GitHub Desktop")
  icon_result="􀂓"
  ;;
"IntelliJ IDEA" | "WebStorm" | "PyCharm")
  icon_result="􀤙"
  ;;
"Docker" | "Docker Desktop")
  icon_result="􀬏"
  ;;
"VLC")
  icon_result="􀍚"
  ;;
"Zoom")
  icon_result="􀬁"
  ;;
"Music" | "iTunes" | "音乐")
  icon_result="􀑪"
  ;;
"App Store")
  icon_result="􀐬"
  ;;
"Microsoft Word")
  icon_result="􀚍"
  ;;
"Microsoft Excel")
  icon_result="􀚎"
  ;;
"Microsoft PowerPoint")
  icon_result="􀚏"
  ;;
"Microsoft Teams")
  icon_result="􀜀"
  ;;
"Bear")
  icon_result="􀎮"
  ;;
"FaceTime" | "FaceTime 通话")
  icon_result="􀵴"
  ;;
"Keynote" | "Keynote 讲演")
  icon_result="􀚗"
  ;;
"Pages" | "Pages 文稿")
  icon_result="􀚗"
  ;;
"Numbers" | "Numbers 表格")
  icon_result="􀚗"
  ;;
"Brave Browser")
  icon_result="􀎭"
  ;;
"Microsoft Edge")
  icon_result="􀎭"
  ;;
"Reminders" | "提醒事项")
  icon_result="􀒉"
  ;;
"Arc")
  icon_result="􀎭"
  ;;
*)
  icon_result="􀏜"
  ;;
esac
echo $icon_result