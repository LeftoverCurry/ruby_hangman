# global requirements/classes/variables
require 'json'

# Defining the player
class Player
  attr_reader :user_name

  def initialize(user_name)
    @user_name = user_name
    filename = "saved_games/#{@user_name}.json"
    File.open(filename, 'w') do |file|
      file.puts self.to_json
    end
  end

  def to_json
    JSON.dump({:user_name => @user_name})
  end

  def self.from_json(raw)
    data = JSON.load raw
    self.new(data[user_name])
  end
end

class Game
  def initialize
    
end

# greeting (check user name)
def create_new_player
  puts 'Hello, and welcome to Hangman!  What is your name?'
  user_name = gets.chomp.downcase
  if !File.exist?("./saved_games/#{user_name}.json")
    Player.new(user_name)
  elsif File.exist?("./saved_games/#{user_name}.json")
    new_or_saved()
  end
end

def new_or_saved
  puts 'Would you like to continue your previous game? Y/N?'
  use_saved_game = gets.chomp.downcase
  if use_saved_game == 'y'
    puts 'Pulling info'
    Player.from_json("./saved_games/#{user_name}.json")
  elsif use_saved_game == 'n'
    puts 'starting new game'
  else
    puts 'I\'m sorry, I didn\'t understand!  Please answer with Y or N:'
    new_or_saved()
  end
end

def display
  display = File.read('./art/no_error')
  puts display
end


this_player = create_new_player

# if saved file doesn't exist,  create new game
#   pull word
#   display letter count
  
# play game
#   pull input from user
#   match user input to game word (for each letter, if the letter equals the input, display the letter else display "_")

