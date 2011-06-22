module MediaMonster

  class Task < Model

    attr_accessor :task_type  #string
    attr_accessor :options    #hash
    attr_accessor :result     #string
    attr_accessor :call_back  #string
    attr_accessor :label      #string

    def initialize(*args)
      super
      if args[0].is_a?(String) || args[0].is_a?(Symbol)
        self.task_type   = args[0].to_s
        self.options     = args[1]
        self.result      = args[2].to_s
        self.call_back   = args[3].to_s
        self.label       = args[4].to_s
      end
    end

  end

end