require "./deck.rb"

class Game
  attr_accessor :player, :name, :dealer, :deck, :pwins, :totalgames, :totalblackjacks

  def initialize(name="Jack")
    @name = name
    @dealer = []
    @player = []
    @deck = Deck.new
    @pwins = 0
    @totalgames = 0
    @totalblackjacks = 0
  end

  def play
    intro
    deal
    playeraction
    dealeraction unless playervalue > 21
    evaluatehands
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
    blackjack if playervalue == 21
    hitorstand if playervalue <21 && dealervalue != 21
  end

  def dealershow1
    puts "Dealer is showing a #{dealer.first.face} of #{dealer.first.suit}."
    puts "Dealer has a blackjack!" if dealervalue == 21
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

  def blackjack
    puts "BLACKJACK!"
    self.totalblackjacks += 1
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
      hitloop if response == "h"
    end
  end

  def hitloop
    @player += @deck.draw
    playershow
    acevaluecheck(playervalue,player)
    handvalue
    bustmessage
  end

  def acevaluecheck(score,user)
    if score > 21 && user.any?{|x| x.face == "Ace"}
      user.select{|x| x.face == "Ace"}.map{|x| x.acevalchange}
      puts "Ace value is now 1."
    end
  end

  def bustmessage
    puts "Oh no, you've busted." if playervalue > 21
  end

  def dealeraction
    dealershowall
    puts "Dealer has a #{dealervalue}."
    while dealervalue < 16
      @dealer += @deck.draw
      puts "Dealer hits and draws a #{dealer.last.face} of #{dealer.last.suit}."
      acevaluecheck(dealervalue,dealer)
      dealershowall
      puts "Dealer has a #{dealervalue}."
    end
    puts "Dealer busts!" if dealervalue > 21
  end

  def evaluatehands
    playerwins
    dealerwins
    tie
  end

  def playerwins
    if (playervalue > dealervalue && playervalue <22) || (playervalue < 22 && dealervalue >21)
      puts "Congratulations #{name}, you win!"
      self.pwins += 1
    elsif (playervalue < 21 && player.length>5)
      puts "Congratulations #{name}, you win since you have over 5 cards!"
      self.pwins += 1
    end
  end

  def dealerwins
    puts "Sorry, dealer wins." if (((dealervalue > playervalue && dealervalue < 22) || (dealervalue < 22 && playervalue > 21)) && player.length < 6)
  end

  def tie
    if (playervalue == dealervalue && playervalue <22 && dealervalue <22)
      if player.length > dealer.length
        puts "It's a tie, but you had more cards in your hand so you win!"
        self.pwins += 1
      elsif player.length == dealer.length
        puts "It's a tie and you and the dealer had the same number of cards in hand, so you win!"
        self.pwins += 1
      else player.length < dealer.length
        puts "It's a tie, but since the dealer had more cards in hand, you lose."
      end
    end
  end

  def playagain
    self.totalgames += 1
    puts "Would you like to play another game?"
    response = gets.chomp&.downcase[0]
    if response == "y"
      gamereset
      play
    else
      puts "OK then, thanks for playing."
      gamestats
    end
  end

  def shoecheck
    puts "There are #{deck.shoe.length} cards remaining, new shoe in #{deck.shoe.length-52} cards."
    self.deck = Deck.new if deck.shoe.length < 52
  end

  def gamereset
    shoecheck
    dealer.clear
    player.clear
  end

  def gamestats
    puts "You played #{totalgames} games of blackjack and won #{pwins} of them. You had #{totalblackjacks} blackjacks."
  end

end


# = 3.times.map{Card.new(3,"Clubs")}
