require_relative 'model_meta'

module Esquema
  class ProjectModels
    EXCLUDED_MODELS = %w[ ActionText::Record
                          ActiveStorage::Record
                          ActionMailbox::Record
                          ApplicationRecord
                          ActionText::RichText
                          ActionText::EncryptedRichText
                          ActiveStorage::VariantRecord
                          ActiveStorage::Attachment
                          ActiveStorage::Blob
                          ActionMailbox::InboundEmail ]
    def self.all
      Rails.application.eager_load!
      all_models = all_ar_descendents.reject { |model| EXCLUDED_MODELS.include?(model) }
      project_models = all_models.sort

      project_models.each_with_object({}) do |model, res|
        res[model] = new(model).definition
      end
    end

    def initialize(model)
      @model = model
    end

    def model
      @model.is_a?(String) ? @model.constantize : @model
    end

    def definition
      ModelMeta::DEFINITIONS.each_with_object({}) do |attribute, _hash|
        _hash[attribute.to_s] = ModelMeta.new(model).send(attribute)
      end
    end

    def self.all_ar_descendents
      ActiveRecord::Base.descendants.map(&:name)
    end
  end
end
