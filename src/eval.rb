
class Eval

  def l_eval(exp, binding)
    if exp.type == :cons
      
      function = exp.car.value
      args     = exp.cdr

      l_apply function, args, binding
    else
      if exp.type == :word
        binding.lookup(exp.value)
      else
        exp
      end
    end
  end

  def l_apply( func, args, binding )
    
    case func
    when 'setq'
      binding.set args.car.value, l_eval(args.cdr.car, binding) 

    when 'if'
      condition_arg = args.car
      primary_arg   = args.cdr.car
      secondary_arg = nil;
      
      if args.length > 2 
        secondary_arg = args.cdr.cdr.car
      end

      outcome = l_eval(condition_arg, binding)

      if outcome.true?
        l_eval(primary_arg, binding)

      else
        if secondary_arg
          l_eval(secondary_arg, binding)

        else
          Atom.Nill
        end
      end

    when 'progn'
      result = Atom.Nill
      part = args
      while part do
        result = l_eval(part.car, binding)
        part = part.cdr
      end

      result

    when 'let'
      definition_list = args.car
      new_binding = LispBinding.new(binding)

      while definition_list do

        definition = definition_list.car

        name = definition.car.value
        value = l_eval( definition.cdr.car, binding )

        new_binding.set name, value
        
        definition_list = definition_list.cdr
      end

      result = Atom.Nill
      progn = args.cdr

      while progn do
        result = l_eval(progn.car, new_binding)
        progn = progn.cdr 
      end

      result

    when 'defun'
      name = args.car
      function_arglist = args.cdr.car
      body = args.cdr.cdr

      func = Function.new(name.value, function_arglist, body, binding)
      binding.set name.value, func

      func

    else # method call

      function_values = args

      function = binding.lookup(func)

      new_binding = LispBinding.new(function.binding)
      function_args = function.arguments

      while function_values && function_args do
        new_binding.set function_args.car.value, function_values.car

        function_values = function_values.cdr
        function_args = function_args.cdr
      end

      if function.internal?
        function.invoke args, binding
      else
        l_eval function.code, new_binding
      end


#    when '+'
#      args.to_a.map { |a| 
#        a.is_a?(Atom) ?
#          a.value.to_i :
#          l_eval(a, binding)
#      }.reduce(&:+)
#
#    when '*'
#      args.to_a.map { |a| 
#        a.is_a?(Atom) ?
#          a.value.to_i :
#          l_eval(a, binding)
#      }.reduce(&:*)
    end

  end

end

