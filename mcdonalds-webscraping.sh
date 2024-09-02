#!/bin/bash

# declare an array 
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

#create the folder 
output_dir="scraped_menus"
mkdir -p "$output_dir"
echo "Created directory: $output_dir"

for category_name in "${!menu_urls[@]}"; do
    echo "Processing category: $category_name"
    
    webpage_content=$(curl -s "${menu_urls[$category_name]}")
#it chexk  the menu category  is found on menu_url 
    if echo "$webpage_content" | pup 'span.category-title text{}' | grep -q "$category_name"; then
        
        sanitized_name=$(echo "$category_name" | tr -d '&;')
        
      
        extracted_items=$(echo "$webpage_content" | pup 'span.categories-item-name text{}')
        
       #save the file 
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

