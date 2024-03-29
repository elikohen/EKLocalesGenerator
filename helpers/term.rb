require_relative 'FormatSpecifiers'

class Term
  def initialize(keyword, comment = nil, keep_key = false)
    @keep_key = keep_key
    @keyword = keyword.gsub('&', '_and_')
    @comment = comment
    @format_specifiers = nil
    @values = Hash.new
  end

  def store_value(lang, text)
    @values.store lang, text.strip()
    if !@format_specifiers
      @format_specifiers = FormatSpecifiers.new(text)
    end
  end

  def values
    @values
  end

  def values=(val)
    @values = val
  end

  def keyword
    @keyword
  end

  def comment_iphone
    @comment || ""
  end

  def comment_android
    @comment || ""
  end

  def has_comment?
    @comment != nil && !@comment.empty?
  end

  def has_specifiers?
    @format_specifiers != nil && !@format_specifiers.empty?
  end

  def has_tags?
    @format_specifiers != nil && @format_specifiers.has_tags?
  end

  def specifiers_args
    return @format_specifiers.format_args
  end

  def specifiers_vars
    return @format_specifiers.format_vars
  end

  def replacement_tags
    return @format_specifiers.replacement_tags
  end

  def is_comment?
    @keyword.downcase == '[comment]'
  end

  def restriction
    if @keyword.match /^[\[][a-z][\]]/
      @keyword[1]
    else
      nil
    end
  end

  def keyword_iphone
    if(@keep_key)
      return @keyword.strip_tag
    else
    '_'+@keyword.space_to_underscore.strip_tag.camel_case
    end
  end

  def keyword_iphone_constant
    'kLocale'+@keyword.space_to_underscore.strip_tag.camel_case
  end

  def keyword_iphone_constant_swift
    @keyword.space_to_underscore.strip_tag.camel_case.uncapitalize
  end

  def keyword_android
    if(@keep_key)
      return @keyword.strip_tag
    else
      @keyword.space_to_underscore.strip_tag.downcase
    end
  end

  def values_iphone
    iphone_values = Hash.new
    @values.each do |language, value|
      new_language = language.gsub('*','')
      new_value = value.gsub(/\n/, '\n')
      new_value = new_value.gsub("\\\"", '"')
      new_value = new_value.gsub(/"/, '\"')
      new_value.gsub!(/[%]\d*[s]/) do |w|
        w.gsub!('s','@')
      end
      if(new_value.start_with?("<![CDATA[")) # to allow reusing android values
        new_value = new_value.gsub('<![CDATA[', '')
        new_value = new_value.gsub(']]>', '')
      end
      iphone_values.store new_language, new_value
    end
    iphone_values
  end

  def values_android
    android_values = Hash.new
    @values.each do |language, value|
      new_language = language.gsub('*','')
      new_value = value
      if(!value.start_with?("<![CDATA["))
        new_value = new_value.gsub('%i','%d')
        new_value = new_value.gsub('\?', '')
        new_value = new_value.gsub(/\n/, '\n')
        new_value = new_value.gsub("\\\"", '"')
        new_value = new_value.gsub("'","\\\\'")
        new_value = new_value.gsub(/"/, '\"')
        new_value = new_value.gsub('&', '&amp;')
        new_value.gsub!(/[%]\d*[@]/) do |w|
          w.gsub!('@','s')
        end
        new_value = new_value.gsub('...', '&#8230;')
        if(new_value == '?')
          new_value = "\"?\""
        end
      end
      android_values.store new_language, new_value
    end
    android_values
  end

  def values_json
    json_values = Hash.new
    @values.each do |language, value|
      new_language = language.gsub('*','')
      new_value = value.gsub('%i','%d')
      new_value = new_value.gsub("\\'","'")
      new_value.gsub!(/[%]\d*[@]/) do |w|
        w.gsub!('@','s')
      end
      json_values.store new_language, new_value
    end
    json_values
  end
end
