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
      job.tap do |j|
        j_str = post(create_url('jobs'), j.to_json, {'Accept'=>'application/json','Content-Type'=>'application/json'}).body
        json  = JSON.parse(j_str)
        j.id  = json['job']['id']
      end
    end
    
    def update_task(task_id, task_status)
      json = {'task'=>{'status'=>task_status}}.to_json
      put(create_url("tasks/#{task_id.to_i}"), json, {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
    
    def retry_job(job)
      case job
      when MediaMonster::Job then job
      when Fixnum then MediaMonster::Job.new(:id => job)
      when String then MediaMonster::Job.new(:id => job.to_i)   
      end.tap do |j|
        post(retry_url(j), {}, {'Accept'=>'application/json'})
      end
    end

    protected

    def create_url(path)
      "/api/#{version}/#{path}"
    end
    
    def retry_url(model)
      "/api/#{version}/#{model.class.to_s.downcase.pluralize}/#{model.id}/retry"
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
