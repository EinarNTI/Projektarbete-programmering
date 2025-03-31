require 'readline'
require 'io/console'

def clear_terminal()
  system("clear") || system("cls") # --> Olika beroende på os
end

def get_terminal_size()
  return Readline.get_screen_size
end

def print_in_center(text)
  screen_size = get_terminal_size()
  padding_left = (screen_size[1] - text.length) / 2

  puts " " * padding_left + text
end

# Print a list in a box like a html fieldset
def print_list(list, legend = "Legend")
  screen_size = get_terminal_size()
  longest_string = list.max_by(&:length).length
  total_width = [longest_string, legend.length + 6].max
  padding_left = (screen_size[1] - total_width) / 2

  legend_padding = (total_width - legend.length) / 2
  puts " " * padding_left + "+" + "-" * legend_padding + " #{legend} " + "-" * (total_width - legend.length - legend_padding) + "+"
  list.each do |item|
    puts " " * padding_left + "| #{item.ljust(total_width)} |"
  end
  puts " " * padding_left + "+" + "-" * (total_width + 2) + "+"
end

def select_from_list(list, legend = "Legend")
  screen_size = get_terminal_size()
  longest_string = list.max_by(&:length).length
  total_width = [longest_string, legend.length + 6].max
  padding_left = (screen_size[1] - total_width) / 2

  selected_index = 0

  Signal.trap("INT") { exit } # Handle Ctrl+C gracefully

  loop do
    clear_terminal()

    legend_padding = (total_width - legend.length) / 2
    puts " " * padding_left + "+" + "-" * legend_padding + " #{legend} " + "-" * (total_width - legend.length - legend_padding) + "+"
    list.each_with_index do |item, index|
      if index == selected_index
        puts " " * padding_left + "| > #{item.ljust(total_width - 3)} |"
      else
        puts " " * padding_left + "|   #{item.ljust(total_width - 3)} |"
      end
    end
    puts " " * padding_left + "+" + "-" * (total_width + 2) + "+"

    input = STDIN.getch
    case input
    when "\e"
      next_char = STDIN.getch
      if next_char == "["
        arrow_key = STDIN.getch
        case arrow_key
        when "A" # Up arrow
          selected_index = (selected_index - 1) % list.length
        when "B" # Down arrow
          selected_index = (selected_index + 1) % list.length
        end
      end
    when "\r" # Enter key
      return list[selected_index]
    end
  end
end
