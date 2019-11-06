require 'pry'
require 'json'



class Game
  attr_accessor :chosen_letters
  attr_accessor :letters_left_to_guess
  attr_accessor :guesses_remaining
  attr_accessor :RANDOMLY_PICKED_WORD
  attr_accessor :user_name

  def initialize(user_name, chosen_letters = [], guesses_remaining = 5, letters_left_to_guess = false, randomly_picked_word = [])
    determine_magic_word(letters_left_to_guess, randomly_picked_word)
    @chosen_letters = chosen_letters
    @guesses_remaining = guesses_remaining
    @user_name = user_name
    interface
  end

  def to_save_file
    info = { user_name: @user_name,
             chosen_letters: @chosen_letters,
             guesses_remaining: @guesses_remaining,
             letters_left_to_guess: @letters_left_to_guess,
             randomly_picked_word: @RANDOMLY_PICKED_WORD }
    info.to_json
  end

  def self.from_saved(location)
    data = File.read(location)
    saved_data = JSON.parse(data)
    self.new(saved_data["user_name"], saved_data["chosen_letters"], saved_data["guesses_remaining"], saved_data["letters_left_to_guess"], saved_data["randomly_picked_word"])
  end

  def determine_magic_word (letters_left_to_guess, randomly_picked_word)
    if letters_left_to_guess == false
      @letters_left_to_guess = create_magic_word
    else
      @letters_left_to_guess = letters_left_to_guess
      @RANDOMLY_PICKED_WORD = randomly_picked_word
    end
  end

  def create_magic_word
    word_file = '5desk.txt'
    random_word = File.readlines(word_file).sample.strip.downcase
    @RANDOMLY_PICKED_WORD = random_word.split('')
    random_word.split('')
  end

  def interface
    check_for_win_or_loss
    show_image
    show_letters_display
    pull_user_input
    determine_result
  end

  def pull_user_input
    puts 'Please enter a letter or enter \'1\' to save and quit'
    @user_letter = gets.chomp.downcase
    if @user_letter == '1'
      save_and_quit
    else
    @chosen_letters << @user_letter
    end
  end

  def save_and_quit
    filename = "./saved_games/#{@user_name}.json"
    File.open(filename, 'w') do |file|
      file.puts self.to_save_file
    exit
    end
  end

  def determine_result
    if @letters_left_to_guess.include? @user_letter
      guess_was_correct(@user_letter)
    else
      puts 'That letter is not included!'
      @guesses_remaining -= 1
      interface
    end
  end

  def check_for_win_or_loss
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
    else
      return
    end
  end

  def show_letters_display
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
    @letters_left_to_guess.each_with_index do |l, i|
      if l == letter
        @letters_left_to_guess.delete_at(i)
        guess_was_correct(letter)
      end
    end
    interface
  end
end

class Shell
  def initialize
    intro
    create_new_player
  end

  def intro
    display = File.read("./art/intro")
    puts display
  end

  def create_new_player
    puts 'Hello, and welcome to Hangman!  What is your name?'
    @user_name = gets.chomp.downcase
    if !File.exist?("./saved_games/#{@user_name}.json")
      Game.new(@user_name)
    elsif File.exist?("./saved_games/#{@user_name}.json")
      new_or_saved()
    end
  end

  def new_or_saved
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

Shell.new