class Game
  attr_accessor :player, :name, :dealer, :deck

  def initialize(name="Jack")
    @name = name
    @dealer = []
    @player = []
    @deck = Deck.new
    @discard = []
  end

  def play
    intro
    deal
    # playeraction
    # dealeraction
    # evaluatehands
    # outcome
    # reset/playagain?
  end

    def intro
      puts "Time to play a round of blackjack #{name}."
    end

    def deal
      @dealer += @deck.draw(2)
      @player += @deck.draw(2)
    end





end
