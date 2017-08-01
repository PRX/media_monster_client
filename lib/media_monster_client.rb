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
      yield job if block_given?
      job.tap do |j|
        j_str = post(api_url('jobs'), j.to_json, {'Accept'=>'application/json','Content-Type'=>'application/json'}).body
        json  = JSON.parse(j_str)
        j.id  = json['job']['id']
      end
    end

    def update_job(job)
      to_model(MediaMonster::Job, job).tap do |j|
        put(model_url(j), j.to_json, {'Accept'=>'application/json','Content-Type'=>'application/json'})
      end
    end

    def retry_job(job)
      to_model(MediaMonster::Job, job).tap do |j|
        put("#{model_url(j)}/retry", {}, {'Accept'=>'application/json'})
      end
    end

    def update_task(task_id, task_status)
      json = {'task'=>{'status'=>task_status}}.to_json
      put(api_url("tasks/#{task_id.to_i}"), json, {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end

    protected

    def to_model(klass, param)
      case param
      when klass  then param
      when Hash   then klass.new(param)
      when Fixnum then klass.new(:id => param)
      when String then klass.new(:id => param.to_i)
      else klass.new(param)
      end
    end

    def api_url(path)
      "/api/#{version}/#{path}"
    end

    def model_url(model)
      api_url("#{model.class.to_s.demodulize.downcase.pluralize}/#{model.id}")
    end

    [:delete, :get, :head, :post, :put, :request].each do |method|
      define_method method do |*args|
        access_token.send(method, *args)
      end
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer)
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(key,
                                        secret,
                                        :site        => "#{scheme || 'http'}://#{host}:#{port}",
                                        :http_method => :get)
    end

  end

end
