require 'spec_helper'
require 'sexp_tokenizer'
require 'parser'
require 'atom'
require 'cons_cell'
require 'yaml'

# parser takes tokenized source and turns it into a collection 
# of high level objects (lists, numbers, strings etc)

describe Parser do

  subject { Parser }

  context 'atoms' do
    it 'pulls out constant values' do

      ts = SexpTokenizer.new("1234")
      pr = Parser.new
      
      out = pr.parse(ts) 
      expect(out).to eq(Atom.new(:number, '1234')) 
    end

    it 'pulls out first value, leaves rest' do
      ts = SexpTokenizer.new("1234 hello")
      pr = Parser.new
      
      out = pr.parse(ts) 
      expect(out).to eq(Atom.new(:number, '1234')) 

      expect(ts.end_of_string?).to be false

      out = pr.parse(ts) 
      expect(out).to eq(Atom.new(:word, 'hello')) 
    end
  end

  context 'lists' do
    it 'can be explicitly made with () syntax' do
      
      source = '(12 34)'
      tokens = SexpTokenizer.new(source)
      parser = Parser.new
      
      out = parser.parse(tokens)
      outer = out
      expect(outer).to be_a(ConsCell)

      expect(outer.car.value).to eq('12')
      expect(outer.cdr.car.value).to eq('34') 
    end

    it 'can be nested' do
      source = '((a) ((b) c))'
      tokens = SexpTokenizer.new(source)
      parser = Parser.new
      
      d1 = parser.parse(tokens)

      d2 = d1.car
      expect(d2.car.value).to eq('a')

      d3 = d1.cdr.car
      expect(d3.car.car.value).to eq('b')
      expect(d3.cdr.car.value).to eq('c') 
    end
  end
  
end

