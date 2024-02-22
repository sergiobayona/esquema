# frozen_string_literal: true

require "spec_helper"

RSpec.describe "enhanced schema" do
  let(:model) do
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
end
