require_relative '../hangman'

describe '#hangman' do
  word = 'turtle'
  
  it 'Can win a game' do
    output = StringIO.new
    hangman(word, build_input('turle'.chars), output)
    expect(output.string).to include "Win. Yes, it is 'turtle'"
  end

  it 'Can lose a game' do
    output = StringIO.new
    hangman(word, build_input('pzxymnhqg'.chars), output)
    expect(output.string).to include "Lose. The answer is 'turtle'"
  end
  
  it 'Tells a validation message against a wrong letter input' do
    output = StringIO.new
    hangman(word, build_input('pqwjcysmk'.chars), output)
    expect(output.string).to include ">> Not that one!"
  end

  it 'Refuses duplicates' do
    output = StringIO.new
    hangman(word, build_input('tturle'.chars), output)
    expect(output.string).to include "\n>> You have already picked 't'."
    expect(output.string).not_to include ">> Remaining lives: 8" 
  end

  it 'Loses lives when incorrect letter is chosen' do
    output = StringIO.new
    hangman(word, build_input('pqwjcysmk'.chars), output)
    expect(output.string).to include ">> Remaining lives: 5"
  end

  it 'Shows the current progress of the secret letter' do
    output = StringIO.new
    hangman(word, build_input('trqwsxcvbnm'.chars), output)
    expect(output.string).to include "\nSecret word: t#{BLOCK_SYMBOL}rt"
  end

  it 'Shows wrong letters answered' do
    output = StringIO.new
    hangman(word, build_input('trqwsxcvbnm'.chars), output)
    expect(output.string).to include 'Wrong letters answered: ["q", "w", "s", "x", "c", "v", "b", "n"]'
    expect(MAX_LIVES - build_input.length).to eq(MAX_LIVES - 1)
  end

  it 'Does not allow non-letter guesses' do
    output = StringIO.new
    hangman(word, build_input('3/#*🤡turle'.chars), output)
    expect(output.string).to include 'Non-letter guesses are not allowed.'
    expect(output.string).not_to include ">> Remaining lives: 8" 
  end

  it 'Does not allow more than 1 letter guessed' do
    output = StringIO.new
    hangman(word, build_input('e4', 'gahgefawgaw3/#*🤡tr', 't', 'u', 'r', 'l', 'e'.chars), output)
    expect(output.string).to include 'No more than one letter is allowed.'
    expect(output.string).not_to include ">> Remaining lives: 8" 
  end

  def build_input(*letters)
    StringIO.new(letters.join("\n") + "\n")
  end
end
