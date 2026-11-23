# frozen_string_literal: true

class Display
  def intro
    puts 'Welcome to Hangman! Enter your guesses one letter at a time, or write an entire word.'
    puts 'Remember, you can type "save" to save the current game.'
  end

  def display_board(secret_word, guesses, remaining_turns)
    displayed_word = secret_word.chars.map { |letter| guesses.include?(letter) ? letter : '_' }
    incorrect_letters = guesses.reject { |letter| secret_word.include?(letter) }
    puts "#{displayed_word.join(' ')}\nIncorrect letters: #{incorrect_letters.join(' ')}"
    puts "Remaining turns: #{remaining_turns}"
  end

  def message(text)
    puts text
  end

  def win_message(secret_word)
    puts "That's right! The word was #{secret_word}, congratulations!"
  end

  def lose_message(secret_word)
    puts "You lost, better luck next time! The secret word was #{secret_word}"
  end
end
