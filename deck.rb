require './card.rb'

class Deck
  attr_accessor :cards, :shoe

  def initialize
    # @cards = Card.faces.map{|face| Card.suits.map{|suit| Card.new(face,suit)}}.flatten.shuffle
    @shoe = 7.times.map{Card.faces.map{|face| Card.suits.map{|suit| Card.new(face,suit)}}}.flatten.shuffle
  end

  def howmanyleft?
    self.cards.length
  end

  def draw(num=1)
    shoe.shift(num)
  end

  def shuffledeck
    @cards.shuffle!
  end

end
