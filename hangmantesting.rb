require 'pry'

class Game
  attr_accessor :chosen_letters
  attr_accessor :letters_left_to_guess
  attr_accessor :guesses_remaining
  attr_accessor :RANDOMLY_PICKED_WORD

  def initialize(chosen_letters = [], guesses_remaining = 5, letters_left_to_guess = false, randomly_picked_word = [])
    determine_magic_word(letters_left_to_guess, randomly_picked_word)
    @chosen_letters = chosen_letters
    @guesses_remaining = guesses_remaining
    interface
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
    puts 'Please enter a letter'
    @user_letter = gets.chomp.downcase
    @chosen_letters << @user_letter
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
      `say "You Won! CONGRATULATIONS!"`
      display = File.read('./art/winscreen')
      puts display
      exit
    elsif @guesses_remaining <= 0
      display = File.read('./art/you_dead')
      puts display
      puts "YOU DEAD. The word was '#{@RANDOMLY_PICKED_WORD.join}'"
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

chosen_letters = ['e', 'i']
guesses_remaining = 4
letters_left_to_guess = ['h', 'l', 'l', 'o']
randomly_picked_word = ['h', 'e', 'l', 'l', 'o']

this_game = Game.new(chosen_letters, guesses_remaining, letters_left_to_guess, randomly_picked_word)
