# frozen_string_literal: true

RSpec.describe Esquema::Configuration do
  after(:each) do
    # Reset configuration to default
    Esquema.configuration.reset
  end

  describe "default settings" do
    it "has a default value for excluded_models" do
      expect(Esquema.configuration.excluded_models).to eq([])
    end

    it "has a default value for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq([])
    end
  end

  describe "reseting" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_models = ["User"]
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    it "resets the configuration to default" do
      Esquema.configuration.reset
      expect(Esquema.configuration.excluded_models).to eq([])
      expect(Esquema.configuration.excluded_columns).to eq([])
      expect(Esquema.configuration.exclude_foreign_keys).to eq(true)
    end
  end

  describe "exclude a model" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_models = ["Task"]
      end
    end

    it "does not include the excluded model in the schema" do
      employee_schema = Esquema::Serializer.new(Employee).serialize
      expect(Esquema.configuration.excluded_models).to eq(["Task"])
      expect(employee_schema).not_to include_json({
                                                    properties: {
                                                      tasks: {
                                                        title: "Tasks"
                                                      }
                                                    }
                                                  })
    end
  end

  describe "excluded columns" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    it "allows setting custom values for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq(%i[id created_at updated_at deleted_at])
    end

    it "excludes columns from the schema" do
      employee_schema = Esquema::Serializer.new(Employee).serialize
      expect(employee_schema).not_to include_json({
                                                    properties: {
                                                      id: {
                                                        title: "Id"
                                                      },
                                                      created_at: {
                                                        title: "Created at"
                                                      },
                                                      updated_at: {
                                                        title: "Updated at"
                                                      },
                                                      deleted_at: {
                                                        title: "Deleted at"
                                                      }
                                                    }
                                                  })
    end
  end

  describe "exclude foreign keys" do
    it "is true by default" do
      expect(Esquema.configuration.exclude_foreign_keys).to eq(true)
    end

    it "allows setting custom values for exclude_foreign_keys" do
      Esquema.configure do |config|
        config.exclude_foreign_keys = false
      end

      expect(Esquema.configuration.exclude_foreign_keys).to eq(false)
    end

    it "excludes foreign keys from the schema" do
      Esquema.configure do |config|
        config.exclude_foreign_keys = false
      end

      employee_schema = Esquema::Serializer.new(Employee).serialize
      expect(employee_schema).to include_json({
                                                properties: {
                                                  company_id: {
                                                    title: "Company"
                                                  }
                                                }
                                              })
    end

    it "excludes foreign keys from the schema" do
      Esquema.configure do |config|
        config.exclude_foreign_keys = true
      end

      employee_schema = Esquema::Serializer.new(Employee).serialize
      expect(employee_schema).not_to include_json({
                                                    properties: {
                                                      company_id: {
                                                        title: "Company"
                                                      }
                                                    }
                                                  })
    end
  end
end
