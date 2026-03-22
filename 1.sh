#!/data/data/com.termux/files/usr/bin/bash
# Tool: Xhack Net
# Original Author: NX AL IMRAN S (modified)
# Facebook: https://www.nxalimrans.bloger.com

# --- Color Codes ---
r='\033[1;91m'
g='\033[1;92m'
y='\033[1;93m'
b='\033[1;94m'
c='\033[1;96m'
n='\033[0m'

# --- Symbols ---
A="[${g}+${n}]"
C="[${c}/${n}]"
E="[${r}x${n}]"
I="[${y}!${n}]"

handle_password() {
    local correct_pass="123456789"
    while true; do
        clear
        echo -e "${b}╭═══════════════════════════════════════════════╮${n}"
        echo -e "${b}║             ${c}Welcome to Xhack Net              ${b}║${n}"
        echo -e "${b}╰═══════════════════════════════════════════════╯${n}"
        echo
        echo -e "${I} ${y}This tool is password protected.${n}"
        echo
        read -s -p "$(echo -e "${g}[?] Enter Password : ${n}")" user_pass
        echo

        if [ "$user_pass" == "$correct_pass" ]; then
            echo -e "${A} ${g}Password Correct! Proceeding...${n}"
            echo -e "${A} ${c}Opening Author's YouTube Channel...${n}"
            # Fix: use termux-open if available
            if command -v termux-open &>/dev/null; then
                termux-open "https://youtube.com/@hdshortvideo69"
            else
                echo -e "${E} ${r}termux-open not found. Please open the link manually: https://youtube.com/@hdshortvideo69${n}"
            fi
            sleep 3
            break
        else
            echo -e "${E} ${r}Wrong Password! Please try again.${n}"
            echo -e "${I} ${c}Find Password here: ${y}https://youtu.be/Z174GLaBZo4${n}"
            sleep 3
        fi
    done
}

# --- Main Banner Function during installation ---
main_banner() {
    clear
    echo -e "   ${y}██╗  ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗"
    echo -e "   ${y}██║  ██║██║  ██║██╔══██╗██╔════╝██║ ██╔╝"
    echo -e "   ${y}███████║███████║███████║██║     █████╔╝ "
    echo -e "   ${y}██╔══██║██╔══██║██╔══██║██║     ██╔═██╗ "
    echo -e "   ${y}██║  ██║██║  ██║██║  ██║╚██████╗██║  ██╗"
    echo -e "   ${y}╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${y}   +-+-+-+-+-+-+-+-+-+-+-+-+-+"
    echo -e "${c}   |X|H|A|C|K| |N|E|T|"
    echo -e "${y}   +-+-+-+-+-+-+-+-+-+-+-+-+-+${n}"
    echo
    echo -e "${b}╭══ ${g}〄 ${y}Xhack Net ${g}〄"
    echo -e "${b}┃❁ ${g}Author  : ${y}NX AL IMRAN S"
    echo -e "${b}┃❁ ${g}Website : ${y}nxalimrans.bloger.com"
    echo -e "${b}╰┈➤ ${g} Welcome to the installer!${n}"
    echo
}

# --- Improved spinner with kill -0 ---
spinner() {
    local pid=$1
    local msg=$2
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " \r ${A} ${c}%s... [%s]  " "$msg" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf " \r ${A} ${g}%s... [Done]${n}\n" "$msg"
}

# --- Function to install all dependencies ---
install_dependencies() {
    echo -e "${A} ${y}Updating package lists...${n}"
    pkg update -y > /dev/null 2>&1 &
    spinner $! "Updating"

    echo -e "${A} ${y}Installing required packages...${n}"
    local packages=("git" "zsh" "figlet" "ruby" "ncurses-utils" "lsd" "nano")
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            pkg install "$package" -y > /dev/null 2>&1 &
            spinner $! "Installing $package"
        fi
    done

    if ! command -v lolcat &> /dev/null; then
        gem install lolcat > /dev/null 2>&1 &
        spinner $! "Installing lolcat"
    fi
    echo -e "${A} ${g}All dependencies are installed successfully!${n}"
    sleep 1
}

# --- Function to install font from local file ---
install_local_font() {
    echo -e "${A} ${c}Looking for local 'nxfont.ttf' file...${n}"
    local source_font="nxfont.ttf"
    local dest_path="$HOME/.termux/nxfont.ttf"

    if [ -f "$source_font" ]; then
        echo -e "${A} ${g}Found 'nxfont.ttf'. Installing it...${n}"
        mkdir -p "$HOME/.termux"
        cp "$source_font" "$dest_path"

        if [ -s "$dest_path" ]; then
            echo -e "${A} ${g}Font installed successfully from your local file.${n}"
            command -v termux-reload-settings &>/dev/null && termux-reload-settings
        else
            echo -e "${E} ${r}Failed to copy font. Icons may not appear correctly.${n}"
        fi
    else
        echo -e "${E} ${r}Error: 'nxfont.ttf' not found."
        echo -e "${y}   Please place your font file in the same directory as this script and name it 'nxfont.ttf'.${n}"
        # Not exiting because it's not critical
    fi
    sleep 1
}

# --- Main Setup Function ---
setup_environment() {
    main_banner
    echo -e "${I} ${c}This script will configure your Termux shell.${n}"
    echo

    # --- Get User Input ---
    local BANNER_TEXT
    while true; do
        read -p "$(echo -e "${g}[+] Enter your Banner Text (1-8 chars): ${y}")" BANNER_TEXT
        if [[ ${#BANNER_TEXT} -ge 1 && ${#BANNER_TEXT} -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Error: Name must be between 1 and 8 characters. Please try again.${n}"
        fi
    done

    local NICKNAME
    read -p "$(echo -e "${g}[+] Enter your Nickname for the prompt: ${y}")" NICKNAME
    echo

    # --- Install Oh My Zsh and plugins ---
    echo -e "${A} ${c}Installing Oh My Zsh and plugins...${n}"
    {
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        fi
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
    } &> /dev/null

    # --- Create .zshrc file ---
    echo -e "${A} ${c}Creating '.zshrc' configuration file...${n}"
    cat <<EOF > "$HOME/.zshrc"
# Path to your oh-my-zsh installation.
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="xhacknet"

export NICKNAME="${NICKNAME}"
export BANNER_TEXT="${BANNER_TEXT}"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source \$ZSH/oh-my-zsh.sh

# --- Custom aliases ---
alias cls='clear'
alias update='pkg update && pkg upgrade'
alias ls='lsd --icon=auto'
alias la='lsd -a --icon=auto'
alias ll='lsd -l --icon=auto'

# --- Improved Banner Function ---
show_banner() {
    clear
    tput civis # Hide cursor

    local width=\$(tput cols)
    local border_color='\033[1;36m'
    local nc='\033[0m'
    local welcome_color='\033[1;92m'
    local name_color='\033[1;93m'

    # 1. Draw the box
    echo -e "\${border_color}╔\$(printf '═%.0s' \$(seq 1 \$((width-2))))╗\${nc}"
    for i in {1..7}; do
        echo -e "\${border_color}║\$(printf ' %.0s' \$(seq 1 \$((width-2))))║\${nc}"
    done
    local tool_info="[Σ] Xhack Net"
    local info_len=\${#tool_info}
    local padding=\$(( (width - 2 - info_len) / 2 ))
    echo -e "\${border_color}║\$(printf ' %.0s' \$(seq 1 \$padding))\${welcome_color}\${tool_info}\${border_color}\$(printf ' %.0s' \$(seq 1 \$((width - 2 - padding - info_len))))║\${nc}"
    echo -e "\${border_color}╚\$(printf '═%.0s' \$(seq 1 \$((width-2))))╝\${nc}"

    # 2. Position cursor and print banner inside the box
    tput cup 2 1
    figlet -c -f ASCII-Shadow -w \$((width - 4)) "\${BANNER_TEXT}" | lolcat

    # 3. Position cursor below the box and print welcome message
    tput cup 11 0
    echo -e " \${welcome_color}Welcome to Xhack Net, '\${name_color}\${BANNER_TEXT}\${welcome_color}'!${nc}"
    echo

    tput cnorm # Restore cursor
}

# --- Pre-command function for the new multi-line prompt ---
precmd() {
    echo -e "\n\033[1;36m┏─[\033[1;34m\${NICKNAME}\033[1;33m〄\033[1;32m\${BANNER_TEXT}\033[1;36m]-[\$(pwd | sed "s!^/data/data/com.termux/files/home!~!")]"
    echo -en "\033[1;36m┗"
}

show_banner
EOF

    # --- Create the custom theme file ---
    echo -e "${A} ${c}Creating custom theme 'xhacknet'...${n}"
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    cat <<EOF > "$HOME/.oh-my-zsh/custom/themes/xhacknet.zsh-theme"
# Xhack Net Custom Theme (Second line of prompt)
PROMPT='%F{yellow}❯%F{blue}❯%F{cyan}❯%f '
EOF

    # --- Install Figlet Font ---
    echo -e "${A} ${c}Installing required font for banner...${n}"
    mkdir -p "$PREFIX/share/figlet"
    cat <<'EOF' > "$PREFIX/share/figlet/ASCII-Shadow.flf"
flf2a$ 7 7 13 0 7 0 64 0
Font Author: ?

More Info:

https://web.archive.org/web/20120819044459/http://www.roysac.com/thedrawfonts-tdf.asp

FIGFont created with: http://patorjk.com/figfont-editor
$  $@
$  $@
$  $@
$  $@
$  $@
$  $@
$  $@@
██╗@
██║@
██║@
╚═╝@
██╗@
╚═╝@
   @@
@
@
@
@
@
@
@@
 ██╗ ██╗ @
████████╗@
╚██╔═██╔╝@
████████╗@
╚██╔═██╔╝@
 ╚═╝ ╚═╝ @
         @@
▄▄███▄▄·@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚═▀▀▀══╝@
        @@
██╗ ██╗@
╚═╝██╔╝@
  ██╔╝ @
 ██╔╝  @
██╔╝██╗@
╚═╝ ╚═╝@
       @@
   ██╗   @
   ██║   @
████████╗@
██╔═██╔═╝@
██████║  @
╚═════╝  @
         @@
@
@
@
@
@
@
@@
 ██╗@
██╔╝@
██║ @
██║ @
╚██╗@
 ╚═╝@
    @@
██╗ @
╚██╗@
 ██║@
 ██║@
██╔╝@
╚═╝ @
    @@
      @
▄ ██╗▄@
 ████╗@
▀╚██╔▀@
  ╚═╝ @
      @
      @@
@
@
@
@
@
@
@@
   @
   @
   @
   @
▄█╗@
╚═╝@
   @@
      @
      @
█████╗@
╚════╝@
      @
      @
      @@
   @
   @
   @
   @
██╗@
╚═╝@
   @@
    ██╗@
   ██╔╝@
  ██╔╝ @
 ██╔╝  @
██╔╝   @
╚═╝    @
       @@
 ██████╗ @
██╔═████╗@
██║██╔██║@
████╔╝██║@
╚██████╔╝@
 ╚═════╝ @
         @@
 ██╗@
███║@
╚██║@
 ██║@
 ██║@
 ╚═╝@
    @@
██████╗ @
╚════██╗@
 █████╔╝@
██╔═══╝ @
███████╗@
╚══════╝@
        @@
██████╗ @
╚════██╗@
 █████╔╝@
 ╚═══██╗@
██████╔╝@
╚═════╝ @
        @@
██╗  ██╗@
██║  ██║@
███████║@
╚════██║@
     ██║@
     ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
 ██████╗ @
██╔════╝ @
███████╗ @
██╔═══██╗@
╚██████╔╝@
 ╚═════╝ @
         @@
███████╗@
╚════██║@
    ██╔╝@
   ██╔╝ @
   ██║  @
   ╚═╝  @
        @@
 █████╗ @
██╔══██╗@
╚█████╔╝@
██╔══██╗@
╚█████╔╝@
 ╚════╝ @
        @@
 █████╗ @
██╔══██╗@
╚██████║@
 ╚═══██║@
 █████╔╝@
 ╚════╝ @
        @@
   @
██╗@
╚═╝@
██╗@
╚═╝@
   @
   @@
   @
██╗@
╚═╝@
▄█╗@
▀═╝@
   @
   @@
  ██╗@
 ██╔╝@
██╔╝ @
╚██╗ @
 ╚██╗@
  ╚═╝@
     @@
@
@
@
@
@
@
@@
██╗  @
╚██╗ @
 ╚██╗@
 ██╔╝@
██╔╝ @
╚═╝  @
     @@
██████╗ @
╚════██╗@
  ▄███╔╝@
  ▀▀══╝ @
  ██╗   @
  ╚═╝   @
        @@
 ██████╗ @
██╔═══██╗@
██║██╗██║@
██║██║██║@
╚█║████╔╝@
 ╚╝╚═══╝ @
         @@
 █████╗ @
██╔══██╗@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██████╔╝@
╚═════╝ @
        @@
 ██████╗@
██╔════╝@
██║     @
██║     @
╚██████╗@
 ╚═════╝@
        @@
██████╗ @
██╔══██╗@
██║  ██║@
██║  ██║@
██████╔╝@
╚═════╝ @
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
███████╗@
╚══════╝@
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔════╝ @
██║  ███╗@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗  ██╗@
██║  ██║@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██╗@
██║@
██║@
██║@
██║@
╚═╝@
   @@
     ██╗@
     ██║@
     ██║@
██   ██║@
╚█████╔╝@
 ╚════╝ @
        @@
██╗  ██╗@
██║ ██╔╝@
█████╔╝ @
██╔═██╗ @
██║  ██╗@
╚═╝  ╚═╝@
        @@
██╗     @
██║     @
██║     @
██║     @
███████╗@
╚══════╝@
        @@
███╗   ███╗@
████╗ ████║@
██╔████╔██║@
██║╚██╔╝██║@
██║ ╚═╝ ██║@
╚═╝     ╚═╝@
           @@
███╗   ██╗@
████╗  ██║@
██╔██╗ ██║@
██║╚██╗██║@
██║ ╚████║@
╚═╝  ╚═══╝@
          @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔═══╝ @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║▄▄ ██║@
╚██████╔╝@
 ╚══▀▀═╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██║  ██║@
╚═╝  ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
████████╗@
╚══██╔══╝@
   ██║   @
   ██║   @
   ██║   @
   ╚═╝   @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚═══╝  @
         @@
██╗    ██╗@
██║    ██║@
██║ █╗ ██║@
██║███╗██║@
╚███╔███╔╝@
 ╚══╝╚══╝ @
          @@
██╗  ██╗@
╚██╗██╔╝@
 ╚███╔╝ @
 ██╔██╗ @
██╔╝ ██╗@
╚═╝  ╚═╝@
        @@
██╗   ██╗@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚██╔╝  @
   ██║   @
   ╚═╝   @
         @@
███████╗@
╚══███╔╝@
  ███╔╝ @
 ███╔╝  @
███████╗@
╚══════╝@
        @@
███╗@
██╔╝@
██║ @
██║ @
███╗@
╚══╝@
    @@
@
@
@
@
@
@
@@
███╗@
╚██║@
 ██║@
 ██║@
███║@
╚══╝@
    @@
 ███╗ @
██╔██╗@
╚═╝╚═╝@
      @
      @
      @
      @@
        @
        @
        @
        @
███████╗@
╚══════╝@
        @@
@
@
@
@
@
@
@@
 █████╗ @
██╔══██╗@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██████╔╝@
╚═════╝ @
        @@
 ██████╗@
██╔════╝@
██║     @
██║     @
╚██████╗@
 ╚═════╝@
        @@
██████╗ @
██╔══██╗@
██║  ██║@
██║  ██║@
██████╔╝@
╚═════╝ @
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
███████╗@
╚══════╝@
        @@
███████╗@
██╔════╝@
█████╗  @
██╔══╝  @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔════╝ @
██║  ███╗@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗  ██╗@
██║  ██║@
███████║@
██╔══██║@
██║  ██║@
╚═╝  ╚═╝@
        @@
██╗@
██║@
██║@
██║@
██║@
╚═╝@
   @@
     ██╗@
     ██║@
     ██║@
██   ██║@
╚█████╔╝@
 ╚════╝ @
        @@
██╗  ██╗@
██║ ██╔╝@
█████╔╝ @
██╔═██╗ @
██║  ██╗@
╚═╝  ╚═╝@
        @@
██╗     @
██║     @
██║     @
██║     @
███████╗@
╚══════╝@
        @@
███╗   ███╗@
████╗ ████║@
██╔████╔██║@
██║╚██╔╝██║@
██║ ╚═╝ ██║@
╚═╝     ╚═╝@
           @@
███╗   ██╗@
████╗  ██║@
██╔██╗ ██║@
██║╚██╗██║@
██║ ╚████║@
╚═╝  ╚═══╝@
          @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔═══╝ @
██║     @
╚═╝     @
        @@
 ██████╗ @
██╔═══██╗@
██║   ██║@
██║▄▄ ██║@
╚██████╔╝@
 ╚══▀▀═╝ @
         @@
██████╗ @
██╔══██╗@
██████╔╝@
██╔══██╗@
██║  ██║@
╚═╝  ╚═╝@
        @@
███████╗@
██╔════╝@
███████╗@
╚════██║@
███████║@
╚══════╝@
        @@
████████╗@
╚══██╔══╝@
   ██║   @
   ██║   @
   ██║   @
   ╚═╝   @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
██║   ██║@
╚██████╔╝@
 ╚═════╝ @
         @@
██╗   ██╗@
██║   ██║@
██║   ██║@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚═══╝  @
         @@
██╗    ██╗@
██║    ██║@
██║ █╗ ██║@
██║███╗██║@
╚███╔███╔╝@
 ╚══╝╚══╝ @
          @@
██╗  ██╗@
╚██╗██╔╝@
 ╚███╔╝ @
 ██╔██╗ @
██╔╝ ██╗@
╚═╝  ╚═╝@
        @@
██╗   ██╗@
╚██╗ ██╔╝@
 ╚████╔╝ @
  ╚██╔╝  @
   ██║   @
   ╚═╝   @
         @@
███████╗@
╚══███╔╝@
  ███╔╝ @
 ███╔╝  @
███████╗@
╚══════╝@
        @@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
@
@
@
@
@
@
@@
EOF

    # --- Final Steps ---
    chsh -s zsh

    main_banner
    echo -e "${A} ${g}SUCCESS! Configuration is complete.${n}"
    echo -e "${I} ${g}Your local Nerd Font has been installed.${n}"
    echo -e "${I} ${r}IMPORTANT: To see icons correctly, you MUST restart Termux.${n}"
    echo -e "${c}   1. Type '${y}exit${c}' and press Enter."
    echo -e "${c}   2. Go to your phone's Settings -> Apps -> Termux -> ${r}Force Stop${c}."
    echo -e "${c}   3. Re-open Termux.${n}"
    echo
}

# --- SCRIPT STARTS HERE ---

# 1. Check if running in Termux
if [ ! -d "/data/data/com.termux/files/usr/" ]; then
    echo -e "${E} ${r}Error: This script is designed for Termux only.${n}"
    exit 1
fi

# 2. Handle Password
handle_password

# 3. Check for internet connection (still needed for package installation)
main_banner
echo -e "${A} ${c}Checking for internet connection...${n}"
if ! pkg list-installed > /dev/null 2>&1; then
  echo -e "${E} ${r}Error: No internet connection found. Please connect to the internet to install packages.${n}"
  exit 1
fi
echo -e "${A} ${g}Internet connection found.${n}"
sleep 1

# 4. Install all dependencies
install_dependencies

# 5. Install Nerd Font from local file
install_local_font

# 6. Run the main setup
setup_environment
