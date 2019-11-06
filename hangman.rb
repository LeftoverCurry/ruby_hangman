# frozen_string_literal: true

require 'json'
# Used to convert and parse saved games.

# Once called, this class will create and run a game
class Game
  # Defaults are provided for creating new game
  def initialize(user_name, chosen_letters = [],guesses_remaining = 5, letters_left_to_guess = false, randomly_picked_word = [])
    determine_magic_word(letters_left_to_guess, randomly_picked_word)
    @chosen_letters = chosen_letters
    @guesses_remaining = guesses_remaining
    @user_name = user_name
    interface
  end

  def to_save_file
    # Creates hash of saved information and converts to JSON
    info = { user_name: @user_name,
             chosen_letters: @chosen_letters,
             guesses_remaining: @guesses_remaining,
             letters_left_to_guess: @letters_left_to_guess,
             randomly_picked_word: @RANDOMLY_PICKED_WORD }
    info.to_json
  end

  def self.from_saved(location)
    # Pulls the data from the locally stored JSON file for the user name and creates a new game plugging in the saved info
    data = File.read(location)
    saved_data = JSON.parse(data)
    self.new(saved_data["user_name"], saved_data["chosen_letters"], saved_data["guesses_remaining"], saved_data["letters_left_to_guess"], saved_data["randomly_picked_word"])
  end

  def determine_magic_word (letters_left_to_guess, randomly_picked_word)
    # if there is no value passed to letters_left_to_guess, this method knows that there is no word for the person to guess
    # and runs the method to pull one from the dictionary and save it to a constant for later use
    if letters_left_to_guess == false
      @letters_left_to_guess = create_magic_word
    else
      @letters_left_to_guess = letters_left_to_guess
      @RANDOMLY_PICKED_WORD = randomly_picked_word
    end
  end

  def create_magic_word
    # Pulls a random word from the dictionary and sets it to a constant for later use.
    word_file = '5desk.txt'
    random_word = File.readlines(word_file).sample.strip.downcase
    @RANDOMLY_PICKED_WORD = random_word.split('')
    random_word.split('')
  end

  def interface
    # Displays the user interface
    check_for_win_or_loss
    show_image
    show_letters_display
    pull_user_input
    determine_result
  end

  def pull_user_input
    # Determines if the user wants to save or keep playing, and if they do want to play, pulls the next letter
    puts 'Please enter a letter or enter \'1\' to save and quit'
    @user_letter = gets.chomp.downcase
    if @user_letter == '1'
      save_and_quit
    else
    @chosen_letters << @user_letter
    end
  end

  def save_and_quit
    # Saves the game to a JSON file using the user's name to name the file, then exits the game.
    filename = "./saved_games/#{@user_name}.json"
    File.open(filename, 'w') do |file|
      file.puts self.to_save_file
    end
    exit
  end

  def determine_result
    # Determines if the user guess was correct.  If so, it pushes to the appropriate method.  
    # If not, it increments the game counter.
    if @letters_left_to_guess.include? @user_letter
      guess_was_correct(@user_letter)
    else
      puts 'That letter is not included!'
      @guesses_remaining -= 1
      interface
    end
  end

  def check_for_win_or_loss
    # Checks for win/loss conditions, in this case if the array of letters left to guess is empty, they win
    # And if the guesses remaining counter is zero or less, they lose.
    if @letters_left_to_guess == []
      display = File.read('./art/winscreen')
      puts display
      puts "The word was '#{@RANDOMLY_PICKED_WORD.join}'"
      `say "You Won! CONGRATULATIONS!"`
      exit
    elsif @guesses_remaining <= 0
      display = File.read('./art/dead')
      puts display
      puts "The word was '#{@RANDOMLY_PICKED_WORD.join}'"
      `say "you dead."`
      exit
    end
  end

  def show_image
    # Shows the hangman images using the guesses left counter
    case @guesses_remaining
    when 5
      display = File.read('./art/five_remaining.txt')
      puts display
    when 4
      display = File.read('./art/four_remaining.txt')
      puts display
    when 3
      display = File.read('./art/three_remaining.txt')
      puts display
    when 2
      display = File.read('./art/two_remaining.txt')
      puts display
    when 1
      display = File.read('./art/one_remaining.txt')
      puts display
    end
  end

  def show_letters_display
    # Shows the display of what letters have been guessed correctly and their correct positioningx
    missing_letters = @RANDOMLY_PICKED_WORD - @chosen_letters
    display_array = []
    @RANDOMLY_PICKED_WORD.each do |letter| 
      if missing_letters.include? letter
        display_array << ' _ '
      else
        display_array << letter
      end
    end
    puts display_array.join
    puts "[USED LETTERS:#{@chosen_letters}]"
  end

  def guess_was_correct(letter)
    # Removes the index of any letter correctly guessed from the array created by the magic word
    @letters_left_to_guess.each_with_index do |l, i|
      if l == letter
        @letters_left_to_guess.delete_at(i)
        guess_was_correct(letter)
      end
    end
    interface
  end
end

# Initializes the game and allows for the calling of saved games
class Shell
  def initialize
    intro
    create_new_player
  end

  def intro
    # Displays intro art
    display = File.read("./art/intro")
    puts display
  end

  def create_new_player
    # Checks if a player has played before.  If not, creates a new game.  If so, moves to the next method.
    puts 'Hello, and welcome to Hangman!  What is your name?'
    @user_name = gets.chomp.downcase
    if !File.exist?("./saved_games/#{@user_name}.json")
      Game.new(@user_name)
    elsif File.exist?("./saved_games/#{@user_name}.json")
      new_or_saved()
    end
  end

  def new_or_saved
    # Determines if the player wants to use a saved game or create a new one.
    puts 'Would you like to continue your previous game? Y/N?'
    use_saved_game = gets.chomp.downcase
    if use_saved_game == 'y'
      puts 'Pulling info'
      Game.from_saved("./saved_games/#{@user_name}.json")
    elsif use_saved_game == 'n'
      puts 'starting new game'
      Game.new(@user_name)
    else
      puts 'I\'m sorry, I didn\'t understand!  Please answer with Y or N:'
      new_or_saved()
    end
  end
end

# Run Game
Shell.new