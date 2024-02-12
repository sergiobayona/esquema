# Esquema

Esquema is a Ruby library for JSON Schema generation from ActiveRecord models.

Example:

```ruby
class User < ApplicationRecord
  include Esquema::Model
    # column :name, :string
    # column :email, :string

  end
end
```

Calling `User.json_schema` will return the JSON Schema for the User model:

```json
{
  "title": "User model",
  "description": "Schema representation of the User model",
  "type": "object",
  "properties": {
    "id": {
      "type": "integer"
    },
    "name": {
      "type": "string"
    },
    "email": {
      "type": "string"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

Simply include the `Esquema::Model` module in your ActiveRecord model and call the `json_schema` method to generate the JSON Schema for the model.

There are multiple ways to customize the generated schema:

- Exclude columns by specifying the `exclude_columns` option on the configuration file at "<rails_app>/config/initializer/esquema.rb".

```ruby
    Esquema.configure do |config|
    config.excluded_columns = %i[id created_at updated_at]
    end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/esquema. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/esquema/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Esquema project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/esquema/blob/master/CODE_OF_CONDUCT.md).
