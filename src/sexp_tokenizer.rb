
class SexpTokenizer

  # TODO: line numbers

  def initialize(source='')
    @source = source
  end

  def end_of_string?
    @source.empty?
  end


  def token
    return @token if @token || end_of_string?

    @source = @source[($1.length)..-1] if @source =~ /^(\s+)/

    type  = nil
    token = ''
    t_len = nil

    case @source
    when /^"/ # string
      @source =~ /^"([^"]*)"/
      type     = :string
      token    = $1 
      t_len    = $1.length + 2

    when /^\d/ # number
      @source =~ /^(\d+)/
      token   = $1
      type    = :numeric

    when /^\w/ # word
      @source =~ /^(\w+)/
      type    = :word
      token   = $1

    else # symbolic character
      type  = :symbol
      token = @source[0]
    end

    t_len ||= token.length
    @source = @source[t_len..-1]

    { type: type, token: token } 
  end

  def next_token
    @token = nil
  end

end

