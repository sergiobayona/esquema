# frozen_string_literal: true

require "spec_helper"

module Multi
  class User < ActiveRecord::Base
    include Esquema::Model
    has_many :tasks, class_name: "Multi::Task"
  end

  class Task < ActiveRecord::Base
    belongs_to :user, class_name: "Multi::User"
  end
end

RSpec.describe "A schema with a nested object" do
  it "includes the associated model schema" do
    expect(Multi::User.json_schema).to include_json({
                                                      "title": "User",
                                                      "type": "object",
                                                      "properties": {
                                                        "id": {
                                                          "type": "integer",
                                                          "title": "Id"
                                                        },
                                                        "name": {
                                                          "type": "string",
                                                          "title": "Name"
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
                                                        "tasks": {
                                                          "type": "array",
                                                          "title": "Tasks",
                                                          "items": {
                                                            "title": "Task",
                                                            "type": "object",
                                                            "properties": {
                                                              "id": {
                                                                "type": "integer",
                                                                "title": "Id"
                                                              },
                                                              "title": {
                                                                "type": "string",
                                                                "title": "Title"
                                                              },
                                                              "created_at": {
                                                                "type": "date-time",
                                                                "title": "Created at"
                                                              },
                                                              "updated_at": {
                                                                "type": "date-time",
                                                                "title": "Updated at"
                                                              }
                                                            },
                                                            "required": %w[
                                                              id
                                                              title
                                                              created_at
                                                              updated_at
                                                            ]
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
                                                      ]
                                                    })
  end
end
