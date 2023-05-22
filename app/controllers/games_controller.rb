require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def dictionary_check(attempt)
    dictionary = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    JSON.parse(dictionary)["found"]
  end

  def grid_check(attempt, grid)
    characters = attempt.upcase.chars
    characters.all? { |char| characters.count(char) <= grid.count(char) }
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    if dictionary_check(attempt) && grid_check(attempt, grid) == true
      { score: attempt.length, message: "Well done!" }
    elsif dictionary_check(attempt) == false
      { score: 0, message: "That's not an english word." }
    elsif grid_check(attempt, grid) == false
      { score: 0, message: "That's not in the grid." }
    end
  end

  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @result = run_game(params[:guess], params[:grid])
  end
end
