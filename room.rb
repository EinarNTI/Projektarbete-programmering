require_relative "./terminal.rb"

class Room
  attr_accessor :name, :options, :description

  def initialize(name, options)
    @name = name
    @options = options
  end

  def print(player)
    puts "#{@name}:"
    puts "#{@description}"
    puts "Val:"
    for option in @options
      option.print()
    end

    has_required_items = false
    while !has_required_items
      selected_option = ask_with_answers("Vad vill du göra?", @options.map { |option| option.name })
      selected_option = @options.find { |option| option.name == selected_option }
      has_required_items = selected_option.has_required_items(player.inventory)     
    end
    
    return selected_option.choose(player)
  end
end

class Option
  attr_accessor :name, :description, :items_required, :next_room

  def initialize(name, description, items_required, next_room)
    @next_room = next_room
    @name = name
    @description = description
    @items_required = items_required
  end

  def has_required_items(inventory)
    for item in @items_required
      if inventory.count(item) >= @items_required.count(item)
        return true
      end
      return false
    end
  end

  def choose(player)
    for item in @items_required
      player.inventory.delete(item)
    end

    return @next_room
  end
end