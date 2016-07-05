require "./deck.rb"

class Game
  attr_accessor :player, :name, :dealer, :deck, :pwins, :totalgames, :totalblackjacks, :playersplit

  def initialize(name="Jack")
    @name = name
    @dealer = []
    @player = []
    @playersplit = []
    @deck = Deck.new
    @pwins = 0
    @totalgames = 0
    @totalblackjacks = 0
  end

  def play
    intro
    deal
    playeraction
    dealeraction unless playervalue > 21 && ((playersplit.length>1 && value > 21)|| playersplit.length == 0)
    evaluatehands
    playagain
  end

  def intro
    puts "Time to play a round of blackjack, #{name}."
  end

  def deal
    self.dealer += @deck.draw(2)
    self.player += @deck.draw(2)
  end

  def playeraction
    dealershow1
    handshow
    handvalue
    blackjack if playervalue == 21
    hitorstand if (playervalue <21 && dealervalue != 21)||(player.length == 2 && playervalue == 22)
  end

  def dealershow1
    puts "Dealer is showing a #{dealer.first.face} of #{dealer.first.suit}."
    puts "Dealer has a blackjack!" if dealervalue == 21
  end

  def dealershowall
    puts "Dealer hand has:"
    dealer.map{|x| puts "#{x.face} of #{x.suit}"}
  end

  def handshow(hand= player)
    puts "Your hand has:"
    hand.map{|x| puts "#{x.face} of #{x.suit}"}
  end

  def handvalue
    puts "You currently sit at:"
    puts player.inject(0){|sum,x| sum += x.value}
  end

  def blackjack
    puts "BLACKJACK!"
    self.totalblackjacks += 1
  end

  def playervalue
    player.inject(0){|sum,x| sum += x.value}
  end

  def splitvalue
    playersplit.inject(0){|sum,x| sum += x.value}
  end

  def dealervalue
    dealer.inject(0){|sum,x| sum += x.value}
  end

  def splitcheck
    player.first.face == player.last.face && playersplit.length == 0 && player.length == 2
  end

  def hitorstand
    response = ""
    until response == "s" or (playervalue >= 21 unless player.length == 2)
      puts "Please select an option: stand (s), hit (h) advice (a) split (p)" if splitcheck
      puts "Please select an option: stand (s), hit (h) advice (a)" if !splitcheck
      response = gets.chomp&.downcase[0]
        advisor if response == "a"
      hitloop if response == "h"
      splithand if response == "p" && splitcheck
    end
  end

  def hitloop
    self.player += @deck.draw
    handshow
    acevaluecheck(playervalue,player)
    handvalue
    bustmessage
  end

  def splithand
    self.playersplit += player.shift(1)
    sphitorstand
    puts "Returning to main hand"
    handshow
    handvalue
  end

  def sphitorstand
    puts "Now playing split hand."
    playersplit.map{|x| puts "#{x.face} of #{x.suit}"}
    puts "Your split hand value is #{splitvalue}."
    response = ""
    until response == "s" or splitvalue >= 21
      puts "Please select an option: stand (s), hit (h) advice (a)"
      response = gets.chomp&.downcase[0]
      advisor(splitvalue,playersplit) if response == "a"
      sphitloop if response == "h"
    end
  end

  def sphitloop
    self.playersplit += @deck.draw
    handshow(playersplit)
    acevaluecheck(splitvalue,playersplit)
    split = playersplit.inject(0){|sum,x| sum += x.value}
    puts "You currently sit at:"
    puts split
    puts "Oh no, you've busted." if split > 21
  end

  def advisor(score=playervalue,hand=player)
    acestrat(score) if hasace?(hand)
    hardstrat(score) if !hasace?(hand)
  end

  def hasace?(hand=player)
    hand.any?{|x| x.face == "Ace" && x.value == 11}
  end

  def hardstrat(score=playervalue)
    if score.between?(2,11)
      puts "Based on your hand value of #{score}, the recommended play is to hit regardless of dealer upcard."
    elsif score.between?(12,15)
      puts "Based on your hand value of #{score}, the recommended play is to stand if the dealer is showing a #{dealer.first.face}." if dealer.first.value <6
      puts "Based on your hand value of #{score}, the recommended play is to hit if dealer is showing a #{dealer.first.face}." if dealer.first.value >5
    elsif score >= 16
      puts "Based on your hand value of #{score}, the recommended play is to stand."
    else
      puts "Need advice for this situation."
    end
  end

  def acestrat(score=playervalue)
    if score.between?(11,17)
      puts "Based on your soft hand value of #{score}, the recommended play is to hit."
    elsif score == 18
      puts "Based on your soft hand value of #{score}, the recommended play is to hit if the dealer is showing a #{dealer.first.face}." if dealer.first.value.between?(3,5)||dealer.first.value.between?(9,11)
    elsif score == 18
      puts "Based on your hand value of #{score}, the recommended play is to stand if the dealer is showing a #{dealer.first.face}." if dealer.first.value.between?(6,8)||dealer.first.value == 2
    elsif score > 18
      puts "Based on your hand value of #{score}, the recommended play is to stand."
    else
      puts "Need advice for this situation."
    end
  end

  def acevaluecheck(score,hand)
    if score > 21 && hand.any?{|x| x.face == "Ace" && x.value == 11}
      hand.select{|x| x.face == "Ace" && x.value == 11}.last.acevalchange
      puts "Ace value is now 1."
    end
  end

  def bustmessage(score=playervalue)
    puts "Oh no, you've busted." if score > 21
  end

  def dealeraction
    dealershowall
    puts "Dealer has a #{dealervalue}."
    acevaluecheck(dealervalue,dealer)
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
    splitwins if playersplit.length>0
    dealerwins
    tie
    tiesplit if playersplit.length>0
  end

  def playerwins
    if (playervalue > dealervalue && playervalue <22) || (playervalue < 22 && dealervalue >21)
      puts "Congratulations #{name}, your hand wins!"
      self.pwins += 1
    elsif (playervalue <= 21 && player.length>5)
      puts "Congratulations #{name}, you win since your hand has over 5 cards!"
      self.pwins += 1
    end
  end

  def splitwins
    if (splitvalue > dealervalue && splitvalue <22) || (splitvalue < 22 && dealervalue >21)
      puts "Congratulations #{name}, your split hand wins!"
      self.pwins += 1
    elsif (splitvalue <= 21 && playersplit.length>5)
      puts "Congratulations #{name}, you win since your split hand has over 5 cards!"
      self.pwins += 1
    end
  end

  def dealerwins
    puts "Sorry, dealer beats your main hand. (#{playervalue})" if (((dealervalue > playervalue && dealervalue < 22) || (dealervalue < 22 && playervalue > 21)) && player.length < 6)
    puts "Sorry, dealer beats your split hand. (#{splitvalue})" if (((dealervalue > splitvalue && dealervalue < 22) || (dealervalue < 22 && splitvalue > 21)) && playersplit.length.between?(1,6))
  end

  def tie
    if (playervalue == dealervalue && playervalue <22 && dealervalue <22)
      if player.length > dealer.length
        puts "It's a tie, but you had more cards in your hand so you win!"
        self.pwins += 1
      elsif player.length == dealer.length
        puts "It's a tie and you and the dealer had the same number of cards in hand, so you win!"
        self.pwins += 1
      elsif (player.length == 2 and playervalue == 21) && dealer.length > player.length
        puts "Blackjack! You win!"
        self.pwins += 1
      else player.length < dealer.length
        puts "It's a tie, but since the dealer had more cards in hand, you lose."
      end
    end
  end

  def tiesplit
    if (splitvalue == dealervalue && splitvalue <22 && dealervalue <22)
      if playersplit.length > dealer.length
        puts "It's a tie, but you had more cards in your split hand so you win!"
        self.pwins += 1
      elsif playersplit.length == dealer.length
        puts "It's a tie and you and the dealer had the same number of cards in hand, so your split wins!"
        self.pwins += 1
      elsif (playersplit.length == 2 and splitvalue == 21) && dealer.length > playersplit.length
        puts "Blackjack! You win!"
        self.pwins += 1
      else playersplit.length < dealer.length
        puts "It's a tie, but since the dealer had more cards in hand, your split loses."
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
    puts "There are #{deck.shoe.length} cards remaining, new shoe in #{deck.shoe.length-100} cards."
    self.deck = Deck.new if deck.shoe.length < 100
  end

  def gamereset
    shoecheck
    dealer.clear
    player.clear
    playersplit.clear
  end

  def gamestats
    puts "You played #{totalgames} games of blackjack and won #{pwins} of them. You had #{totalblackjacks} blackjacks."
  end

end

Game.new.play

# = 3.times.map{Card.new(3,"Clubs")}
