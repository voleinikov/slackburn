module BotViews
  class Base
    attr_accessor :errors

    class << self
      # Monkeypatch attr_accessor class method to add all  
      # attr_accessors to an attributes hash for reflection 
      # (this is used in the initialize method further down).
      def attr_accessor(*vars)
        @attributes ||= []
        @attributes.concat vars
        super
      end
    
      def attributes
        @attributes
      end
    end
  
    def attributes
      self.class.attributes
    end

    def initialize params = {}
      @errors = []
      
      params.each do |k, v|
        # Don't want to declare errors as an attr_accessor in each child class 
        # and declaring it in the Base happens *before* the class method is monkeypatched
        # so it still raises the below. 
        if k == :errors || self.attributes.include?(k) 
          self.send("#{k}=", v)
        else
          raise 'Please include any expected param passed to this view in the attr accessors list of the child class'
        end
      end
    end

    def render
      raise 'Please implement a render method for this view'
    end
  end
end
