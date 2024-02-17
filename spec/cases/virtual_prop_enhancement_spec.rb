# frozen_string_literal: true

require "spec_helper"

RSpec.describe "A schema with multiple objects" do
  before do
    module Enhanced
      class User < ActiveRecord::Base
        include Esquema::Model

        enhance_schema do
          property :name, title: "System User Name"
          virtual_property :tags, type: :array, items: { type: :string }
        end
      end
    end
  end
  it "includes the virtual property with an array of strings" do
    expect(Enhanced::User.json_schema).to include_json({
                                                         "title": "User",
                                                         "type": "object",
                                                         "properties": {
                                                           "id": {
                                                             "type": "integer",
                                                             "title": "Id"
                                                           },
                                                           "name": {
                                                             "type": "string",
                                                             "title": "System User Name"
                                                           },
                                                           "email": {
                                                             "type": "string",
                                                             "title": "Email"
                                                           },
                                                           "group": {
                                                             "type": "integer",
                                                             "title": "Group"
                                                           },
                                                           "dob": {
                                                             "type": "date",
                                                             "title": "Dob"
                                                           },
                                                           "salary": {
                                                             "type": "number",
                                                             "title": "Salary"
                                                           },
                                                           "active": {
                                                             "type": "boolean",
                                                             "default": false,
                                                             "title": "Active"
                                                           },
                                                           "bio": {
                                                             "type": "string",
                                                             "title": "Bio"
                                                           },
                                                           "country": {
                                                             "type": "string",
                                                             "default": "United States of America",
                                                             "title": "Country"
                                                           },
                                                           "preferences": {
                                                             "title": "Preferences"
                                                           },
                                                           "created_at": {
                                                             "type": "date-time",
                                                             "title": "Created at"
                                                           },
                                                           "updated_at": {
                                                             "type": "date-time",
                                                             "title": "Updated at"
                                                           },
                                                           "tags": {
                                                             "type": "array",
                                                             "title": "Tags",
                                                             "items": {
                                                               "type": "string"
                                                             }
                                                           }
                                                         },
                                                         "required": %w[
                                                           id
                                                           name
                                                           email
                                                           group
                                                           dob
                                                           salary
                                                           active
                                                           bio
                                                           country
                                                           preferences
                                                           created_at
                                                           updated_at
                                                           tags
                                                         ]
                                                       })
  end
end
