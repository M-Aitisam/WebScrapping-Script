#!/bin/bash

# Declare an associative array with menu categories and their respective URLs
declare -A menu_urls=(
    ["Breakfast"]="https://mcdonalds.com.pk/full-menu/breakfast/"
    ["Beef"]="https://mcdonalds.com.pk/full-menu/beef/"
    ["Chicken and Fish"]="https://mcdonalds.com.pk/full-menu/chicken-and-fish/"
    ["Crispy Chicken"]="https://mcdonalds.com.pk/full-menu/crispy-chicken/"
    ["Wraps"]="https://mcdonalds.com.pk/full-menu/wraps/"
    ["Happy Meal"]="https://mcdonalds.com.pk/full-menu/happy-meal/"
    ["Extra Value Meals"]="https://mcdonalds.com.pk/full-menu/extra-value-meals/"
    ["Value Meals"]="https://mcdonalds.com.pk/full-menu/value-meals/"
    ["Desserts"]="https://mcdonalds.com.pk/full-menu/desserts/"
    ["Beverages"]="https://mcdonalds.com.pk/full-menu/beverages/"
    ["Mc Cafe"]="https://mcdonalds.com.pk/full-menu/mccafe/"
    ["Fries and Sides"]="https://mcdonalds.com.pk/full-menu/fries-and-sides/"
)

# Create a directory to store the menu files
output_dir="scraped_menus"
mkdir -p "$output_dir"
echo "Created directory: $output_dir"

# Loop through each menu category in the associative array
for category_name in "${!menu_urls[@]}"; do
    echo "Processing category: $category_name"
    
    webpage_content=$(curl -s "${menu_urls[$category_name]}")

    # Check if the menu category is found on the webpage
    if echo "$webpage_content" | pup 'span.category-title text{}' | grep -q "$category_name"; then
        # Format the file name by removing special characters
        sanitized_name=$(echo "$category_name" | tr -d '&;')
        
        # Extract item names using pup and format them
        extracted_items=$(echo "$webpage_content" | pup 'span.categories-item-name text{}')
        
        # Save the extracted items to a file with line numbers
        output_file="$output_dir/$sanitized_name.txt"
        echo "$extracted_items" | awk '{print NR ". " $0}' > "$output_file"
        
        # Success message
        if [ $? -eq 0 ]; then
            echo "Successfully saved items for $category_name to $output_file"
        else
            echo "Error: Failed to save items for $category_name"
        fi
    else
        echo "Warning: $category_name not found on the webpage."
    fi
done

echo "Script execution completed."

