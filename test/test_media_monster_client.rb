# require 'rubygems'
# gem 'activesupport', '=2.2.3'
# gem 'activesupport', '=2.3.9'
# gem 'activesupport', '=3.0.9'

require 'helper'

class TestMediaMonsterClient < Test::Unit::TestCase

  def setup 
    MediaMonsterClient.key     = '9NmQzsWBWs8TyfJswqMmkmjwAH3ItNBIC72KLjQK'
    MediaMonsterClient.secret  = '592BSoaCb4FfwqsZ6Ql8WShVZ6HVnecR4Dk9lRfQ'
    MediaMonsterClient.host    = "development.prx.org"
    MediaMonsterClient.port    = 3000
    MediaMonsterClient.version = 'v1'
  end

  def test_create_job
    response = MediaMonsterClient.create_job do |job|
      job.job_type = 'audio'
      job.original = 's3://development.tcf.prx.org/public/uploads/entry_audio_files/2/test.mp2'
      job.call_back = "http://development.prx.org:3001/audio_files/21/transcoded"
  
      job.add_task( 'transcode',
                    {:format=>'mp3', :sample_rate=>'44100', :bit_rate=>'128'},
                    's3://development.tcf.prx.org/public/audio_files/21/test.mp3',
                    nil,
                    'download')
  
    end
    
    puts response.inspect
  
  end 
  
  def test_create_job_with_sequence
    response = MediaMonsterClient.create_job do |job|
      job.job_type = 'audio'
      job.original = 's3://development.tcf.prx.org/public/uploads/entry_audio_files/2/test.mp2'
      job.call_back = "http://development.prx.org:3001/audio_files/21/transcoded"
  
      job.add_sequence do |s|
        s.call_back = "http://development.prx.org:3001/audio_files/21/transcoded"
        s.label = 'preview'
  
        s.add_task( :task_type=>'cut',
                    :options=>{:length=>4, :fade=>1},
                    :label=>'cut it')
  
        s.add_task( :task_type=>'transcode',
                    :options=>{:format=>'mp3', :sample_rate=>'44100', :bit_rate=>'64'},
                    :label=>'mp3',
                    :result=>'s3://development.tcf.prx.org/public/uploads/entry_audio_files/2/test_preview.mp3')
      end
  
    end
    puts response.inspect
  end

    # MediaMonsterClient.create_job do |job|
    #   job.job_type = 'audio'
    #   job.original = 's3://development.tcf.prx.org/public/uploads/entry_audio_files/2/test.mp2'
    #   job.add_task( 'copy',
    #                   {},
    #                   's3://development.tcf.prx.org/public/audio_files/21/test.mp2',
    #                   'http://localhost:3001/audio_files/21/processed',
    #                   'original')
    # end
  
end