require_relative "./terminal.rb"

def main()
  puts "Roblox!"

  clear_terminal()

  print_in_center("Welcome")
  print_in_center("To Roblox!")
  print_in_center("(Fortnite isn't bad)")

  inventory = ["Sword", "Shield", "Health Potion"]
  select_from_list(inventory, "Inventory")
  
end

main()