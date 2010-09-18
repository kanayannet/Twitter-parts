#********************************************************
#
#	twitter_parts用のViewライブラリー
#	2010.04.25 author kanayan
#
#********************************************************

class TwitterView

	require 'erb'
	include ERB::Util
	require 'date'

	def initialize(yaml,cgi,cont)
	
		@yaml = yaml
		@cgi = cgi
		@cont = cont
		@months = {'Jan'=>'01','Feb'=>'02','Mar'=>'03','Apr'=>'04',
			   'May'=>'05','Jun'=>'06','Jul'=>'07','Aug'=>'08',
			   'Sep'=>'09','Oct'=>'10','Nov'=>'11','Dec'=>'12'}
		begin
			erb = ERB.new(File.read(@yaml['head_view']))
			@head = erb.result(binding)
		rescue
			cont.error('テンプレートファイル「head_view」が開けませんでした。')
		end
		
		begin
			erb = ERB.new(File.read(@yaml['foot_view']))
			@foot = erb.result(binding)
		rescue
			cont.error('テンプレートファイル「foot_view」が開けませんでした。')
		end
		
	end
	def all_put(profile)
		begin
			erb = ERB.new(File.read(@yaml['all_view']))
			all = erb.result(binding)
		rescue
			error('テンプレートファイル「time_line_view」が開けませんでした。')
		end
		return "content-type:text/html\n\n" + all
	end
	def ajax_put(time_line)
		
		count_page = time_line.length
		start_page = (@cgi['page'].to_i * 10) + 0
		end_page = start_page + 10
		
		max = count_page + 1
		maxpage = max.divmod(10).join(".")
		if(/\./=~maxpage.to_s)
			if(/\.0$/=~maxpage.to_s)
				maxpage = maxpage.to_i
			else
				maxpage = maxpage.to_i + 1
			end
		end
		
		begin
			erb = ERB.new(File.read(@yaml['time_line_view']))
			time_line = erb.result(binding)
		rescue
			error('テンプレートファイル「time_line_view」が開けませんでした。')
		end
		return "content-type:text/html\n\n" + time_line
	end
	#******************************************
	#	twitter parts html_convert(to article)
	#
	#******************************************
	def html_convert(str)
		#リンク処理
		str = str.to_s.gsub(/(http[s]?\:\/\/[\w\.\~\-\/\?\&\+\=\:\@\%\;\#\%]+)/) do
			"<a href=\"#{$1}\" target=\"_blank\">#{$1}</a>"
		end
		#@ハンドル名リンク
		str = str.to_s.gsub(/(\@)([a-zA-Z0-9_]+)/) do
			"<a href=\"http://twitter.com/#{$2}\" target=\"_blank\">#{$1}#{$2}</a>"
		end
		# #タグリンク
		str = str.to_s.gsub(/(#)([a-zA-Z0-9]+)/) do
			"<a href=\"http://twitter.com/#search?q=%23#{$2}\" target=\"_blank\">#{$1}#{$2}</a>"
		end
		return str
	end
	#**********************************************
	#
	#	twitter parts convert(to date)
	#
	#**********************************************
	def view_date(str)
		(wday,day,mon,year,hhmmss,etc) = str.to_s.split(/ /)
		month = @months[mon]
		str = "#{year}\/#{month}\/#{day} #{hhmmss}"
		return str
	end
	#エラー出力後終了
	def error(str)
		puts "content-type:text/html\n\n"
		puts <<"__END"
		#{@head}
		<center>
		<br><br>
		<table border="1" bgcolor="#FFFFFF"><tr><td>
		<font size="3" color="#FF0000"><b>
		#{str}
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
		#{@foot}
__END
		exit
	end
	
end