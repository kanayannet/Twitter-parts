#********************************************************
#
#	twitter_parts用のModel
#	2010.04.25 author kanayan
#
#********************************************************
class TwitterLogic

	require 'twitter'

	def initialize(yaml,cgi,view)
		@yaml = yaml
		@cgi = cgi
		@view = view
		if yaml['ID'].to_s == ''
			@view.error('ID が読み取れませんでした。')
		end
		
		if yaml['Passwd'].to_s == ''
			@view.error('Passwd が読み取れませんでした。')
		end
		@client = Twitter::Client.new(:login => yaml['ID'], :password => yaml['Passwd'])
	end
	
	def profile_get
		begin
			return @client.my(:info)
		rescue
			@view.error('timeline 取得ができませんでした。<br>「ID」「Passwd」が間違っているなどの原因が考えられます。')
		end
	end
	
	def timeline_get
		begin
			return @client.timeline_for(:friend, :count => 40)
		rescue
			@view.error('timeline 取得ができませんでした。<br>「ID」「Passwd」が間違っているなどの原因が考えられます。')
		end
	end
	
end
