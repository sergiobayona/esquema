# frozen_string_literal: true

RSpec.describe Esquema::Configuration do
  describe "default settings" do
    it "has a default value for excluded_models" do
      expect(Esquema.configuration.excluded_models).to eq([])
    end

    it "has a default value for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq([])
    end
  end

  describe "custom configuration" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_models = ["User"]
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    after(:each) do
      # Reset configuration to default
      Esquema.configuration.reset
    end

    it "allows setting custom values for excluded_models" do
      expect(Esquema.configuration.excluded_models).to eq(["User"])
    end

    it "allows setting custom values for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq(%i[id created_at updated_at deleted_at])
    end

    it "resets the configuration to default" do
      Esquema.configuration.reset
      expect(Esquema.configuration.excluded_models).to eq([])
      expect(Esquema.configuration.excluded_columns).to eq([])
    end
  end
end
