module ApplicationHelper
  def title(title)
    content_for(:title) { title } 
  end

  def value_or_unset(value)
    value != 0 ? value : 'unset'
  end
  
  def pluralize_question_by_topic(k,v)
    pluralize(v.size, 'question') + " on <strong>" + k + "</strong>"
  end
  
  def mark_choice(answer_user, compare_to, correct_choice)
    if correct_choice == compare_to
      %( style="background: url('/images/tick.png') center left no-repeat")
    elsif !answer_user.nil? && answer_user.option == compare_to
      %( style="background: url('/images/choice.png') center left no-repeat")
    else 
      ""
    end
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

  def timeago(time, options = {})
    start_date = options.delete(:start_date) || Time.new
    time = distance_of_time_in_words(start_date, time)
    start_date.to_i > time.to_i ? time + ' ago' : time + ' from now'
  end
end
