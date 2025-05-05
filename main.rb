# Lägg till björn, battle mechanic mot björnen, en alternativ win condition (björn)

require_relative "./terminal.rb"
require_relative "./room.rb"

$bear_check = 0

# Beskrivning: Puts information about the current room to the terminal.
# Argument 1: string - Name of the room
# Argument 2: string - Description of the room
# Return: None
# Exempel:
#   skriva_ut_info("Rum 1", "Detta är rum 1") # Skriver ut "Rum 1" och "Detta är rum 1"
# Datum: 2025-05-05
def skriva_ut_info(name, desc)
  puts name
  puts desc
end

# Beskrivning: Checks if the choice the player is valid. Checks if its a valid choice and that the player has the required items. 
# Argument 1: Array - List of options valid options and the items they require [["namn", ["föremål 1", "föremål 2""]]]
# Argument 2: string - The choice the player made
# Argument 3: Array - The items in the players inventory
# Return: Array - [bool, string] - true if the choice is valid, false if not. The string contains an error message if the choice is invalid
# Exempel:
#   is_valid_choice([["Gå in i vinden", []], ["Gå hem", []]], "1", ["Hårspray"]) # returns [true, ""]
#   is_valid_choice([["Bygg en flamethrower", []], ["Gå hem", []]], "1", ["Hårspray"]) # returns [false, "Du har inte alla nödvändiga föremål. Hårspray, tändare"]
#   is_valid_choice([["Gå in i vinden", []], ["Gå hem", []]], "2", ["Hårspray"]) # returns [false, "Ogiltigt val. Försök igen."]
# Datum: 2025-05-05
def is_valid_choice(options, choice, inventory)
  i = 1
  for option in options
    if i == choice.to_i
      if !has_required_items?(option[1], inventory)
        return [false, "Du har inte alla nödvändiga föremål. #{option[1].join(", ")}" ]
      else
        return [true, ""]
      end
    end
    i += 1
  end
  
  return [false, "Ogiltigt val. Försök igen."]
end

def get_valid_options_names(options)
  valid_options = []
  i = 1
  for option in options
    valid_options.push("(#{i}) #{option[0]}")
    i += 1
  end
  return valid_options
end

# options: [["namn", ["föremål 1", "föremål 2""]]]

# Beskrivning: Ask the player to choose an option from a list of options. The player can only choose a valid option.
# Argument 1: Array - List of options valid options and the items they require [["namn", ["föremål 1", "föremål 2""]]]
# Argument 2: Array - The items in the players inventory
# Return: string - The choice the player made
# Exempel:
#   choose([["Gå in i vinden", []], ["Gå hem", []]], ["Hårspray"]) # returns "1" or "2" depending on the players choice. If the player chooses an invalid option, the function will ask again until a valid option is chosen.
# Datum: 2025-05-05
def choose(options, inventory)
  while true
    choice = ask("Möjliga val: #{get_valid_options_names(options).join(", ")}")

    res = is_valid_choice(options, choice, inventory)

    if res[0]
      break
    end

    puts res[1]
  end

  return choice
end

def remove_inventory_item(inventory, item)
  inventory.delete(item)
end

def has_required_items?(items, inventory)
  return items.all? { |item| inventory.count(item) >= items.count(item) }
end

def remove_inventory_items(items, inventory)
  items.each do |item|
    if inventory.include?(item)
      inventory.delete(item)
    end
  end
end

def room_attic_entraence(inventory)
  skriva_ut_info("Vindsluckan", "Du står nedanför en mystisk vindslucka. Vad ska du göra?")
  val = choose([
    ["Gå in i vinden", []],
    ["Gå hem", []]
  ], inventory)

  if val == "1"
    return :room_attic
  else
    puts "Fegis!"
    return nil
  end
end

def room_attic(inventory)
  skriva_ut_info("Vinden", "Du står i en mörk och skrämmande vind. Något springer runt dina fötter. Vad ska du göra?")
  val = choose([
    ["Provocera", []],
    ["Få panik", []]
  ], inventory)
  
  if val == "1"
    puts "Du lyckas skrämma bort råttorna för nu. Du fortsätter in i vinden."
    return :room_attic_2
  elsif val == "2"
    return :room_rats_on_you
  end
end

def room_attic_2(inventory)
    skriva_ut_info("Rum 2", "Du står nu framför en flyttlåda, vågar du titta i den?")
    val = choose([
      ["Titta i lådan", []],
      ["Gå vidare", []]
    ], inventory)

    if val == "1"
      if rand(0..1) == 1
        puts "En råtta hoppar ut ur lådan och biter dig i handen. Du dör."     
        return nil
      else
        puts "Du hittar hårsprej en tom tänd sticksask i lådan. Du plockar upp den."
        inventory.push("Hårspray")
        inventory.push("Tändstickor")
        return :room_attic_3
      end
    elsif val == "2"
      return :room_attic_3
    end
end

def room_attic_3(inventory)
  if $bear_check == 1
    return :room_bear
  end
  $bear_check += 1
  skriva_ut_info("Rum 3", "Du står nu framför en gammal bokhylla. Vad ska du göra?")
  val = choose([
    ["Titta i bokhyllan", []],
    ["Gå vidare till ett fönster", []]
  ], inventory)

  if val == "1"
    puts "Du hittar en gammal bok. Du plockar upp den. En hemlig löndör öppnas bakom bokhyllan."
    inventory.push("Gammal bok")
    return :room_secret_door
  elsif val == "2"
    return :room_window
  end
end

def room_secret_door(inventory)
   skriva_ut_info("Hemlig dörr", "Du står nu framför en hemlig dörr. Vad ska du göra?")
   val = choose([
      ["Gå in", []],
      ["Gå mot fönstret istället", []]
], inventory)
  
  if val == "1"
    return :room_secret_room
  elsif val == "2"
    return :room_window
  end
end

def room_secret_room(inventory)
    skriva_ut_info("Hemligt rum", "Du står nu i ett hemligt rum. Du ser en mystisk teckning på ett podium av en hand. Vad ska du göra?")
    val = choose([
      ["Lägga din avskurna hand där", ["Avskuren hand"]],
      ["Lägg en död råtta där", ["Död råtta"]],
      ["Gå tillbaka till vinden", []]
    ], inventory)

    if val == "1"
      puts "Teckningen börjar lysa och din hand fastnat som en magnet på din arm igen. Du vaknar upp i din säng. Du har överlevt."
      remove_inventory_items(["Avskuren hand"], inventory)
      return nil
    elsif val == "2"
      puts "Dörren bakom dig stängs. Du svimar och dör. "
      return nil
    elsif val == "3"
      return :room_window
    end
end

def room_rats_on_you(inventory)
  skriva_ut_info("Råttor", "Råttorna har hittat dig och börjar äta på dig. Vad ska du göra?")
  val = choose([
    ["Skrika", []],
    ["Sparka", []],
    ["Bygga en Boring Company (TM) eldkastare", ["Tändstickor", "Hårspray"]],
  ], inventory)

  if val == "1"
     puts "Råttorna kryper in i din mun. Du kvävs och dör."
     return nil
  elsif val == "2"
    puts "Du sparkar mot råttorna. De blir ännu argare och biter dig i benen, men du lyckas överleva. När du ställer dig upp råkar du trampa på en av råttorna och lyckas döda den. Du plockar upp den."
    inventory.push("Död råtta")
    return :room_attic_2
  elsif val == "3"
    puts "Du bygger en Boring Company (TM) eldkastare och skrämmer bort råttorna. Du hittar en låda med tändstickor."
    remove_inventory_items(["Tändstickor", "Hårspray"], inventory)
    return :room_set_fire_to_the_attic
  end
end

def room_set_fire_to_the_attic(inventory)
  skriva_ut_info("Vinden", "Du kom på att du med elkastaren kan sätta eld på vinden. Vad ska du göra?")
  val = choose([
    ["Sätta eld på vinden", []],
    ["Låta råttorna leva och gå mot utgången", []]
  ], inventory)

  if val == "1"
    puts "Du sätter eld på vinden och råttorna brinner upp. Du dör också."
    return nil
  elsif val == "2"
    return :room_window
  end
end

def room_window(inventory)
  skriva_ut_info("Fönstret", "Du står nu framför ett fönster. Vad ska du göra?")
  val = choose([
    ["Hoppa ut genom fönstret", []],
    ["Använda en död råtta för att slå sönder rutan", ["Död råtta"]],
    ["Gå tillbaka in i vinden", []]
  ], inventory)

  if val == "1"
    puts "Fönstret gick sönder och du förblödde på grund av alla glasskärvor du fick i dig."
    return nil
  elsif val == "2"
    if rand(0..1) == 1
      puts "Du slår sönder rutan med den döda råttan. Du hoppar ut genom fönstret och överlever."
      return nil
    else
      puts "Du missar rutan och råttan träffar dig i ansiktet. Du får ont och slår istället sönder rutan med handen. Du lyckas skära av handen. "
      inventory.push("Avskuren hand")
      remove_inventory_items(["Död råtta"], inventory)
      return :room_attic_2
    end
  elsif val == "3"
    return :room_attic
  end
end

def room_bear(inventory)
  skriva_ut_info("En björn", "Du står nu framför en björn. Vad ska du göra?")
    val = choose([
      ["Spring för livet", []],
      ["Stå upp för dig själv", []],
      ["Ge upp", []]
    ],inventory)
    if val == "1"
      puts "Björnen är snabbare än dig och fångar dig. Du dör."
      return nil
    elsif val == "2"
      puts "Du står upp för dig själv och björnen blir imponerad."
      return :room_bear_fight
    elsif val == "3"
      puts "Du ger upp och björnen äter dig. Du dör."
      return nil
    end
end

def room_bear_fight(inventory)
  bear_health = 10
  player_health = 10
  skriva_ut_info("Björnen", "Du står nu framför björnen. Vad ska du göra?")
  val = choose([
    ["Leta i omgivningen efter ett vapen", []], ["Använd något du plockat upp", ["Hårspray","Tändstickor"]],
    ["Ge upp", []]], inventory)
  if val == "1"
    weapon = rand(1..2)
    if weapon == 1
      inventory.push("Gammal kniv")
      puts "Du hittar en gammal kniv. Du svingar den mot björnen."
      bear_health -= 2
    else
      inventory.push("Gammal yxa")
      puts "Du hittar en gammal yxa. Du hugger mot björnen."
      bear_health -= 4
    end
  elsif val == "2"
    puts "Du använder din hårspray och tändstickor som en eldkastare. Björnen blir skrämd och springer iväg."
    inventory.remove_inventory_items(["Hårspray", "Tändstickor"])
  else
    puts "Du ger upp och björnen äter dig. Du dör."
    return nil
  end
    while bear_health > 0 && player_health > 0
      val = choose([["Svinga med yxan", ["Gammal yxa"]], ["Hugg med kniven", ["Gammal kniv"]], ["Slå för glatta livet", []]],inventory)
      if val == "1"
        puts "Du svingar din yxa mot björnen."
        bear_health -= 4
      elsif val == "2"
        puts "Du hugger med din kniv mot björnen."
        bear_health -= 2
      elsif val == "3"
        puts "Du slår för glatta livet och träffar björnen."
        bear_health -= 1
      end
      puts "Björnen hugger tillbaka."
      player_health -= 2
    end
    if bear_health <= 0
      puts "Du har dödat björnen! Snyggt jobbat."
      return :room_attic_3 
    else
      puts "Björnen har dödat dig. Du dör."
    end
  return nil
end


def main()
  inventory = []

  print_in_center("Välkommen till spelet!")
  name = ask("Vad heter du?")
  print_in_center("Hello, #{name}!")
  
  room = :room_attic_entraence
  while room != nil
    room = method(room).call(inventory)
  end
  
  # select_from_list(inventory, "Inventory")
end

main()