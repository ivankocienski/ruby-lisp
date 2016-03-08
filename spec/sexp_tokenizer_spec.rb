require 'spec_helper'
require 'sexp_tokenizer'

describe SexpTokenizer do
  subject { SexpTokenizer }

  describe '#end_of_string?' do
    it 'is true by default' do
      st = subject.new
      expect(st.end_of_string?).to be true
    end

    it 'is false when source still exists' do
      st = subject.new("source")
      expect(st.end_of_string?).to be false
    end 
  end

  describe '#token' do
    it 'returns nil if no more source' do
      st = subject.new
      expect(st.token).to be nil
    end

    context 'with numbers' do
      it 'returns number' do
        st = subject.new("1234")
        expect(st.token).to eq({type: :numeric, token: "1234"})
      end
    end

    context 'with words' do
      it 'returns number' do
        st = subject.new("cat123")
        expect(st.token).to eq({type: :word, token: "cat123"})
      end
    end

    context 'with string literals' do
      it 'returns a string' do
        st = subject.new('"hello 123 world"')
        expect(st.token).to eq({
          type: :string,
          token: 'hello 123 world'
        })
      end 
    end 

    context 'with symbols' do
      it 'returns symbol' do
        st = subject.new('{')
        expect(st.token).to eq({type: :symbol, token: '{'})
      end
    end

    it 'skips white space' do
      st = subject.new('    boop')
      expect(st.token).to eq({type: :word, token: 'boop'})
    end
  end

  

end

