require 'yaml'

class Game

  attr_reader :word_list, :dictionary, :answer, :answer_board, :incorrect_letters
  attr_accessor :selections_left

  def initialize
    @word_list = File.readlines "wordlist.txt"
    @dictionary = []
    @selections_left = 12
  end   

# Create dictionary of words between 5 and 12 letters in length
  def create_dictionary
    all_words = word_list.collect { |word| word.strip.downcase } 
    all_words.each do |word|
      if (word.length > 4) && (word.length < 13)
        dictionary << word
      end
    end 
  end 

# Generate answer, answer board and array for storing incorrect guesses
  def answers_and_guesses
    @answer = dictionary.sample.chars
    @answer_board = Array.new(answer.length, " _")
    @incorrect_letters = []
  end 
 
# Welcome message
  def welcome
    puts "Welcome to Hangman." 
    puts "You have 12 attempts to guess a secret word between five and 12 letters long."
    # temporarily display answer to ease testing
    puts "For those of you in the audience, the secret word is: #{answer.join.upcase}"
  end

# Check guess is valid and correct
  def check_guess
    guess_letter = gets.chomp.to_s.downcase
      if !("a".."z").include?(guess_letter)
        puts "Invalid entry. Please try again."
        @selections_left += 1 
      elsif !answer.include?(guess_letter)
        incorrect_letters << guess_letter  
      else  
        answer.each_with_index do |letter, index|
          if letter == guess_letter
            answer_board[index] = guess_letter
          end
        end 
      end 
    @selections_left -= 1  
  end 

# Run until game is won or turns run out
  def game_turns
    until (answer_board == answer) || (selections_left == 0)
      puts 
      print "Your guess: "
      check_guess
      print "Correct guesses: "
      puts answer_board.join(" ").upcase #need to put something in to check whether it exists
      puts "Incorrect guesses: #{incorrect_letters.join(" ").upcase}"
      puts "Well done. You correctly guessed: #{answer.join.upcase}" if answer_board == answer
        if (selections_left > 0) && (answer_board != answer)
          print "Save game? Y/N: "
          save_option = gets.chomp
          if !save_option =~ /[YyNn]/
            puts "Invalid entry. Please try again: "
            save_option = gets.chomp
          elsif save_option =~ /[Yy]/
            save_game
            exit  
          end 
        end    
      puts "__________________________________"
      selections_left == 1? plural = "guess" : plural = "guesses"
      puts "You have #{selections_left} #{plural} left." if answer_board != answer
    end
    puts "Bad luck. The answer was: #{answer.join.upcase}" if answer_board != answer
    puts 
  end  

# Save game 
  def save_game
	saved_data = [@answer, @answer_board, @incorrect_letters, @selections_left]
	File.open('saved_game.yml', 'w') { |vars| vars.write(YAML.dump(saved_data)) }
	exit
  end

# Load saved game  
  def load_saved_game
    input_data = YAML.load(File.read('saved_game.yml'))
    @answer = input_data[0]
    @answer_board = input_data[1]
    @incorrect_letters = input_data[2]
    @selections_left = input_data[3]
  end

# Play game 
  def play_new_game
    create_dictionary
    answers_and_guesses
    welcome
    game_turns
  end
  
  def play_saved_game
    load_saved_game
    game_turns
  end

 def select_game_type
    print "Type 'L' to load a saved game or 'N' to start a new game: "
    game_type = gets.chomp
      if !game_type =~ /[LNln]/
        print "Invalid entry. Please try again: "
        game_type = gets.chomp
      elsif game_type =~ /[Ll]/
        play_saved_game
      elsif game_type =~ /[Nn]/
        play_new_game
      end  
  end
end

game = Game.new
game.select_game_type