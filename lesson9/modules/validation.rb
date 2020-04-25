# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations
    def validate(name, type, *options)
      @validations ||= []
      @validations << { name: name, type: type, options: options }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        validation_name = instance_variable_get("@#{validation[:name]}")
        send validation[:type], validation_name, validation[:options]
      end
    end

    def valid?
      valididate!
      true
    rescue StandardError
      false
    end

    def presence(name, *_option)
      raise 'Аргумент не существует.' if name.nil? || name.empty?
    end

    def format(name, format)
      raise 'Неверный формат.' unless name =~ format[0]
    end

    def type(name, type)
      raise 'Неверный тип.' unless name.instace_of?(type)
    end
  end
end
