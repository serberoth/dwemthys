require_relative '../entity'

describe Template do
  NAME = 'template'

  before(:each) do
    @template = Template.new(NAME, 100, 100, 25, 25, 30, 50, 50)
  end

  it 'should have a name' do
    @template.name.should eq NAME
  end

  describe 'to_s' do
    it 'should print the template name' do
      @template.to_s.should eq @template.name
    end
  end

end

