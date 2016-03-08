
class Atom

  attr_reader :type
  attr_reader :value

  def initialize(type, value)
    @type  = type
    @value = value
  end

  def ==(o)
    (o.type == @type) && (o.value == @value)
  end

  def to_s
    case @type
    when :word
      value.to_s.upcase
    when :number
      value.to_s
    when :string
      %Q{"#{value}"}
    when :nil
      'NIL'
    when :true
      'T'
    end
  end

  def true?
    @type != :nil
  end

  def nil?
    @type == :nil
  end


  def self.Nill
    @nil_instance ||= Atom.new(:nil, nil)
  end

  def self.True
    @true_instance ||= Atom.new(:true, true)
  end
end

