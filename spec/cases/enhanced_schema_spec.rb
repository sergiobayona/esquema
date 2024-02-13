# frozen_string_literal: true

RSpec.describe "A schema with multiple objects" do
  module Bar
    class User < ActiveRecord::Base
      include Esquema::Model

      enhance_schema do
        model_description "A user of the system"
        property :name, description: "The user's name", title: "Full Name"
        property :group, enum: [1, 2, 3], default: 1, description: "The user's group"
      end
    end
  end

  subject(:model) { Bar::User }

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
    puts model.json_schema
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
