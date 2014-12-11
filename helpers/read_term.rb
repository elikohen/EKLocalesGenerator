class ReadTerm

  # type represends system type (1 = Android, 2 = iPhone)
  #
  def initialize(keyword, keep_key = false)
    @keyword = keyword
    @keyword = keyword.words_separate unless keep_key || is_comment?
    @values = Hash.new
  end

  def add_value(lang, value)
    if(!value || value.blank?)
      return
    end
    new_value = value.gsub('%i','%d')
    new_value = new_value.gsub("\\'","'")
    new_value.gsub!(/[%]\d*[@]/) do |w|
      w.gsub!('@','s')
    end
    @values.store(lang, new_value)
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

  def is_comment?
    @keyword.downcase == '[comment]'
  end

end
