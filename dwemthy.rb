# 
# dwemthy.rb - 
# Writeen By: Nick DiPasquale
# Copyright (c) 2012 DarkSide Software
# All Rights Reserved.
#

require_relative 'entity'
require_relative 'item'

module Dwemthy

  def self.create_score_chart
    #   name,		kill count, score
    [ [ 'Arthur Pendragon',	6, 99_999_999 ],
      [ 'Nick D.',		5, 6_000 ],
      [ 'Vince F.',		4, 1_000 ],
      [ 'Terra B.',		3, 500 ],
      [ 'Cecil H.',		2, 100 ]
    ]
  end

  def self.create_templates
    #		   	name,	 	 hp,  mp,  str, wis, agil, acc, evd
    { :s => Template.new('Sorcerer',	 75, 40, 15, 25, 30, 40, 20),
      :r => Template.new('Rogue',	120, 20, 30, 20, 40, 60, 40),
      :w => Template.new('Warrior',	180, 10, 50, 15, 20, 80, 20)
    }
  end

  def self.create_array
    #		  name,			lvl,	  exp,	   hp,	  mp, str, wis, agil, acc, evd, attack, defense
    [ Character.new(Monster.new('Rabbite',		 1,        79,      5,     0,  10,  10,  70,  70,   5,   1,   1),
        'A Rabbite enteres from off stage.  It has fangs and looks a bit frothy.',
        'Rabbite bites you with its fangs',
        'Rabbite misses you.',
        'Rabbite spins around and heals',
        'Rabbite runs away unsuccessfully...',
        'Rabbite bites it.'),
      Character.new(Monster.new('Kuroneko',		 2,       120,      7,     0,  80,  20,  30,  70,  10,   2,   2),
        'A black cat strides out of the shadows of the Array.',
        'The cat scratches you',
        'The cat misses you.',
        'Damage what damage, the cat has healed',
        'The cat runs over and jumps up on a ledge then begins to leer at you again.',
        'You slice the cat in twain, you awful person, you.'),
      Character.new(Monster.new('Dobby',		 5,       200,     12,   999,  20,  80,  20,  60,  10,   4,   2),
        '"Master Potter?", you hear as a gangly short goblin appears in front of you.',
        'Dobby casts a sparling light array and slaps you while you are dazed',
        'Dobby misses you, you are not going to fall for that one.',
        'Dobby begins to glow and his wounds close healing',
        'Dobby tries to vaporate unsuccessfully.',
        'You squash Dobby underfoot.'),
      Character.new(Monster.new('Usra Major',		10,     1_000,    100,    20,  70,  10,  30,  40,  20,  25,  20),
        'With all the noise a wild bear has awoken from its hibernation, it looks angry.',
        'Ursa Major mauls you',
        'Usra Major swings and misses.',
        'Ursa Major fades into the shadows and a starfield appears within it heals',
        'The bear roars and starts to circle you.',
        'The bear lets out a final roar and then its lifeless limp body crashes to the ground.'),
      Character.new(Monster.new('Red\'s Pikachu',	75,     5_000,    250,    15,  95, 100, 120,  95,  25,  25,  20),
        "Red would like to battle!  Red sends out Pikachu.\nPika, pikachu!",
        'Pikachu uses THUNDERBOLT',
        'Pikachu\'s attack misses.',
        'Red used super potion and healed',
        'Cannot flee from trainer battle.',
        'Red\'s Pikachu fainted.'),
      Character.new(Monster.new('Dagron',		99, 5_000_000, 99_999, 9_999, 255, 255, 255, 100, 100, 255, 255),
        'Smoke starts rising from the back of the Array and a shadowy black form starts to rise from the mist, you are greeted by a giant black dragon!',
        'Dagron smites you with its breath weapon',
        'Dagron somehow misses.',
        'Dagron\'s scales shine with an effulgent glow and as it heals',
        'Dagron flies off into the depths of the Array; then, you wake up from your day dream and it is still in front of you staring at you hungrily.',
        'Congratulations, you have hacked the program and defeated the Dagron, you are no Arthur Pendragon.')
    ]
  end

  def self.create_player(templates)
    print 'What, is your name? '
    name = gets.strip
    print 'What, is your quest? '
    quest = gets.strip
    clazz = ''
    begin
      print 'What, is your class([S]orcerer, [R]ogue, [W]arrior)? '
      clazz = gets.strip.downcase
    end while (clazz != 's') && (clazz != 'r') && (clazz != 'w')
    Character.new Player.new(name, quest, templates[clazz.to_sym]),
      'You appear within the Dwemthy\'s Array.',
      'You slash your target with your sword',
      'You miss your target.',
      'You concentrate on your inner strength and heal',
      'You try to run away but you trip and fall over your shoelaces.',
      "#{name} was never seen again."
  end

  def self.insert_and_print(top_scores, player, kill_count)
      index = top_scores.find_index {|score| score[2] <= player.exp }
      top_scores.insert(index, [ player.name, kill_count, player.exp ]) unless index.nil?
      top_scores = top_scores[0..4]
      puts 'Top Scores:'
      puts '-' * 20
      top_scores.each_with_index {|score, index| puts "#{index + 1}.  #{score[0]}  #{score[1]}  #{score[2]}" }
      puts
      index += 1 unless index.nil?
      puts "#{index || '-'}.  #{player.name}  #{kill_count}  #{player.exp}"
      puts
  end

  def self.play
    puts "Dwemthy's Array"
    puts 'Written By: Nick DiPasquale'
    puts 'Copyright (c) 2012 DarkSide Software'

    top_scores = create_score_chart
    begin
      templates = create_templates
      player = create_player templates
      array = create_array
      array_index = 0
      @@heal ||= Spell.new 'Heal', 2, 100, 75, 0
      player.weapon_left = Weapon.new 'Sword', 34
      player.armor = Armor.new 'Leather', 31
      puts
      puts player.tag_line
      puts

      begin
        foe = array[array_index]
        puts foe.tag_line
        puts

        entities = do_initiative player, foe
        do_combat player, foe, entities

        if player.hp > 0 then
          player.gain_exp foe.exp
          array_index += 1
        end
      end while (player.hp > 0) && (array_index < array.length)

      insert_and_print(top_scores, player, array_index)
      answer = do_game_over
    end while /y[es]?/i =~ answer
  end

  def self.do_initiative(player, foe)
    entities = {
      player.initiative => { :attacker => player, :target => foe, :cmd_func => lambda {|entity| get_player_command entity } },
      foe.initiative => { :attacker => foe, :target => player, :cmd_func => lambda {|entity| get_compy_command entity } }
    }
    entities = entities.sort.collect {|entity| entity[1] }
  end

  def self.do_game_over
    begin
      print 'Game Over.  Would you like to play again(yes/no)? '
      answer = gets.strip.downcase
    end while !(/y[es]?/i =~ answer) && !(/n[o]?/i =~ answer)
    answer
  end

  def self.do_combat player, foe, entities
    begin
      puts player, foe 

      entities.each do |entity|
        next if entity[:attacker].hp <= 0
        command = entity[:cmd_func].call entity[:attacker]
        execute_command command, entity[:attacker], entity[:target]
      end 
      puts
    end while (player.hp > 0) && (foe.hp > 0)
    puts "#{foe.epitath}" if foe.hp <= 0
  end

  def self.get_player_command(player)
    @@commands ||= [ 'a', 'h', 'r', 'attack', 'heal', 'run' ]
    command = ''
    begin
      print "Command([A]ttack/[H]eal (#{player.mp / @@heal.cost})/[R]un)? "
      command = gets.strip.downcase
    end while @@commands.find {|cmd| cmd == command }.nil?
    command
  end

  def self.get_compy_command(compy)
    return 'a'
  end

  def self.execute_command(command, attacker, target)
    case command
    when 'a' then do_attack attacker, target
    when 'attack' then do_attack attacker, target
    when 'h' then do_heal attacker, attacker
    when 'heal' then do_heal attacker, attacker
    when 'r' then do_run attacker
    when 'run' then do_run attacker
    end
  end

  def self.do_attack(attacker, target)
    dmg = attacker.dmg_phys(target) if attacker.hit_phys? target
    target.take_dmg dmg unless dmg.nil?
    puts "#{attacker.hit_line} for #{dmg} damage." unless dmg.nil?
    puts "#{attacker.miss_line}" if dmg.nil?
    # puts "#{target.name} takes #{dmg} damage." unless dmg.nil?
    # puts "#{attacker.name} misses #{target.name}." if dmg.nil?
  end

  def self.do_heal(attacker, target)
    if attacker.mp > @@heal.cost then
      dmg = attacker.dmg_magic(target) if attacker.hit_magic? target, @@heal
      attacker.use_mp @@heal.cost
      target.take_dmg -dmg unless dmg.nil?
      puts "#{target.heal_line} for #{dmg} hp." unless dmg.nil?
      # puts "#{target.name} heals #{dmg} hp." unless dmg.nil?
    end
  end
    
  def self.do_run(attacker)
    puts "#{attacker.run_line}"
    # puts "#{attacker.name} trips and falls on their shoelaces."
  end

end

# Dwemthy::play

