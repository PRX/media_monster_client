module MediaMonster

  class Sequence < Model

    # attr_accessor :options    #hash
    # attr_accessor :result     #string
    attr_accessor :call_back  #string
    attr_accessor :label      #string
    attr_accessor :tasks  #array

    def initialize(*args)
      super
      self.tasks = []
    end

    def add_task(*args)
      new_task = if (args.length == 1 && args[0].is_a?(MediaMonster::Task))
        args[0]
      else
        MediaMonster::Task.new(*args)
      end
      
      self.tasks << new_task
    end

  end

end