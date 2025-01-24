#!/bin/bash

# menu.sh - A portable, reusable Bash menu system with ANSI color handling in inputs

# Function to display the menu
# Usage:
#   menu "Title" "Position" "Options[@]" "Descriptions[@]" "Return Variable"
menu() {
    local title="$1"
    local position="$2" # Positions: top-left, top-center, top-right,
                         # center-left, center-center, center-right,
                         # bottom-left, bottom-center, bottom-right
    local options_ref="$3"
    local descriptions_ref="$4"
    local __resultvar="$5"

    # Expand the array elements for options and descriptions
    eval "local options=(\"\${$options_ref}\")"
    eval "local descriptions=(\"\${$descriptions_ref}\")"

    # Check if options and descriptions have the same length
    if [[ ${#options[@]} -ne ${#descriptions[@]} ]]; then
        echo -e "\033[1;31mError: The number of options and descriptions must match.\033[0m"
        return 1
    fi

    local selected=0
    local choice
    local key

    # Function to get terminal size
    get_terminal_size() {
        local default_rows=24
        local default_cols=80

        if [[ -n "$LINES" && -n "$COLUMNS" ]]; then
            echo "$LINES $COLUMNS"
        else
            if command -v stty >/dev/null 2>&1; then
                stty size 2>/dev/null || echo "$default_rows $default_cols"
            else
                echo "$default_rows $default_cols"
            fi
        fi
    }

    # Function to move cursor to (row, col)
    cursor_to() {
        printf "\033[%s;%sH" "$1" "$2"
    }

    # Function to clear the screen
    clear_screen() {
        printf "\033[2J"
    }

    # Function to hide the cursor
    hide_cursor() {
        printf "\033[?25l"
    }

    # Function to show the cursor
    show_cursor() {
        printf "\033[?25h"
    }

    # Function to clear from cursor to end of screen
    clear_eos() {
        printf "\033[J"
    }

    # Function to strip ANSI escape codes
    strip_ansi() {
        # This function removes ANSI escape codes from a string
        echo -e "$1" | sed -r 's/\x1B\[[0-9;]*[mG]//g'
    }

    # Function to calculate visible length of a string (without ANSI codes)
    visible_length() {
        local str="$1"
        strip_ansi "$str" | wc -c
    }

    # Function to draw the menu
    draw_menu() {
        clear_screen

        # Get terminal size
        read -r rows cols < <(get_terminal_size)

        local menu_height=${#options[@]}
        local menu_width=0
        for option in "${options[@]}"; do
            local option_length
            option_length=$(visible_length "${option}")
            [[ $option_length -gt $menu_width ]] && menu_width=$option_length
        done
        ((menu_width += 4)) # Padding for "> " and spaces

        # Calculate starting row and column based on position
        local start_row=1
        local start_col=1

        # Define space needed for title and description
        local title_space=2      # One line for title
        local description_space=2 # One line for description

        case "$position" in
            top-left)
                start_row=$((title_space + 1))
                start_col=2
                ;;
            top-center)
                start_row=$((title_space + 1))
                start_col=$(( (cols / 2) - (menu_width / 2) ))
                ;;
            top-right)
                start_row=$((title_space + 1))
                start_col=$(( cols - menu_width - 2 ))
                ;;
            center-left)
                start_row=$(( (rows / 2) - (menu_height / 2) ))
                start_col=2
                ;;
            center-center)
                start_row=$(( (rows / 2) - (menu_height / 2) ))
                start_col=$(( (cols / 2) - (menu_width / 2) ))
                ;;
            center-right)
                start_row=$(( (rows / 2) - (menu_height / 2) ))
                start_col=$(( cols - menu_width - 2 ))
                ;;
            bottom-left)
                start_row=$(( rows - menu_height - description_space - title_space ))
                start_col=2
                ;;
            bottom-center)
                start_row=$(( rows - menu_height - description_space - title_space ))
                start_col=$(( (cols / 2) - (menu_width / 2) ))
                ;;
            bottom-right)
                start_row=$(( rows - menu_height - description_space - title_space ))
                start_col=$(( cols - menu_width - 2 ))
                ;;
            *)
                # Default to center-center
                start_row=$(( (rows / 2) - (menu_height / 2) ))
                start_col=$(( (cols / 2) - (menu_width / 2) ))
                ;;
        esac

        # Ensure start_row is at least title_space +1
        if (( start_row < title_space + 1 )); then
            start_row=$(( title_space + 1 ))
        fi

        # Print title if it exists
        if [[ -n "$title" ]]; then
            local title_row
            local title_col

            title_row=$(( start_row - title_space ))
            # Prevent title_row from being less than 1
            if (( title_row < 1 )); then
                title_row=1
            fi

            visible_title_length=$(visible_length "$title")
            case "$position" in
                top-left | center-left | bottom-left)
                    title_col=2
                    ;;
                top-center | center-center | bottom-center)
                    title_col=$(( (cols / 2) - (visible_title_length / 2) ))
                    ;;
                top-right | center-right | bottom-right)
                    title_col=$(( cols - visible_title_length - 2 ))
                    ;;
                *)
                    title_col=$(( (cols / 2) - (visible_title_length / 2) ))
                    ;;
            esac

            cursor_to "$title_row" "$title_col"
            # Print the title with user-defined formatting
            printf "%b\n" "$title"
        fi

        # Iterate through options and display them
        for i in "${!options[@]}"; do
            local row=$((start_row + i))
            local col=$start_col
            cursor_to "$row" "$col"
            if [[ $i -eq $selected ]]; then
                # Highlight selected option
                printf "\033[0;36m> \033[1;37m%s\033[0m" "${options[i]}"
            else
                # Regular option
                printf "  \033[0;37m%s\033[0m" "${options[i]}"
            fi
            # Clear the rest of the line to avoid artifacts
            clear_eos
        done

        # Print the description of the selected option if it exists
        if [[ -n "${descriptions[$selected]}" ]]; then
            local description_start_row
            local description_start_col

            description_start_row=$(( start_row + menu_height + 1 ))

            case "$position" in
                top-left | top-center | top-right | center-left | center-center | center-right)
                    # Description below the menu
                    ;;
                bottom-left | bottom-center | bottom-right)
                    # Description below the menu, but ensure it doesn't exceed terminal rows
                    if (( description_start_row > rows )); then
                        # Place description above the menu if there's no space below
                        description_start_row=$(( start_row - 1 ))
                    fi
                    ;;
                *)
                    ;;
            esac

            case "$position" in
                top-left | center-left | bottom-left)
                    description_start_col=2
                    ;;
                top-center | center-center | bottom-center)
                    desc_length=$(visible_length "${descriptions[$selected]}")
                    description_start_col=$(( (cols / 2) - (desc_length / 2) ))
                    ;;
                top-right | center-right | bottom-right)
                    desc_length=$(visible_length "${descriptions[$selected]}")
                    description_start_col=$(( cols - desc_length - 2 ))
                    ;;
                *)
                    description_start_col=2
                    ;;
            esac

            # Prevent description_start_row from being less than 1
            if (( description_start_row < 1 )); then
                description_start_row=1
            fi

            # Move cursor to description area
            cursor_to "$description_start_row" "$description_start_col"

            # Print the description with user-defined formatting
            printf "%b\n" "${descriptions[$selected]}"
        fi
    }

    # Hide the cursor and draw the initial menu
    hide_cursor
    draw_menu

    # Trap to ensure cursor is shown on exit
    trap "show_cursor; clear_screen; exit" INT TERM EXIT

    while true; do
        # Read user input
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            # Escape sequence (likely arrow keys)
            read -rsn2 key
            case "$key" in
                "[A") # Up arrow
                    ((selected--))
                    if [[ $selected -lt 0 ]]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                "[B") # Down arrow
                    ((selected++))
                    if [[ $selected -ge ${#options[@]} ]]; then
                        selected=0
                    fi
                    ;;
                *)
                    ;;
            esac
        elif [[ $key == "" || $key == $'\n' ]]; then
            # Enter key pressed
            choice="${options[selected]}"
            break
        fi
        draw_menu
    done

    # Cleanup: show cursor and clear screen
    show_cursor
    clear_screen
    trap - INT TERM EXIT

    # Return the selected choice
    if [[ -n "$__resultvar" ]]; then
        eval "$__resultvar=\"\$choice\""
    else
        echo "$choice"
    fi
}

# End of menu.sh

