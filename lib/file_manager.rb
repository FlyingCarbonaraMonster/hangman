# frozen_string_literal: true

require 'json'
require 'fileutils'

class FileManager
  FILE_PATH = File.expand_path('../data/words.txt', __dir__)
  SAVE_PATH = File.expand_path('../saves', __dir__)

  def random_word
    File.readlines(FILE_PATH, chomp: true).select { |word| word.length.between?(5, 12) }.sample.downcase
  end

  def save_game(secret_word, guesses, remaining_turns)
    filename = "#{Time.now.strftime('%Y%m%d_%H%M%S')}.json"
    save_file = { secret_word: secret_word, guesses: guesses, remaining_turns: remaining_turns }.to_json
    FileUtils.mkdir_p(SAVE_PATH)
    File.write(File.join(SAVE_PATH, filename), save_file)
    filename
  end

  def list_saves
    return [] unless Dir.exist?(SAVE_PATH)

    Dir.children(SAVE_PATH).select { |file| file.end_with?('.json') }.sort
  end

  def load_game(filename)
    file = File.read(File.join(SAVE_PATH, filename))
    deserialized_file = JSON.parse(file, symbolize_names: true)
    deserialized_file.values_at(:secret_word, :guesses, :remaining_turns)
  end

  def delete_save(filename)
    FileUtils.rm_f(File.join(SAVE_PATH, filename))
  end
end
