require_relative "./terminal.rb"
require_relative "./room.rb"

def main()
  inventory = []
  health = 100

  print_in_center("Välkommen till spelet!")
  ask("Vad heter du?")
  print_in_center("Hello, #{name}!")
  
  select_from_list(inventory, "Inventory")
end
    
main()