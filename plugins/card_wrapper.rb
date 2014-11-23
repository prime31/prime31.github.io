


module Jekyll

  class CardWrapperTag < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
	  @title = text
    end

    def render(context)
		@title = context[@title] || @title
		html = ""
		
    
    html += '<div class="row top20">'
    
		if !@title.nil? && @title.to_s != ''
			html += "<h2 class='floating'>#{@title}</h2>"
		end
    
		html += '<div class="shadowed bg-white inline-headers col-lg-8 col-md-9 col-md-offset-2">'
		
		html += super
		html += '</div></div>'
		
		html
		#"#{@title} : #{output}"
		#@title += output
    end
  end
  
  
  class TitleCardWrapperTag < Liquid::Block
	  def initialize(tag_name, text, tokens)
		  super
	  end
	  
	  def render(context)
		  title = context['page.title']
		  
		  html = ""
		  html += '<div class="row top20 equal"><div class="col-md-2 bg-white"><h1 class="text-center">'
		  date = context['page.date']
		  if !date.nil?
			  html += date.strftime( "%h %-d" )
		  end

		  html += '</div>'
		  html += '<div class="col-lg-8 col-md-9 bg-primary bg-blue shadowed post-wrapper">'
		  html += '<h1>'
		  html += title
		  html += '</h1>'
		  html += super
		  html += '</div></div>'
		  
		  html
	  end
  end

end


Liquid::Template.register_tag('card', Jekyll::CardWrapperTag)
Liquid::Template.register_tag('titlecard', Jekyll::TitleCardWrapperTag)
