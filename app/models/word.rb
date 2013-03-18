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

  def self.containing_and_longer_than(letters, length)
    letters = letters.downcase
    @@words.select{|word,l| l > length and word.match(letters)}
  end

  def self.containing_s1_or_s2_excluding(s1, s2, excluded)
    excluded = excluded.downcase
    length = ((s1 ? s1.length : false) or (s2 ? s2.length : false) or 29)
    @@words.select{|word,l| l > length and word != excluded and ((s1 and word.match(s1)) or (s2 and word.match(s2)))}
  end

  def self.words()
    @@words
  end
end
Word.load_from_file
