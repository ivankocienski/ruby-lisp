
class Parser

  #def initialize(token_stream)
  #  @token_stream = token_stream
  #end

  # recursion! (too much lisp.)
  def parse(ts, depth=0)

    return nil if ts.end_of_string?

    tk   = ts.token
    atom = nil

    case tk[:type]
    when :symbol

      if tk[:token] == '('
        atom = parse(ts, depth+1)

      elsif tk[:token] == ')'
        return nil

      else 
        atom = Atom.new(:word, tk[:token])
      end

    when :numeric
      atom = Atom.new(:number, tk[:token])

    when :string
      atom = Atom.new(:string, tk[:token])

    when :word
      
      case tk[:token]
      when 'nil'
        atom = Atom.Nill

      when 't'
        atom = Atom.True

      else
        atom = Atom.new(:word, tk[:token])
      end
    end 

    if depth > 0
      return ConsCell.new(atom, parse(ts, depth))
    else
      return atom
    end
  end

end

