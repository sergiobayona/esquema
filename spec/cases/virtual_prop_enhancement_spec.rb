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
        virtual_property :tags, type: :array, items: { type: :string }, minItems: 1, maxItems: 5
        virtual_property :email, type: :string, format: :email
        virtual_property :bar, type: :number, default: 5
        virtual_property :baz, type: :integer, minimum: 0, maximum: 100
        virtual_property :qux, type: :string, maxLength: 10, minLength: 5
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
                                                   },
                                                   "minItems": 1,
                                                   "maxItems": 5
                                                 }
                                               }
                                             })
  end

  it "includes the virtual property with a string" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "email": {
                                                   "type": "string",
                                                   "title": "Email",
                                                   "format": "email"
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

  it "includes the virtual property with an integer" do
    puts user.json_schema
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "baz": {
                                                   "type": "integer",
                                                   "title": "Baz",
                                                   "minimum": 0,
                                                   "maximum": 100
                                                 }
                                               }
                                             })
  end

  it "includes the virtual property with a string and a maximum length" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "qux": {
                                                   "type": "string",
                                                   "title": "Qux",
                                                   "maxLength": 10,
                                                   "minLength": 5
                                                 }
                                               }
                                             })
  end
end
