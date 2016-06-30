require './card.rb'

class Deck
  attr_accessor :cards

  def initialize
    @cards = Card.faces.map{|face| Card.suits.map{|suit| Card.new(face,suit)}}.flatten.shuffle
  end

  def howmanyleft?
    self.cards.length
  end

  def draw(num=1)
    cards.shift(num)
  end


  # def newdeck
  #   self.cards = FACES.map{|face| SUITS.map{|suit| Card.new(face,suit)}}.flatten.shuffle
  # end

  def shuffledeck
    @cards.shuffle!
  end

end
