class ApplicationService
  extend Dry::Initializer
  include Dry::Monads[:result]
  extend Dry::Core::ClassAttributes

  defines :permissible_errors
  permissible_errors []
 
  def self.call(**args)
    validation = self::Schema.call(args)   
    return Failure.new(validation.errors) unless validation.success?

    new(**args).call
  
  rescue StandardError => error
    handle_error(error)     
  end
  
  def self.handle_error(error)
    raise error unless permissible_errors.any? { |type| 
      type === error }  
    
    Failure.new(error)
  end

end