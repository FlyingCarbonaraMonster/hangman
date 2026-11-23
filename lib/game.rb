# frozen_string_literal: true

require_relative 'display'
require_relative 'file_manager'

class Game
  MAX_ATTEMPTS = 10

  def initialize
    @display = Display.new
    @file_manager = FileManager.new
    @secret_word = @guesses = @remaining_turns = nil
  end

  def play
    setup_game
    @display.intro
    until game_over?
      @display.display_board(@secret_word, @guesses, @remaining_turns)
      process_input(player_input)
    end
    won? ? @display.win_message : @display.lose_message(@secret_word)
  end

  private

  def setup_game
    save_list = @file_manager.list_saves
    return new_game if save_list.empty?

    @display.message('Do you want to start a new game(1) or load a previous game(2)?')
    user_input = gets.chomp
    user_input == '2' ? load_saved_game(save_list) : new_game
  end

  def load_saved_game(save_list)
    save_list.each_with_index { |save, idx| @display.message("#{idx + 1} - #{save}") }
    @display.message('Choose a save file:')
    chosen_save_file = gets.chomp.to_i
    @secret_word, @guesses, @remaining_turns = @file_manager.load_game(save_list[chosen_save_file - 1])
  end

  def new_game
    @secret_word = @file_manager.random_word
    @guesses = []
    @remaining_turns = MAX_ATTEMPTS
  end

  def player_input
    loop do
      @display.message("Type a letter, a word or 'save' to save the current game.")
      user_input = gets.chomp.downcase
      return user_input if valid_input?(user_input)

      @display.message('Invalid input, try again.')
    end
  end

  def valid_input?(user_input)
    return true if user_input == 'save'

    return false unless !user_input.empty? && user_input.chars.all? { |char| ('a'..'z').include?(char) }

    return true if user_input.length == 1 && !@guesses.include?(user_input)

    user_input.length.between?(2, @secret_word.length)
  end

  def process_input(user_input)
    return save_and_exit if user_input == 'save'

    return process_word(user_input) if user_input.length > 1

    @guesses << user_input
    @remaining_turns -= 1 unless @secret_word.include?(user_input)
  end

  def save_and_exit
    @file_manager.save_game(@secret_word, @guesses, @remaining_turns)
    @display.message('Save completed.')
    exit
  end

  def process_word(word)
    if word == @secret_word
      @guesses.concat(@secret_word.chars)
    else
      @remaining_turns -= 1
      @display.message("Wrong word, remaining turns: #{@remaining_turns}")
    end
  end

  def won?
    @secret_word.chars.all? { |letter| @guesses.include?(letter) }
  end

  def game_over?
    won? || @remaining_turns.zero?
  end
end
