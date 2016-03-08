
class LispBinding
  def initialize(parent=nil)
    @parent = parent
    @values = {}
  end

  def set(name, value)
    @values[name] = value
  end

  def lookup(name)
    if @values.has_key?(name)
      @values[name]
    else
      if @parent
        @parent.lookup name
      else
        raise "#{name} not found"
      end
    end
  end
end

