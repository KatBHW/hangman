word_list = File.readlines "wordlist.txt"

# Create dictionary of words between 5 and 12 letters in length

all_words = word_list.collect { |word| word.strip.downcase } 
dictionary = []

all_words.each do |word|
  if (word.length > 4) && (word.length < 13)
    dictionary << word
  end
end

# Generate answer, answer board and array for storing incorrect guesses
answer = dictionary.sample.chars
answer_board = Array.new(answer.length, " _")
incorrect_letters = []
 
# Welcome message
puts "Welcome to Hangman." 
puts
puts "You have 12 attempts to guess the secret word which is between five and 12 letters long."
puts
 # temporarily display answer to ease testing
puts "For those of you in the audience, the secret word is: #{answer.join}"

# Play game 
  selections_left = 12 
  counter = 0 
  until (answer_board == answer) || (selections_left == 0)
    puts 
    print "Your guess: "
    guess_letter = gets.chomp.to_s.downcase
      if (("a".."z").include?(guess_letter)) && (!answer.include?(guess_letter))
        incorrect_letters << guess_letter  
      elsif !("a".."z").include?(guess_letter)
        puts "Invalid entry. Please try again."
        selections_left += 1    
      else  
        answer.each_with_index do |letter, index|
          if letter == guess_letter
            answer_board[index] = guess_letter
          end
        end 
      end 
    selections_left -= 1  
    puts 
    print "Correct guesses: "
    puts answer_board.join(" ").upcase
    puts 
    puts "Incorrect guesses: #{incorrect_letters.join(" ").upcase}"
    puts 
    puts "You have #{selections_left} guesses left."
    puts "__________________________________"
    if answer_board == answer
      puts
      puts "Well done. You correctly guessed the answer: #{answer.join.upcase}"
    end  
  end
puts
puts "Bad luck. The answer was: #{answer.join.upcase}" if answer_board != answer
puts


  


 
 




