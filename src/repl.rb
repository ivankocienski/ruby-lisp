
require 'sexp_tokenizer'
require 'parser'
require 'atom'
require 'cons_cell'
require 'eval'
require 'binding'
require 'function'

module REPL

  extend self

  def run

    make_internal_function '+', lambda { |args, binding| 
      sum = 0

      while args do
        sum += value_of(args.car).value.to_i

        args = args.cdr
      end

      Atom.new(:number, sum)
    }

    make_internal_function '*', lambda { |args, binding| 
      accumulator = value_of(args.car).value.to_i
      args = args.cdr

      while args do
        arg = value_of(args.car).value.to_i
        
        accumulator *= arg
        args = args.cdr
      end

      Atom.new(:number, accumulator)
    }

    loop do
      print '> '
      puts evaluator.l_eval(parser.parse(SexpTokenizer.new(gets)), binding)
    end


  end

  def value_of(arg)
    if arg.type == :cons
      evaluator.l_eval(arg, binding)
    else
      arg
    end
  end

  def binding
    @binding ||= LispBinding.new
  end

  def evaluator
    @evaluator ||= Eval.new
  end

  def parser
    @parser ||= Parser.new
  end

  def make_internal_function( name, code )
    binding.set name, Function.new(name, nil, code, binding, true)
  end

end

