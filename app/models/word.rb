class Word < ActiveRecord::Base
  establish_connection :dictionary

  attr_accessible :length, :word
  has_and_belongs_to_many :letters




  ###
  # All the below were for constructing the dictionary and useful in the originating project "letterpress helper"
  def self.new_and_index(raw_word)
    raw_word = raw_word.strip
    word = create(:word => raw_word)
    raw_word.each_char do |c|
      letter = Letter.find_or_create_by_letter(:letter => c.to_s)
      existing_letter = word.letters.find_by_letter(letter.letter)
      word.letters << letter unless existing_letter
    end
    word
  end

  def self.find_all_with_letters(raw_letters)
    select_clause = "select words.* from words"
    where_clause = ""
    raw_letters.each_char do |c|
      word_table_name = "words_#{c.to_s}"
      letter_table_name = "letters_#{c.to_s}"
      join_table_name = "letters_words_#{c.to_s}"

      select_clause << " INNER JOIN words as #{word_table_name} ON #{word_table_name}.id = words.id"
      select_clause << " INNER JOIN `letters_words` as #{join_table_name} ON #{join_table_name}.`word_id` = #{word_table_name}.`id`"
      select_clause << " INNER JOIN `letters` as #{letter_table_name} ON #{letter_table_name}.`id` = #{join_table_name}.`letter_id`"

      if where_clause.length == 0
        where_clause = " where"
      else
        where_clause << " AND"
      end
      where_clause << " #{letter_table_name}.letter = '#{c.to_s}'"
    end
    words = Word.find_by_sql(select_clause + where_clause)
    words
  end

  def self.find_all_containing_and_excluding(raw_letters, excLuding_raw_letters)
    select_clause = "select words.* from words"
    where_clause = ""
    raw_letters.each_char do |c|
      word_table_name = "words_#{c.to_s}"
      letter_table_name = "letters_#{c.to_s}"
      join_table_name = "letters_words_#{c.to_s}"

      select_clause << " INNER JOIN words as #{word_table_name} ON #{word_table_name}.id = words.id"
      select_clause << " INNER JOIN `letters_words` as #{join_table_name} ON #{join_table_name}.`word_id` = #{word_table_name}.`id`"
      select_clause << " INNER JOIN `letters` as #{letter_table_name} ON #{letter_table_name}.`id` = #{join_table_name}.`letter_id`"

      if where_clause.length == 0
        where_clause = " where"
      else
        where_clause << " AND"
      end
      where_clause << " #{letter_table_name}.letter = '#{c.to_s}'"
    end
    excLuding_raw_letters.each_char do |c|
      word_table_name = "words_#{c.to_s}"
      letter_table_name = "letters_#{c.to_s}"
      join_table_name = "letters_words_#{c.to_s}"

      sub_select_clause = " select #{word_table_name}.id from words as #{word_table_name}"
      sub_select_clause << " INNER JOIN `letters_words` as #{join_table_name} ON #{join_table_name}.`word_id` = #{word_table_name}.`id`"
      sub_select_clause << " INNER JOIN `letters` as #{letter_table_name} ON #{letter_table_name}.`id` = #{join_table_name}.`letter_id`"
      sub_select_clause << " where #{letter_table_name}.letter = '#{c.to_s}'"

      where_clause << " AND words.id not in (#{sub_select_clause})"
    end
    words = Word.find_by_sql(select_clause + where_clause + " order by words.length desc")
    words
  end

  def self.possibilities_using(including_letters, from_letters)
    excluded_letters = unused_alphabet_letters(from_letters)
    candidates = find_all_containing_and_excluding(including_letters, excluded_letters)
    candidates.select{|w| can_be_made_from(w.word, from_letters)}
  end

  def self.can_be_made_from(word, from_letters)
    from_copy = from_letters.dup
    word.each_char{|c| return false unless from_copy.delete!(c.to_s) }
    true
  end

  def self.unused_alphabet_letters(raw_letters)
    excluded_letters = "abcdefghijklmnopqrstuvwxyz"
    #raw_letters.each_char do |c|
    #  excluded_letters.delete!(c.to_s)
    #end
    excluded_letters.delete(raw_letters)
  end

  def self.letter_tally(word)
    tally = {}
    word.each_char{|c| if tally[c] then tally[c] += 1 else tally[c] = 1 end}
    tally
  end

  def self.load_from_file(filename)
    word_list = File.open(filename)
    word_list.each do |raw_word|
      new_and_index(raw_word)
      third_char = raw_word[2]
      if third_char and "bfjnrvy".include?(third_char)
        puts "word count: #{Word.count}"
      end
    end
  end
end
