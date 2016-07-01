require "./deck.rb"


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
    playeraction
    dealeraction
    evaluatehands
    # outcome
    playagain
  end

  def intro
    puts "Time to play a round of blackjack, #{name}."
  end

  def deal
    @dealer += @deck.draw(2)
    @player += @deck.draw(2)
  end

  def playeraction
    dealershow1
    playershow
    handvalue
    puts "BLACKJACK!" if playervalue == 21
    hitorstand if playervalue <21
  end

  def dealershow1
    puts "Dealer is showing a #{dealer.first.face} of #{dealer.first.suit}."
  end

  def dealershowall
    puts "Dealer hand has:"
    dealer.map{|x| puts "#{x.face} of #{x.suit}"}
  end

  def playershow
    puts "Your hand has:"
    player.map{|x| puts "#{x.face} of #{x.suit}"}
  end

  def handvalue
    puts "You currently sit at:"
    puts playervalue
  end

  def playervalue
    player.inject(0){|sum,x| sum += x.value}
  end

  def dealervalue
    dealer.inject(0){|sum,x| sum += x.value}
  end

  def hitorstand
    response = ""
    until response == "s" or playervalue >= 21
      puts "Would you like to hit or stand?"
      response = gets.chomp&.downcase[0]
      if response == "h"
      hitloop
      end
    end
  end

  def hitloop
    @player += @deck.draw
    playershow
    handvalue
    checkplayerbust
  end

  # def dealerhitloop
  #   @dealer += @deck.draw
  #   puts "Dealer has:"
  #   player.map{|x| puts "#{x.face} of #{x.suit}"}
  # end


  def checkplayerbust
    puts "Oh no, you've busted." if playervalue > 21
  end

  def dealeraction
    dealershowall
    puts "Dealer has a #{dealervalue}."
    while dealervalue < 16
      puts "Dealer hits!"
      @dealer += @deck.draw
      dealershowall
      puts "Dealer has a #{dealervalue}."
    end
    puts "Dealer busts!" if dealervalue > 21
  end

  def evaluatehands
    if (dealervalue > playervalue && dealervalue < 22) || (dealervalue < 22 && playervalue > 21)
      puts "Sorry, dealer wins."
    elsif (playervalue > dealervalue && playervalue <22) || (playervalue < 22 && dealervalue >21)
      puts "Congratulations #{name}, you win!"
    elsif playervalue == dealervalue
      puts "It's a tie, but guess what, you win!"
    elsif playervalue >21 && dealervalue >21
      puts "You and the dealer bust, it's a push."
    else
      puts "check conditions, outside of evaluatehands"
    end
  end

  def playagain
    puts "Would you like to play another game?"
    response = gets.chomp&.downcase[0]
    if response == "y"
      gamereset
      play
    else
      puts "OK then, thanks for playing."
    end
  end

  def gamereset
    self.deck=Deck.new
    dealer.clear
    player.clear
  end

end
