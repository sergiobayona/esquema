# frozen_string_literal: true

RSpec.describe Esquema::Property do
  subject(:property) { Esquema::Property.new(name: 'first_name', type: :string) }

  it "does something useful" do
    expect(property).to be_a(Esquema::Property)
  end

  it "returns the name of the property" do
    expect(property.name).to eq('first_name')
  end

  it "returns the type of the property" do
    expect(property.type).to eq(:string)
  end

  it "returns the default value of the property" do
    expect(property.default).to eq(nil)
  end

  it "returns the title of the property" do
    expect(property.title).to eq(nil)
  end

  it "returns the description of the property" do
    expect(property.description).to eq(nil)
  end

  it "returns the item type of the property" do
    expect(property.item_type).to eq(nil)
  end

end
