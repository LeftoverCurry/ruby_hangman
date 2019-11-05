require 'pry'

class Game
  attr_accessor :chosen_letters
  attr_accessor :magic_word
  attr_accessor :letters_remaining

  def initialize(chosen_letters = [], letters_remaining = 5, magic_word = 0)
    if magic_word == 0
      @magic_word = create_magic_word
    else
      @magic_word = magic_word
    end
    @chosen_letters = chosen_letters
    @letters_remaining = letters_remaining
    user_makes_guess(@chosen_letters, @letters_remaining)
  end

  def create_magic_word
    word_file = '5desk.txt'
    random_word = File.readlines(word_file).sample.strip
    random_word.split('')
  end

  def user_makes_guess(chosen_letters = @chosen_letters , letters_remaining = @letters_remaining)
    check_for_win_or_loss
    show_image
    puts 'Please enter a letter'
    letter = gets.chomp.downcase
      if @magic_word.include? letter
        guess_was_correct(letter)
      else 
        puts 'That letter is not included!'
        @letters_remaining -= 1
        user_makes_guess(@chosen_letters, @letters_remaining)
      end
  end

  def guess_was_correct(letter)
    @magic_word.each_with_index do |l, i|
      if l == letter
        @magic_word.delete_at(i)
        guess_was_correct(letter)
      end
    end
    user_makes_guess
    
  end

  def show_image
    case @letters_remaining
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
  
  def check_for_win_or_loss
    if @magic_word == []
        `say "You Won! CONGRATULATIONS!"`
        display = File.read('./art/winscreen')
        puts display
        exit
    elsif @letters_remaining <= 0
      display = File.read('./art/you_dead')
      puts display
      puts 'YOU DEAD.'
      `say "you dead."`
      exit
    end
  end

  def letters_display

  end
end


this_game = Game.new
