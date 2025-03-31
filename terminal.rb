require 'readline'

def clear_terminal()
  system("clear") || system("cls") # Olika beroende på os
end

def get_terminal_size()
  return Readline.get_screen_size
end

def print_in_center(text)
  screen_size = get_terminal_size()
  padding_left = (screen_size[1] - text.length) / 2

  puts " " * padding_left + text
end