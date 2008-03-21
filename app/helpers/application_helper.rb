module ApplicationHelper
  def title(title)
    content_for(:title) { title } 
  end
  
  def make_xml_code_in_xhtml(list,print_line_nr=false,theme='iplastic')
    # start code
    ret = "<div class=\"#{theme}_div\">"
    unless list[0][0]['meta'].blank?
      ret += "<h5>#{list[0][0]['meta']}</h5>"
      list.shift
    end
    ret += "<code class=\"#{theme}\">"
    i = 0
    # for each of the hash in list
    for sublist in list
      ret+="\n"
      if print_line_nr
        ((i += 1) < 10) ? (s = '0' + i.to_s) : (s = i.to_s)
        ret+= "<span class=\"#{theme} linenum\">#{s}:</span>"
      end
      for hash in sublist
        #put the hash 
        nice_string = hash.values.first.gsub('&','&amp;').gsub('<','&lt;').gsub('>','&gt;').gsub('"','&quot;').gsub("\'",'&apos;')
        ret+="<span class=\"#{theme} #{hash.keys.first}\">#{nice_string}</span>"
      end
    end
    ret+="</code></div>"
    ret
  end

  # options
  # :start_date, sets the time to measure against, defaults to now
  # :date_format, used with <tt>to_formatted_s<tt>, default to :default
  def timeago(time, options = {})
    start_date = options.delete(:start_date) || Time.new
    date_format = options.delete(:date_format) || :default
    dif = start_date.to_i - time.to_i
    delta_minutes = dif.floor / 60
    if delta_minutes.abs <= (8724*60) 
      distance = distance_of_time_in_words(delta_minutes);
      if delta_minutes < 0
        "#{distance} from now"
      else
        "#{distance} ago"
      end
    else
      return "on #{system_date.to_formatted_s(date_format)}"
    end
  end

  def distance_of_time_in_words(minutes)
    case
      when minutes < 1
        "less than a minute"
      when minutes < 50
        pluralize(minutes, "minute")
      when minutes < 90
        "about one hour"
      when minutes < 1080
        "#{(minutes / 60).round} hours"
      when minutes < 1440
        "one day"
      when minutes < 2880
        "about one day"
      else
        "#{(minutes / 1440).round} days"
    end
  end
end