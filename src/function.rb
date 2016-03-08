
class Function

  attr_reader :arguments
  attr_reader :binding
  attr_reader :code

  def initialize(name, argument_names, code_point, binding, internal = false)
    @name      = name
    @arguments = argument_names
    @code      = code_point
    @binding   = binding
    @internal  = internal
  end

  def invoke(args, binding)
    @code.call args, binding
  end

  def type
    :function
  end

  def internal?
    @internal
  end

  def to_s
    "##{@name.upcase}"
  end

  def value
    @name
  end

  def ==(o)
    (o.type == type) && (o.value == value)
  end

  def true?
    true
  end

  def nil?
    false
  end
end

