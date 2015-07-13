module ActiveRecordExtension
  extend ActiveSupport::Concern

  def normalize_blank_values
     puts "test"
    attributes.each do |column, value|
      self[column].present? || self[column] == false || self[column] = nil
    end
  end

  module ClassMethods
    def normalize_blank_values
      before_save :normalize_blank_values
    end
  end

end

ActiveRecord::Base.send(:include, ActiveRecordExtension)