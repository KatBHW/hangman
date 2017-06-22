class Game

attr_reader :word_list, :dictionary, :answer, :answer_board, :incorrect_letters
attr_writer :selections_left

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
  puts
  puts "You have 12 attempts to guess the secret word which is between five and 12 letters long."
  puts
   # temporarily display answer to ease testing
  puts "For those of you in the audience, the secret word is: #{answer.join}"
end

# Check guess is valid and correct
def check_guess
  guess_letter = gets.chomp.to_s.downcase
    if (("a".."z").include?(guess_letter)) && (!answer.include?(guess_letter))
      incorrect_letters << guess_letter  
    elsif !("a".."z").include?(guess_letter)
      puts "Invalid entry. Please try again."
      @selections_left += 1    
    else  
      answer.each_with_index do |letter, index|
        if letter == guess_letter
          answer_board[index] = guess_letter
        end
      end 
    end 
  @selections_left -= 1  
end 

# Play game 
def play_game
  create_dictionary
  answers_and_guesses
  welcome
  until (answer_board == answer) || (@selections_left == 0)
    puts 
    print "Your guess: "
    check_guess
    puts 
    print "Correct guesses: "
    puts answer_board.join(" ").upcase
    puts 
    puts "Incorrect guesses: #{incorrect_letters.join(" ").upcase}"
    puts 
    puts "You have #{@selections_left} guesses left."
    puts "__________________________________"
    puts "Well done. You correctly guessed: #{answer.join.upcase}" if answer_board == answer
  end
  puts
  puts "Bad luck. The answer was: #{answer.join.upcase}" if answer_board != answer
  puts
end
end

game = Game.new
game.play_game