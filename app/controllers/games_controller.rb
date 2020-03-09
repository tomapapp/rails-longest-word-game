require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    abc_arr = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << abc_arr[rand * abc_arr.length] }
  end

  def score
    @score = 0
    @letters = params['letters'].downcase
    @word = params['input_word'].downcase
    @word_arr = @word.split('')
    @valid = @word_arr.all? do |letter|
      @word_arr.count(letter) <= @letters.count(letter)
    end
    json_raw = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    @exists = JSON.parse(json_raw)['found']
    if @valid && @exists
      @result = "Congratulations! #{@word} is a valid English word!"
      @score += @word.length
      session[:score] += @score
    elsif @valid && @exists == false
      @result = "Sorry but #{@word} does not seem to be a valid English word"
    else
      @result = "Sorry, #{@word} can't be built out of #{@letters.upcase.split(' ').join(',')}"
    end
  end
end
