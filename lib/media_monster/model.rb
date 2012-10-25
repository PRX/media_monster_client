module MediaMonster

  class Model

    attr_accessor :id
    attr_accessor :status

    def initialize(*args)
      return unless args
      if args[0].is_a?(Hash)
        args[0].each{|k,v| self.send("#{k.to_s}=".to_sym, v)}
      end
    end
  
    if defined?(as_json)
      def as_json_with_class_name(options={})
        {self.class.name.demodulize.underscore.to_sym => as_json_without_class_name(options)}
      end

      alias_method_chain :as_json, :class_name
    else

      def to_json(options = {})
        ActiveSupport::JSON.encode({self.class.name.demodulize.underscore.to_sym => instance_values}, options)
      end
      
    end

  end

end