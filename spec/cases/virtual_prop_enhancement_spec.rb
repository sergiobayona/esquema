# frozen_string_literal: true

require "spec_helper"

RSpec.describe "A schema with multiple objects" do
  let(:user) do
    Class.new(ActiveRecord::Base) do
      include Esquema::Model
      self.table_name = "users"

      def self.name
        "User"
      end

      enhance_schema do
        property :name, title: "System User Name"
        virtual_property :tags, type: :array, items: { type: :string }
        virtual_property :foo, type: :string
        virtual_property :bar, type: :number, default: 5
      end
    end
  end

  it "includes the virtual property with an array of strings" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "tags": {
                                                   "type": "array",
                                                   "title": "Tags",
                                                   "items": {
                                                     "type": "string"
                                                   }
                                                 }
                                               }
                                             })
  end

  it "includes the virtual property with a string" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "foo": {
                                                   "type": "string",
                                                   "title": "Foo"
                                                 }
                                               }
                                             })
  end

  it "includes the virtual property with a number" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "bar": {
                                                   "type": "number",
                                                   "title": "Bar",
                                                   "default": 5
                                                 }
                                               }
                                             })
  end
end
