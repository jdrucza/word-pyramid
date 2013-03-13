class Word
  #attr_accessible :length, :word

  def self.load_from_file()
    @@words = {}
    filename = 'db/dictionary.txt'
    word_list = File.open(filename)
    word_list.each do |raw_word|
      word = raw_word.delete("\n")
      @@words[word] = word.length
    end
    @@words
  end

  def self.exists?(word)
    word = word.downcase
    @@words[word]
  end

  def self.containing(letters)
    letters = letters.downcase
    @@words.select{|word,l| word.match(letters)}
  end

  def self.words()
    @@words
  end
end
Word.load_from_file
