module MediaMonster

  class Job < Model

    attr_accessor :priority     # Now supports a numeric value
    attr_accessor :job_type     # which type of job is this? audio to start, video, document, etc.
    attr_accessor :original     # file location
    attr_accessor :call_back    # url for webhook
    attr_accessor :tasks        # array of tasks
    
    # for retry logic, you can set a number of times to retry (retry_max)
    # and how long to wait before try in seconds (retry_delay)
    attr_accessor :retry_max
    attr_accessor :retry_delay    

    def initialize(*args)
      super
      @tasks = []
    end

    def tasks=(as)
      # puts "adding each task..."
      if as[0].is_a?(String) || as[0].is_a?(Symbol) || as[0].is_a?(Hash)
        self.add_task(*as)
      else
        as.each{|a| self.add_task(*a)}
      end
    end

    def add_sequence(*args)
      new_sequence = Sequence.new
      @tasks << new_sequence
      yield new_sequence
    end
        
    def add_task(*args)
      @tasks ||= []
      new_task = if (args.length == 1 && args[0].is_a?(MediaMonster::Task))
        args[0]
      else
        MediaMonster::Task.new(*args)
      end
      @tasks << new_task
    end
    
    def retry!
      MediaMonsterClient.retry_job self
    end

  end

end
