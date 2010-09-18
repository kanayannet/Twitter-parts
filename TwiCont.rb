#********************************************************
#
#	twitter_parts用のコントローラー
#	2010.04.25 author kanayan
#
#********************************************************

#*******************    初期設定(yamlファイルのpath)      *******************

#ブラウザで見れない場所に設置することをお勧めします
Yaml = 'twitter_parts.yml'

#*******************     初期設定ここまで          *********************************

class TwiCont

	require 'yaml'
	require 'cgi'
	require 'TwitterView.rb'
	require 'TwitterLogic.rb'
	
	def initialize
		@cgi = CGI.new
		begin
			@yaml = YAML.load_file(Yaml)
		rescue
			error('.yml ファイルが読み込めませんでした')
		end
		
		@view = TwitterView.new(@yaml,@cgi,self)
		@logic = TwitterLogic.new(@yaml,@cgi,@view)
	end
	
	def output
	
		if(@cgi['mode'].to_s == '')
			profile = @logic.profile_get
			return @view.all_put(profile)
		elsif(@cgi['mode'].to_s == 'ajax')
			time_line = @logic.timeline_get
			return @view.ajax_put(time_line)
		end
	
	end
	
	#Viewライブラリが使えない用のエラー出力
	def error(errstr)
		puts "content-type:text/html\n\n"
		puts <<"__END"
		<html>
		<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<meta http-equiv="paragma" content="no-cache">
		</head>
		<body>
		<center>
		<br><br>
		<table border="1"><tr><td>
		<font size="3" color="#FF0000"><b>
		#{errstr}
		</b></font>
		</td></tr></table><br>
		<script language=javascript>
		<!--
			if(window.opener)
			{
				document.write('<input type="button" value="画面を閉じる" onclick="window.close()">');
			}else
			{
				document.write('<input type="button" value="戻る" onclick="history.back()">');
			}
		//-->
		</script>
		</center>
		</body>
		</html>
__END
		exit
	end
end