
class Item
  attr_reader :name, :str, :wis, :agil, :acc, :evd, :attack, :defense, :usable

  def initialize(name, str, wis, agil, acc, evd, attack, defense, usable = false)
    @name = name
    @str = str
    @wis = wis
    @agil = agil
    @acc = acc
    @evd = evd
    @attack = attack
    @defense = defense
    @usable = usable
  end

  def to_s
    "#{name}"
  end

end

class Spell < Item
  attr_reader :cost, :accuracy

  def initialize(name, cost, accuracy, attack, defense, str = 0, wis = 0, agil = 0, acc = 0, evd = 0)
    super name, str, wis, agil, acc, evd, attack, defense, usable = false
    @cost = cost
    @accuracy = accuracy
  end

end

class Weapon < Item
  def initialize(name, attack)
    super name, 0, 0, 0, 0, 0, attack, 0
  end

end

class Armor < Item
  def initialize(name, defense)
    super name, 0, 0, 0, 0, 0, 0, defense
  end

end

class Accessory < Item
  def initialize(name, str, wis, agil, acc, evd)
    super name, str, wis, agil, acc, evd, 0, 0
  end

end

