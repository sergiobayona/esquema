RSpec.describe "A schema with multiple objects" do
  let(:company) {}
  subject(:serializer) { Esquema::Serializer.new(Company) }

  it "has a default value for excluded_models" do
    puts JSON.parse serializer.serialize
  end
end
