module Esquema
  class ModelMeta
    DEFINITIONS = %w[attributes associations validations]

    def initialize(model)
      @model = model
    end

    def model
      raise ArgumentError, 'not an AR model' unless @model.ancestors.include?(ActiveRecord::Base)

      @model
    end

    def attributes
      model.columns.sort_by(&:name).map do |column|
        {
          column.name => {
            'type': column.type,
            'limit': column.limit,
            'default': column.default,
            'null': column.null
          }
        }
      end
    end

    def associations
      model.reflect_on_all_associations.sort_by(&:name).map do |assoc|
        {
          assoc.name => {
            'type': assoc.macro,
            'options': assoc.options
          }
        }
      end
    end

    # group validations by model attribute
    def validations
      model.validators.map(&:attributes).flatten.uniq.sort.map do |attribute|
        {
          attribute => get_validations(attribute)
        }
      end
    end

    def scopes
      model.methods(false).grep(/scope/).map(&:to_s).sort
    end

    def methods
      model.methods(false).grep_v(/scope/).map(&:to_s).sort
    end

    private

    def get_validations(attribute)
      validators = model.validators.select do |v|
        v.attributes.include?(attribute)
      end

      validators.map do |validator|
        {
          'type': validator.class.to_s.demodulize,
          'options': validator.options
        }
      end
    end # get_validations
  end
end
