#!/bin/bash
# Facebook Video Downloader for Termux
# Created by AI Assistant

# Warna untuk tampilan
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
purple='\033[1;35m'
cyan='\033[1;36m'
white='\033[1;37m'
reset='\033[0m'

# Banner
clear
echo -e "${cyan}╔══════════════════════════════════════════════════════╗${reset}"
echo -e "${cyan}║${reset}     ${green}FACEBOOK VIDEO DOWNLOADER FOR TERMUX${reset}      ${cyan}║${reset}"
echo -e "${cyan}║${reset}                ${purple}Version 2.0${reset}                     ${cyan}║${reset}"
echo -e "${cyan}╚══════════════════════════════════════════════════════╝${reset}"
echo ""

# Fungsi instalasi
install_tools() {
    echo -e "${yellow}[*] Memperbarui package list...${reset}"
    apt update && apt upgrade -y
    
    echo -e "${yellow}[*] Menginstall dependencies...${reset}"
    apt install -y python python-pip php git curl wget ffmpeg
    
    echo -e "${yellow}[*] Menginstall yt-dlp (youtube-dl terbaru)...${reset}"
    pip install yt-dlp
    
    echo -e "${green}[✓] Instalasi selesai!${reset}"
}

# Fungsi download dengan yt-dlp
download_ytdlp() {
    echo -e "${cyan}[*] Masukkan URL video Facebook:${reset}"
    read -p "> " url
    
    if [[ -z "$url" ]]; then
        echo -e "${red}[!] URL tidak boleh kosong!${reset}"
        return 1
    fi
    
    echo -e "${yellow}[*] Mendownload video...${reset}"
    
    # Buat folder download
    mkdir -p ~/facebook-downloads
    
    # Download video
    cd ~/facebook-downloads
    yt-dlp "$url" -o "%(title)s.%(ext)s"
    
    if [[ $? -eq 0 ]]; then
        echo -e "${green}[✓] Download selesai!${reset}"
        echo -e "${cyan}[*] Video tersimpan di: ~/facebook-downloads/${reset}"
        
        # Tanya apakah ingin pindahkan ke internal storage
        echo -e "${yellow}[?] Pindahkan ke Internal Storage? (y/n)${reset}"
        read -p "> " move_choice
        
        if [[ "$move_choice" == "y" || "$move_choice" == "Y" ]]; then
            mv ~/facebook-downloads/* /sdcard/Download/ 2>/dev/null
            echo -e "${green}[✓] Video dipindahkan ke Internal Storage/Download/${reset}"
        fi
    else
        echo -e "${red}[!] Gagal mendownload video!${reset}"
    fi
}

# Fungsi download dengan PHP script
download_php() {
    echo -e "${yellow}[*] Menginstall PHP Facebook Downloader...${reset}"
    
    # Clone repository
    cd ~
    git clone https://github.com/Tuhinshubhra/fbvid.git
    
    if [[ -d "fbvid" ]]; then
        cd fbvid
        
        echo -e "${cyan}[*] Masukkan URL video Facebook:${reset}"
        read -p "> " url
        
        echo -e "${yellow}[*] Mendownload video...${reset}"
        php fb.php "$url"
        
        echo -e "${green}[✓] Download selesai!${reset}"
    else
        echo -e "${red}[!] Gagal menginstall PHP downloader!${reset}"
    fi
}

# Fungsi download dengan Python
download_python() {
    echo -e "${yellow}[*] Menginstall Python Facebook Downloader...${reset}"
    
    # Clone repository
    cd ~
    git clone https://github.com/TermuxHackz/Facebook-Video-Downloader.git
    
    if [[ -d "Facebook-Video-Downloader" ]]; then
        cd Facebook-Video-Downloader
        
        # Install requirements
        pip install -r requirements.txt
        
        echo -e "${cyan}[*] Masukkan URL video Facebook:${reset}"
        read -p "> " url
        
        echo -e "${yellow}[*] Mendownload video...${reset}"
        python downloader.py "$url"
        
        echo -e "${green}[✓] Download selesai!${reset}"
    else
        echo -e "${red}[!] Gagal menginstall Python downloader!${reset}"
    fi
}

# Menu utama
show_menu() {
    while true; do
        echo -e "${blue}╔══════════════════════════════════════╗${reset}"
        echo -e "${blue}║${reset}     ${cyan}PILIH METODE DOWNLOAD:${reset}          ${blue}║${reset}"
        echo -e "${blue}╠══════════════════════════════════════╣${reset}"
        echo -e "${blue}║${reset} 1. ${green}Download dengan yt-dlp${reset}          ${blue}║${reset}"
        echo -e "${blue}║${reset} 2. ${green}Download dengan PHP${reset}             ${blue}║${reset}"
        echo -e "${blue}║${reset} 3. ${green}Download dengan Python${reset}          ${blue}║${reset}"
        echo -e "${blue}║${reset} 4. ${yellow}Install semua tools${reset}             ${blue}║${reset}"
        echo -e "${blue}║${reset} 5. ${red}Keluar${reset}                          ${blue}║${reset}"
        echo -e "${blue}╚══════════════════════════════════════╝${reset}"
        echo ""
        
        read -p "Pilih [1-5]: " choice
        
        case $choice in
            1)
                download_ytdlp
                ;;
            2)
                download_php
                ;;
            3)
                download_python
                ;;
            4)
                install_tools
                ;;
            5)
                echo -e "${green}[✓] Terima kasih telah menggunakan script ini!${reset}"
                exit 0
                ;;
            *)
                echo -e "${red}[!] Pilihan tidak valid!${reset}"
                ;;
        esac
        
        echo ""
        echo -e "${yellow}[*] Tekan Enter untuk melanjutkan...${reset}"
        read
        clear
    done
}

# Cek apakah tools sudah terinstall
check_tools() {
    echo -e "${yellow}[*] Mengecek instalasi tools...${reset}"
    
    tools_missing=false
    
    if ! command -v python &> /dev/null; then
        echo -e "${red}[!] Python belum terinstall${reset}"
        tools_missing=true
    fi
    
    if ! command -v php &> /dev/null; then
        echo -e "${red}[!] PHP belum terinstall${reset}"
        tools_missing=true
    fi
    
    if ! command -v yt-dlp &> /dev/null; then
        echo -e "${red}[!] yt-dlp belum terinstall${reset}"
        tools_missing=true
    fi
    
    if [[ "$tools_missing" == true ]]; then
        echo -e "${yellow}[*] Beberapa tools belum terinstall.${reset}"
        echo -e "${cyan}[?] Install semua tools sekarang? (y/n)${reset}"
        read -p "> " install_choice
        
        if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
            install_tools
        fi
    else
        echo -e "${green}[✓] Semua tools sudah terinstall!${reset}"
    fi
    
    echo ""
}

# Main program
main() {
    check_tools
    show_menu
}

# Jalankan script
main
