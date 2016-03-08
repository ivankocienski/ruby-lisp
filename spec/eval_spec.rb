require 'spec_helper'
require 'yaml'

require 'sexp_tokenizer'
require 'parser'
require 'atom'
require 'cons_cell'
require 'eval'
require 'binding'
require 'function'

describe Eval do

  def expression_for(source)

    ts = SexpTokenizer.new(source)
    pr = Parser.new

    pr.parse(ts)
  end

  describe '#l_eval' do
    context 'atoms' do
      it 'returns value' do
        ev = Eval.new
        atom = Atom.new(:number, 123)
        out = ev.l_eval(atom, LispBinding.new)
        expect(out).to eq(atom)
      end
    end

    context 'variables' do
      it 'looks up value in binding and returns it' do
        atom = Atom.new(:number, '1234')
        binding = LispBinding.new
        binding.set 'x', atom

        ev  = Eval.new
        out = ev.l_eval(Atom.new(:word, 'x'), binding)
        expect(out).to eq(atom)
      end
    end

    context 'cons' do
      it 'applies function with arguments' do
        expected_args = expression_for('(123 "abc")')

        binding = LispBinding.new
        ev = Eval.new
        expect(ev).to receive(:l_apply).with('+', expected_args, binding)
        
        expression = ConsCell.new(Atom.new(:word, '+'), expected_args)

        ev.l_eval expression, binding
      end
    end
  end

  context '#l_apply' do

    context 'special form' do
      context 'setq' do
        it 'sets value in binding' do
          binding = LispBinding.new
          exp = expression_for("(x 123)")
          
          ev  = Eval.new
          ev.l_apply('setq', exp, binding)

          value = binding.lookup('x')
          expect(value).to be_a(Atom)
          expect(value.value).to eq('123')
        end
      end

      context 'if' do
        it 'returns nil if statement is false' do 
          exp = expression_for("(nil foo)")
          ev  = Eval.new
          out = ev.l_apply('if', exp, LispBinding.new)
          expect(out).to eq(Atom.Nill) 
        end

        it 'returns value if statement is true' do
          exp = expression_for("(t 123)")
          ev  = Eval.new
          out = ev.l_apply('if', exp, LispBinding.new)
          expect(out.value).to eq('123') 
        end

        it 'evaluates secondary clause if statement is false' do
          exp = expression_for("(nil 123 456)")
          ev  = Eval.new
          out = ev.l_apply('if', exp, LispBinding.new)
          expect(out.value).to eq('456') 
        end
      end

      context 'progn' do
        it 'evaluates multiple forms, returning last value' do
          exp = expression_for('(123 "word" 456)')
          ev  = Eval.new
          out = ev.l_apply('progn', exp, LispBinding.new)
          expect(out.value).to eq('456') 
        end
      end

      context 'let' do
        it 'assigns value to variable name' do
          exp = expression_for('(((x 123)) x)')
          ev  = Eval.new
          out = ev.l_apply('let', exp, LispBinding.new)
          expect(out.value).to eq('123') 
        end

        it 'does not clobber outer binding' do
          atom = Atom.new(:word, 'x123')
          binding = LispBinding.new
          binding.set 'x', atom

          exp = expression_for('(((x 123)) x)')
          ev  = Eval.new
          out = ev.l_apply('let', exp, binding)
          expect(out.value).to eq('123') 

          expect(binding.lookup('x')).to eq(atom)
        end
      end

      context 'defun' do
        it 'defines function in current binding' do

          binding = LispBinding.new

          exp = expression_for('(foo (x) x)')
          ev  = Eval.new
          out = ev.l_apply('defun', exp, binding)
          expect(out).to be_a(Function)

          expect(out.value).to eq('foo')

          found = binding.lookup('foo')
          expect(found).to be_a(Function) 
          expect(found).to eq(out)
        end
      end
    end

  end

  context 'general functions' do

    it 'can be invoked' do
      binding = LispBinding.new

      args = expression_for('(a b)')

      function_body = lambda { |args, binding|
        arg_a = args.car

        arg_b = args.cdr.car

        result = arg_a.value.to_i * arg_b.value.to_i

        Atom.new(:number, result)
      }

      func = Function.new( '*', args, function_body, LispBinding.new, true )
      binding.set '*', func

      ev = Eval.new

      exp = expression_for('(* 2 3)')
      out = ev.l_eval(exp, binding)

      expect(out.value).to eq 6
    end

  end



end

