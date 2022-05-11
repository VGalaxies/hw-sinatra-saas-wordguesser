class LocalWordGenerator
  def self.get_word
    arr = IO.readlines("dict/words") # relative to root
    return arr[Random.new.rand(0...arr.length)].strip
  end
end

class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :check_win_or_lose

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @word_with_guesses = "-" * word.length
    @check_win_or_lose = :play
  end

  def guess(word)
    if word == nil
      raise ArgumentError
    end

    if word.empty?
      raise ArgumentError
    end

    if not word =~ /[a-zA-Z]/
      raise ArgumentError
    end

    word.downcase!
    
    if @guesses.include?(word)
      return false
    end

    if @wrong_guesses.include?(word)
      return false
    end

    if @word.include?(word)
      @guesses += word
    else
      @wrong_guesses += word
    end

    arr = @word_with_guesses.split(//)
    arr.each_index do |index|
      if @guesses.include?(@word[index])
        arr[index] = @word[index]
      end
    end

    @word_with_guesses = arr.join

    if not @word_with_guesses.include?("-")
      @check_win_or_lose = :win
    end

    if @guesses.length + @wrong_guesses.length >= 7
      @check_win_or_lose = :lose
    end
    
    return true
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
