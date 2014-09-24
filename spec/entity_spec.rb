require_relative '../entity'

describe Entity do
  ENTITY_NAME = 'entity'

  before(:each) do
    @template = Template.new('template', 100, 100, 25, 25, 30, 50, 50)
    @entity = Entity.new(ENTITY_NAME, @template)
  end

  it 'should have a name' do
    @entity.name.should eq ENTITY_NAME
  end

  it 'shold be level 1' do
    @entity.level.should eq 1
  end

  it 'should have 0 exp' do
    @entity.exp.should eq 0
  end

  it 'shold have same stats as template' do
    { :hp => :hp_base, :mp => :mp_base, :strength => :str_base, :wisdom => :wis_base,
      :agility => :agil_base, :accuracy => :acc_base, :evade => :evd_base }.each do |k, v|
      @entity.send(k).should eq @template.send(v)
    end
  end

  it 'should have 0 attack' do
    @entity.attack.should eq 0
  end

  it 'should have 0 defense' do
    @entity.defense.should eq 0
  end

  describe 'hit_phys?' do
    before(:each) do
      srand 1
    end

    it 'should hit self' do
      @entity.hit_phys?(@entity).should be_true
    end

    it 'should be true' do
      new_template = Template.new('template', 100, 100, 25, 25, 30, 50, 0) 
      new_entity = Entity.new(ENTITY_NAME, new_template)
      puts "evade: #{new_entity.evade}"
      @entity.hit_phys?(new_entity).should be_true
    end

    it 'should be false' do
      new_template = Template.new('template', 100, 100, 25, 25, 30, 50, 100)
      new_entity = Entity.new(ENTITY_NAME, new_template)
      puts "evade: #{new_entity.evade}"
      @entity.hit_phys?(new_entity).should be_false
    end

  end

  it 'should hit_magic?'

  it 'should dmg_phys'
  it 'should dmg_magic'
  it 'should initiative'
  it 'should take_damage'
  it 'should use_mp'
  it 'should gain_exp'

  describe 'to_s' do
    it 'should print statistics' do
      @entity.to_s.should eq "#{ENTITY_NAME}[1-Lvl]: #{@template.hp_base}/#{@template.hp_base}-HP #{@template.mp_base}/#{@template.mp_base}-MP]"
    end
  end

end

