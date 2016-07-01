class Card
  attr_accessor :value, :suit, :face

  def self.faces
    [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"]
  end

  def self.suits
    ["Hearts", "Diamonds", "Spades", "Clubs"]
  end

  def initialize(face,suit)
    self.suit = suit
    self.face = face
    facevalcalc
  end

  def facevalcalc
    if self.face.is_a? String
      facevalues = {"Jack" => 10, "Queen" => 10, "King" => 10, "Ace" => 11}
      self.value = facevalues[face]
    else
      self.value = face
    end
  end

end





# gt.player.each do |x|
#   puts "#{x.face} of #{x.suit}"
# end
#
# gt.player.map{|x| puts "#{x.face} of #{x.suit}"}
