#!/bin/bash

# example.sh - Example usage of menu.sh with embedded ANSI color formatting

# Source the menu script
source ./menu.sh

# Define all ANSI color codes for customization using $'...' to interpret escape sequences
RESET=$'\033[0m'           # Reset all attributes
BOLD=$'\033[1m'            # Bold text
DIM=$'\033[2m'             # Dim text
UNDERLINE=$'\033[4m'       # Underlined text
BLINK=$'\033[5m'           # Blink text
REVERSE=$'\033[7m'         # Reverse colors
HIDDEN=$'\033[8m'          # Hidden text

# Foreground colors
BLACK=$'\033[0;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
GREY=$'\033[0;37m'          # Added GREY color

# Bright foreground colors
BRIGHT_BLACK=$'\033[1;30m'
BRIGHT_RED=$'\033[1;31m'
BRIGHT_GREEN=$'\033[1;32m'
BRIGHT_YELLOW=$'\033[1;33m'
BRIGHT_BLUE=$'\033[1;34m'
BRIGHT_MAGENTA=$'\033[1;35m'
BRIGHT_CYAN=$'\033[1;36m'
BRIGHT_WHITE=$'\033[1;37m'

# Background colors
BG_BLACK=$'\033[40m'
BG_RED=$'\033[41m'
BG_GREEN=$'\033[42m'
BG_YELLOW=$'\033[43m'
BG_BLUE=$'\033[44m'
BG_MAGENTA=$'\033[45m'
BG_CYAN=$'\033[46m'
BG_WHITE=$'\033[47m'

# Bright background colors
BG_BRIGHT_BLACK=$'\033[100m'
BG_BRIGHT_RED=$'\033[101m'
BG_BRIGHT_GREEN=$'\033[102m'
BG_BRIGHT_YELLOW=$'\033[103m'
BG_BRIGHT_BLUE=$'\033[104m'
BG_BRIGHT_MAGENTA=$'\033[105m'
BG_BRIGHT_CYAN=$'\033[106m'
BG_BRIGHT_WHITE=$'\033[107m'

# Define menu options
options=("Install" "Update" "Remove" "Exit")

# Define descriptions corresponding to each menu option
descriptions=(
    "${GREY}- ${CYAN}Install${RESET}: ${DIM}Install new software.${RESET}"
    "${GREY}- ${CYAN}Update${RESET}: ${DIM}Update existing software.${RESET}"
    "${GREY}- ${CYAN}Remove${RESET}: ${DIM}Remove unwanted software.${RESET}"
    "${GREY}- ${CYAN}Exit${RESET}: ${DIM}Exit the menu.${RESET}"
)

# Optionally, add a title
title="${BRIGHT_GREEN}${BOLD}Package Manager${RESET}"

# Specify the desired menu position
# Options: top-left, top-center, top-right,
#          center-left, center-center, center-right,
#          bottom-left, bottom-center, bottom-right
# Uncomment one of the following lines to test different positions:

# menu_position="top-left"
# menu_position="top-center"
# menu_position="top-right"
# menu_position="center-left"
 menu_position="center-center"
# menu_position="center-right"
# menu_position="bottom-left"
# menu_position="bottom-center"
# menu_position="bottom-right"

# Display the menu
menu "$title" "$menu_position" "options[@]" "descriptions[@]" selected_option

# Handle the selected option
case "$selected_option" in
    "Install")
        echo -e "${BRIGHT_GREEN}You chose to Install.${RESET}"
        # Add installation logic here
        ;;
    "Update")
        echo -e "${BRIGHT_YELLOW}You chose to Update.${RESET}"
        # Add update logic here
        ;;
    "Remove")
        echo -e "${BRIGHT_RED}You chose to Remove.${RESET}"
        # Add removal logic here
        ;;
    "Exit")
        echo -e "${CYAN}Exiting the menu.${RESET}"
        exit 0
        ;;
    *)
        echo -e "${BRIGHT_RED}Invalid selection.${RESET}"
        ;;
esac

