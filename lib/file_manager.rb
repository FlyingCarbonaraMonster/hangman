# frozen_string_literal: true

class FileManager
  FILE_PATH = File.expand_path('../data/words.txt', __dir__)
  SAVE_PATH = File.expand_path('../saves', __dir__)

  def random_word; end

  def save_game(secret_word, guesses, remaining_turns); end

  def list_saves; end

  def load_game(filename); end
end
