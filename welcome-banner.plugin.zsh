#!/bin/bash
# welcome-banner.plugin.zsh

# This script enhances the terminal session with a colorful, welcoming banner and a random quote display.
# It is designed for Zsh shells, utilizing external utilities like figlet and lolcat for visual effects,
# and is intended to be run once per session to greet the user.

# Source the quotes.zsh file using a relative path
source "$(dirname "$0")/quotes.zsh"

# Function to add a colorful banner using figlet and lolcat for each word passed as argument.
function welcome_banner {
  # Get the current terminal width to dynamically adjust the banner.
  term_width=$(tput cols)

  # Loop through each argument passed to the function.
  for word in $@; do
    # Use figlet to create large letters for each word with a specific font, then adjust the word to fit the terminal width.
    # Center the text based on terminal width and print it with padding.
    figlet -f ~/.local/share/fonts/figlet-fonts/ANSI\ Shadow.flf "$word" | fold -sw $term_width | while IFS= read -r line; do
      line_length=${#line}
      padding=$(( (term_width - line_length) / 2 ))
      printf "%${padding}s%s\n" "" "$line"
    done | lolcat  # Apply rainbow coloring to the text for visual appeal.
  done
}

# Function to select a random quote from an array and display it in a centered format.
function display_quote {
  # Select a random quote from the predefined 'quotes' array.
  random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
  term_width=$(tput cols)  # Again, get the terminal width for dynamic adjustment.

  # Echo the quote, word wrap it to fit the terminal, and center it using calculated padding.
  echo "$random_quote" | fold -sw $term_width | while IFS= read -r line; do
      line_length=${#line}
      padding=$(( (term_width - line_length) / 2 ))
      printf "%${padding}s%s\n" "" "$line"
  done
}

# Global variable to ensure the welcome banner is shown only once per session.
typeset -g WELCOME_BANNER_SHOWN=false

# Function to show the welcome banner and a random quote once per session.
function show_welcome_banner_once {
  if [[ "$WELCOME_BANNER_SHOWN" != true ]]; then
    echo " " # Add a space before the banner for better readability.
    welcome_banner "Welcome Back!"  # Display the welcome banner.
    display_quote  # Display a random quote.
    echo " " # Add a space after the banner for separation and readability.
    WELCOME_BANNER_SHOWN=true  # Set the flag to true to avoid repeated displays.
  fi
}

