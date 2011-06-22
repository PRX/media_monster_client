require 'rubygems'

begin
  require 'active_support'
  require 'active_support/core_ext'
  require 'active_support/json/encoding'
  require 'active_support/all'
rescue LoadError=>err
  # puts "LoadError:#{err.message}"
end


require 'oauth'
require 'json'
require 'cgi'

require 'media_monster'


module MediaMonsterClient
  class << self

    attr_accessor :key, :secret, :scheme, :host, :port, :version

    def create_job(job=nil)
      job ||= MediaMonster::Job.new
      yield job
      post(create_url("jobs"), job.to_json, {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
    
    def update_task(task_id, task_status)
      json = {'task'=>{'status'=>task_status}}.to_json
      put(create_url("tasks/#{task_id.to_i}"), json, {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end

    protected

    def create_url(path)
      "/api/#{version}/#{path}"
    end

    [:delete, :get, :head, :post, :put, :request].each do |method|
      define_method method do |*args|
        access_token.send(method, *args)
      end
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(key,
                                        secret,
                                        :site               => "#{scheme || 'http'}://#{host}:#{port}",
                                        :http_method        => :get)
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer)
    end

  end

end
