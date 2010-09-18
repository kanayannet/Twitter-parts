function twitter_page(page)
{
	$("scroll").innerHTML = '<br><br><b>Now Loading...</b><br>';
	var style_track;
	var style_drag_bar;
	mouseStop("scrollholder");
	tracks = $$('div.track');
	$A(tracks).each(function(ele)
	{
		style_track = ele;
		ele.parentNode.removeChild(ele);
	});
	drag_bars = $$('div.drag_bar');
	$A(drag_bars).each(function(ele)
	{
		style_drag_bar = ele;
		ele.parentNode.removeChild(ele);
	});
	
	new Ajax.Request(document.URL,
			{
				method:'GET',
				asynchronous:true,
				parameters:{mode: 'ajax','page': page},
				onSuccess: function(transport)
				{
					$("scroll").innerHTML = transport.responseText;
					$A(tracks).each(function(ele)
					{
						ele = style_track;
					});
					$A(drag_bars).each(function(ele)
					{
						ele = style_drag_bar;
					});
					ScrollLoad ("scrollholder", "scroll", true);
				}
			});
}