# Simple Bash Menu

A reusable and portable Bash menu system that uses arrays to dynamically generate menus with descriptions. This script supports positioning menus in nine different terminal locations: top-left, top-center, top-right, center-left, center-center, center-right, bottom-left, bottom-center, and bottom-right.
<p align="center">
  <img src="https://github.com/bjensen91/simple-bash-menu/blob/main/demo.gif" alt="Simple Bash Menu GIF" width="600">
</p>

- Dynamic menus using arrays for options and descriptions.
- Nine customizable menu positions.
- ANSI color support for enhanced visuals.
- Lightweight and terminal-friendly.

## Installation

1. Clone this repository or copy `menu.sh` and `example.sh` to your project directory.
2. Ensure the scripts have execute permissions:
   ```bash
   chmod +x menu.sh example.sh
   ```

## Usage

1. Customize the `example.sh` script to define your menu options and descriptions as arrays.
2. Set the desired menu position using one of the following values:
   - `top-left`, `top-center`, `top-right`
   - `center-left`, `center-center`, `center-right`
   - `bottom-left`, `bottom-center`, `bottom-right`
3. Run the example script:
   ```bash
   ./example.sh
   ```

## Example

Here’s an example snippet of how to define and use the menu:

```bash
# Define options and descriptions as arrays
options=("Install" "Update" "Remove" "Exit")
descriptions=(
    "Install new software."
    "Update existing software."
    "Remove unwanted software."
    "Exit the menu."
)

# Display the menu in the center
menu "My Menu Title" "center-center" "options[@]" "descriptions[@]" selected_option
echo "You selected: $selected_option"
```

## Customization

- Modify the arrays in `example.sh` to create your own menus.
- Change the `menu_position` variable to adjust the menu’s placement.
- Use ANSI color codes to customize the appearance of the title, options, and descriptions.

## Contribution

Contributions are welcome! If you encounter any issues or have feature requests, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
