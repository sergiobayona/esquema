# frozen_string_literal: true

require "spec_helper"

RSpec.describe "enhanced schema" do
  subject(:model) do
    Class.new(ActiveRecord::Base) do
      include Esquema::Model
      self.table_name = "users"

      def self.name
        "User"
      end

      enhance_schema do
        model_description "A user of the system"
        property :name, description: "The user's name", title: "Full Name"
        property :group, enum: [1, 2, 3], default: 1, description: "The user's group"
      end
    end
  end

  it "includes the custom description" do
    expect(model.json_schema).to include_json({ title: "User", description: "A user of the system" })
  end

  it "includes the custom property values" do
    expect(model.json_schema).to include_json({
                                                properties: {
                                                  name: {
                                                    description: "The user's name",
                                                    title: "Full Name"
                                                  }
                                                }
                                              })
  end

  it "includes the custom enum, default and description" do
    expect(model.json_schema).to include_json({
                                                properties: {
                                                  group: {
                                                    enum: [1, 2, 3],
                                                    default: 1,
                                                    description: "The user's group"
                                                  }
                                                }
                                              })
  end

  context "model with mismatched default type" do
    subject(:model) do
      Class.new(ActiveRecord::Base) do
        include Esquema::Model
        self.table_name = "users"

        def self.name
          "User"
        end

        enhance_schema do
          model_description "A user of the system"
          property :name, default: 554
        end
      end
    end

    it "raises an error" do
      expect { model.json_schema }.to raise_error(ArgumentError, "Default value must be of type string")
    end
  end

  context "model with mismatched default type" do
    subject(:model) do
      Class.new(ActiveRecord::Base) do
        include Esquema::Model
        self.table_name = "users"

        def self.name
          "User"
        end

        enhance_schema do
          model_description "A user of the system"
          property :name, enum: [1, 2, 3]
        end
      end
    end

    it "raises an error" do
      expect { model.json_schema }.to raise_error(ArgumentError, "Enum values must be of type string")
    end
  end
end
