require 'spec_helper'
require 'atom'
require 'cons_cell'

describe ConsCell do


  context '#type' do
    it 'returns :cons' do
      expect(ConsCell.new.type).to eq(:cons)
    end
  end

  context '#length' do
    it 'calculates length of nested cons cells' do

      cons = ConsCell.new(Atom.Nill,
                          ConsCell.new(Atom.Nill,
                                       ConsCell.new(Atom.Nill)))

      expect(cons.length).to eq(3)
    end 
  end

  context '#to_s' do
  end

  context '#to_a' do
    it 'converts the cons list into a ruby array of atoms' do

      v1   = Atom.new(:number, '123')
      v2   = Atom.new(:string, 'hello world')
      v3   = Atom.new(:word, 'foo')
      cons = ConsCell.new(v1,
                          ConsCell.new(v2,
                                       ConsCell.new(v3)))

      expect(cons.to_a).to eq([v1, v2, v3])
    end
  end
end

