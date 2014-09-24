
class Template
  attr_reader :name, :hp_base, :mp_base, :str_base, :wis_base, :agil_base, :acc_base, :evd_base

  def initialize(name, hp_base, mp_base, str_base, wis_base, agil_base, acc_base, evd_base)
    @name = name
    @hp_base = hp_base
    @mp_base = mp_base
    @str_base = str_base
    @wis_base = wis_base
    @agil_base = agil_base
    @acc_base = acc_base
    @evd_base = evd_base
  end

  def to_s
    "#{name}"
  end

end

class Entity
  attr_reader :name, :level, :exp, :hp, :mp

  def initialize(name, template)
    @name = name
    @level = 1
    @exp = 0
    @hp_max = @hp = template.hp_base
    @mp_max = @mp = template.mp_base
    @str = template.str_base
    @wis = template.wis_base
    @agil = template.agil_base
    @acc = template.acc_base
    @evd = template.evd_base
    @attack = @defense = 0
  end

  def strength
    @str
  end

  def wisdom
    @wis
  end

  def agility
    @agil
  end

  def accuracy
    @acc
  end

  def evade
    @evd
  end

  def attack
    @attack
  end

  def defense
    @defense
  end

  def hit_phys?(target)
    return true if target == self
    hpc, epc = rand(100), rand(100)
    puts "phys? #{accuracy} < #{hpc} || #{target.evade} > #{epc} == #{accuracy < hpc || target.evade > epc}"
    # return false if hpc >= accuracy
    # return false if epc <= target.evade
    # accuracy < hpc || target.evade > epc # original
    accuracy > hpc || target.evade < epc
  end

  def hit_magic?(target, spell)
    return true if target == self
    acc = spell.accuracy + level - target.level
    hpc, epc = rand(100), rand(100)
    puts "magic? #{acc} < #{hpc} || #{target.evade} > #{epc} == #{acc < hpc || target.evade > epc}"
    acc < hpc || target.evade > epc
  end

  def dmg_phys(target)
    pwr = attack + rand(attack / 8)
    mod = (level * strength) / 128 + 2 # weapon.calc_modifier(self)
    res = target.defense # weapon.calc_resistance(target)
    puts "phys (#{pwr} - #{res}) * #{mod} == #{(pwr - res) * mod}"
    dmg = (pwr - res) * mod
    return 0 if dmg < 0
    return 9999 if dmg > 9999
    dmg
  end

  def dmg_magic(target, spell)
    pwr = spell.attack + rand(spell.attack / 8)
    mod = (level * wisdom) / 256 + 4 # spell.calc_modifier(self)
    res = target.wisdom # spell.calc_resistance(target)
    puts "magic (#{pwr} - #{res}) * #{mod} == #{(pwr - res) * mod}"
    dmg = (pwr - res) * mod
    return 0 if dmg < 0
    return 9999 if dmg > 9999
    dmg
  end

  def initiative
    agility + rand((level * agility) / 128)
  end

  def take_dmg(damage)
    @hp -= damage
  end

  def use_mp(amount)
    @mp -= amount
  end

  def gain_exp(amount)
    @exp += amount
  end

  def to_s
    "#{name}[#{level}-Lvl]: #{hp}/#{@hp_max}-HP #{mp}/#{@mp_max}-MP]"
  end

end

class Monster < Entity
  def initialize(name, level, exp, hp_max, mp_max, str, wis, agil, acc, evd, attack, defense)
    super name, Template.new(name, hp_max, mp_max, str, wis, agil, acc, evd)
    @level = level
    @exp = exp
    @attack = attack
    @defense = defense
  end 

end

class Player < Entity
  attr_reader :quest

  def initialize(name, quest, template)
    super name, template
    @quest = quest

    @equip = {
      :weapon_left => nil, :weapon_right => nil,
      :helm => nil, :armor => nil,
      :accessory1 => nil, :accessory2 => nil
    }
  end 

  def weapon_left
    @equip[:weapon_left]
  end

  def weapon_left=(weapon)
    @equip[:weapon_left] = weapon
  end

  def weapon_right
    @equip[:weapon_right]
  end

  def weapon_right=(weapon)
    @equip[:weapon_right] = weapon
  end

  def helm
    @equip[:helm]
  end

  def helm=(helm)
    @equip[:helm] = helm
  end

  def armor
    @equip[:body]
  end

  def armor=(armor)
    @equip[:armor] = armor
  end

  def accessory1
    @equip[:accessory1]
  end

  def accessory1=(accessory)
    @equip[:accessory1] = accessory
  end

  def accessory2
    @equip[:accessory2]
  end

  def accessory2=(accessory)
    @equip[:accessory2] = accessory
  end

  def strength
    item_sum(@str, :str)
  end 

  def wisdom
    item_sum(@wis, :wis)
  end 

  def agility
    item_sum(@agil, :agil)
  end 

  def accuracy
    item_sum(@acc, :acc)
  end 

  def evade
    item_sum(@evd, :evd)
  end 

  def attack
    item_sum(@attack, :attack)
  end 

  def defense
    item_sum(@defense, :defense)
  end 

private
  def item_sum(initial, method)
    value = initial
    @equip.each_value {|item| value += (item.public_send method) if !item.nil? }
    value
  end

end

class Character
  attr_reader :tag_line, :hit_line, :miss_line, :heal_line, :run_line, :epitath

  def initialize(entity, tag_line, hit_line, miss_line, heal_line, run_line, epitath)
    @entity = entity
    @tag_line = tag_line
    @hit_line = hit_line
    @miss_line = miss_line
    @heal_line = heal_line
    @run_line = run_line
    @epitath = epitath
  end 

  def method_missing(meth, *args, &block)
    @entity.send meth, *args, &block
    # super
  end 

  def to_s
    @entity.to_s unless @entity.nil?
  end 

end

