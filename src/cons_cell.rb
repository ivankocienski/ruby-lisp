
class ConsCell
  attr_accessor :car
  attr_accessor :cdr
  
  def initialize(a = nil, b = nil)
    @car = a
    @cdr = b
  end

  def type
    :cons
  end

  def length
    len  = car ? 1 : 0
    len += cdr.length if cdr
    len
  end

  def to_s
    if @car
      "(#{to_a.join(' ')})"
    else
      'NIL'
    end
  end

  def to_a

    cell = self
    out  = []

    while cell
      out << cell.car
      cell = cell.cdr
    end

    out
  end

end

def pretty_print(obj, depth)
  if obj.type == :cons
    
  else
    puts obj
  end
end

