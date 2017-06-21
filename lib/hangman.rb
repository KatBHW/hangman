puts "Hangman initialized"

word_list = File.readlines "wordlist.txt"

# Create dictionary of words between 5 and 12 letters in length

all_words = word_list.collect { |word| word.strip.downcase } 
dictionary = []

all_words.each do |word|
  if (word.length > 4) && (word.length < 13)
    dictionary << word
  end
end

# Generate answer
answer = dictionary.sample.chars
puts answer.join # temporarily display answer to ease testing
 
# Generate board
answer_board = Array.new(answer.length, " _")
puts answer_board.join
 
# Play game 
  selections_left = 3 # temporarily set at three to speed up testing
  counter = 0 
  until (answer_board == answer) || (selections_left == 0)
    puts "Please enter a letter:"
    guess_letter = gets.chomp.to_s.downcase
    answer.each_with_index do |letter, index|
      if letter == guess_letter
        answer_board[index] = guess_letter
      end
    end 
    selections_left -= 1  
    puts answer_board.join(" ")
  end


 
 




