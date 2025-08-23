class Braille < ApplicationRecord
  belongs_to :user
  belongs_to :brailleable, polymorphic: true

  before_validation :initialize_raised_braille, on: %i[create update]
  before_save :generate_indented_braille

  KANA = {
    # 清音
    'ア' => '⠁', 'イ' => '⠃', 'ウ' => '⠉', 'エ' => '⠋', 'オ' => '⠊',
    'カ' => '⠡', 'キ' => '⠣', 'ク' => '⠩', 'ケ' => '⠫', 'コ' => '⠪',
    'サ' => '⠱', 'シ' => '⠳', 'ス' => '⠹', 'セ' => '⠻', 'ソ' => '⠺',
    'タ' => '⠕', 'チ' => '⠗', 'ツ' => '⠝', 'テ' => '⠟', 'ト' => '⠞',
    'ナ' => '⠅', 'ニ' => '⠇', 'ヌ' => '⠍', 'ネ' => '⠏', 'ノ' => '⠎',
    'ハ' => '⠥', 'ヒ' => '⠧', 'フ' => '⠭', 'ヘ' => '⠯', 'ホ' => '⠮',
    'マ' => '⠵', 'ミ' => '⠷', 'ム' => '⠽', 'メ' => '⠿', 'モ' => '⠾',
    'ヤ' => '⠌', 'ユ' => '⠬', 'ヨ' => '⠜',
    'ラ' => '⠑', 'リ' => '⠓', 'ル' => '⠙', 'レ' => '⠛', 'ロ' => '⠚',
    'ワ' => '⠄', 'ヰ' => '⠆', 'ヱ' => '⠖', 'ヲ' => '⠔',
     'ン' => '⠴', 'ッ' => '⠂', 'ー' => '⠒',

    # 濁音
    'ガ' => '⠐⠡', 'ギ' => '⠐⠣', 'グ' => '⠐⠩', 'ゲ' => '⠐⠫', 'ゴ' => '⠐⠪',
    'ザ' => '⠐⠱', 'ジ' => '⠐⠳', 'ズ' => '⠐⠹', 'ゼ' => '⠐⠻', 'ゾ' => '⠐⠺',
    'ダ' => '⠐⠕', 'ヂ' => '⠐⠗', 'ヅ' => '⠐⠝', 'デ' => '⠐⠟', 'ド' => '⠐⠞',
    'バ' => '⠐⠥', 'ビ' => '⠐⠧', 'ブ' => '⠐⠭', 'ベ' => '⠐⠯', 'ボ' => '⠐⠮',

    # 半濁音
    'パ' => '⠠⠥', 'ピ' => '⠠⠧', 'プ' => '⠠⠭', 'ペ' => '⠠⠯', 'ポ' => '⠠⠮',
    'ヴ' => '⠐⠉',

    # 拗音、拗濁音、拗半濁音
    'キャ' => '⠈⠡', 'キュ' => '⠈⠩', 'キョ' => '⠈⠪',
    'シャ' => '⠈⠱', 'シュ' => '⠈⠹', 'ショ' => '⠈⠺',
    'チャ' => '⠈⠕', 'チュ' => '⠈⠝', 'チョ' => '⠈⠞',
    'ニャ' => '⠈⠅', 'ニュ' => '⠈⠍', 'ニョ' => '⠈⠎',
    'ヒャ' => '⠈⠥', 'ヒュ' => '⠈⠭', 'ヒョ' => '⠈⠮',
    'ミャ' => '⠈⠵', 'ミュ' => '⠈⠽', 'ミョ' => '⠈⠾',
    'リャ' => '⠈⠑', 'リュ' => '⠈⠙', 'リョ' => '⠈⠚',
    'ギャ' => '⠘⠡', 'ギュ' => '⠘⠩', 'ギョ' => '⠘⠪',
    'ジャ' => '⠘⠱', 'ジュ' => '⠘⠹', 'ジョ' => '⠘⠺',
    'ヂャ' => '⠘⠕', 'ヂュ' => '⠘⠝', 'ヂョ' => '⠘⠞',
    'ビャ' => '⠘⠥', 'ビュ' => '⠘⠭', 'ビョ' => '⠘⠮',
    'ピャ' => '⠨⠥', 'ピュ' => '⠨⠭', 'ピョ' => '⠨⠮',

    # 特殊音
    'イェ' => '⠈⠋', 'キェ' => '⠈⠫', 'シェ' => '⠈⠻', 'ジェ' => '⠘⠻', 'チェ' => '⠈⠟', 'ニェ' => '⠈⠏', 'ヒェ' => '⠈⠯',
    'ウィ' => '⠢⠃', 'ウェ' => '⠢⠋', 'ウォ' => '⠢⠊',
    'クァ' => '⠢⠡', 'クィ' => '⠢⠣', 'クェ' => '⠢⠫', 'クォ' => '⠢⠪',
    'グァ' => '⠲⠡', 'グィ' => '⠲⠣', 'グェ' => '⠲⠫', 'グォ' => '⠲⠪',
    'ツァ' => '⠢⠕', 'ツィ' => '⠢⠗', 'ツェ' => '⠢⠟', 'ツォ' => '⠢⠞',
    'ファ' => '⠢⠥', 'フィ' => '⠢⠧', 'フェ' => '⠢⠯', 'フォ' => '⠢⠮',
    'ヴァ' => '⠲⠥', 'ヴィ' => '⠲⠧', 'ヴェ' => '⠲⠯', 'ヴォ' => '⠲⠮',
    'スィ' => '⠈⠳', 'ズィ' => '⠘⠳', 'ティ' => '⠈⠗', 'ディ' => '⠘⠗',
    'トゥ' => '⠢⠝', 'ドゥ' => '⠲⠝',
    'テュ' => '⠨⠝', 'デュ' => '⠸⠝', 'フュ' => '⠨⠬', 'ヴュ' => '⠸⠬', 'フョ' => '⠨⠜', 'ヴョ' => '⠸⠜',

    # 空白、ブランク（スペースではなく、点字における無点の文字コード U+2800）
    '　' => '⠀', ' ' => '⠀',

    # 句点、読点、疑問符、感嘆符
    '。' => '⠲', '、' => '⠰', '?' => '⠢', '!' => '⠖'
  }.freeze

  TOKUSYUON = {
    'ァ' => %w[ク グ ツ フ ヴ],
    'ィ' => %w[ウ ク グ ツ フ ブ ス ズ テ デ ヴ],
    'ゥ' => %w[ト ド],
    'ェ' => %w[イ キ シ ジ チ ニ ヒ ウ ク グ ツ フ ヴ],
    'ォ' => %w[ウ ク グ ツ フ ヴ],
    'ュ' => %w[テ デ フ ヴ],
    'ョ' => %w[フ ヴ]
  }.freeze

  NUNBER = {
    '1' => '⠁', '2' => '⠃', '3' => '⠉', '4' => '⠙', '5' => '⠑',
    '6' => '⠋', '7' => '⠛', '8' => '⠓', '9' => '⠊', '0' => '⠚',

    # 小数点、位取り点、アポストロフィー
    '.' => '⠂', ',' => '⠄', '’' => '⠄', '\'' => '⠄'
  }.freeze
  SUFU = '⠼'
  DAI1_TUNAGIFU = '⠤'

  ALPHABET = {
    'a' => '⠁', 'b' => '⠃', 'c' => '⠉', 'd' => '⠙', 'e' => '⠑', 'f' => '⠋', 'g' => '⠛', 'h' => '⠓', 'i' => '⠊', 'j' => '⠚', 'k' => '⠅', 'l' => '⠇', 'm' => '⠍',
    'n' => '⠝', 'o' => '⠕', 'p' => '⠏', 'q' => '⠟', 'r' => '⠗', 's' => '⠎', 't' => '⠞', 'u' => '⠥', 'v' => '⠧', 'w' => '⠺', 'x' => '⠭', 'y' => '⠽', 'z' => '⠵'
  }.freeze

  GAIJIFU = '⠰'
  OOMOJIFU = '⠠'

  def convert_to_braille(text)
    normalize_text = normalize_for_braille(text)
    state = :kana
    result = []

    normalize_text.each_char.with_index do |char, i|
      prev_char = i.positive? ? normalize_text[i - 1] : nil
      next_char = i < normalize_text.size - 1 ? normalize_text[i + 1] : nil

      if char == "\n"
        result << char
        next
      end

      case state
      when :kana
        if char.match?(/[0-9]/)
          # 数字がはじまる合図の数符を入れる
          result << SUFU
          state = :number
          redo
        elsif char.match?(/[a-zA-Z]/)
          # アルファベットで書かれた文字の前に外字符を入れる
          result << GAIJIFU
          state = :alphabet
          redo
        else
          next if convert_kana_to_braille(char, next_char).nil?

          # 数字の後があ行・ら行（りゃ,りゅ,りょ除く）の場合は繋ぎ符を入れる
          result << DAI1_TUNAGIFU if prev_char&.match(/[0-9０-９]/) && %w[ア イ ウ エ オ ラ リ ル レ ロ].include?(char) && !%w[ャ ュ ョ].include?(next_char)
          result << convert_kana_to_braille(char, next_char)
        end

      when :number
        if KANA.include?(char)
          state = :kana
          redo
        end
        if char.match?(/[a-zA-Z]/)
          state = :alphabet
          redo
        end
        result << convert_num_to_braille(char)

      when :alphabet
        if KANA.include?(char)
          state = :kana
          redo
        end
        if char == /[0-9]/
          state = :number
          redo
        end
        # 大文字の前に大文字符を入れる。その後に続く単語が全て大文字ならば二つ大文字符を入れる
        result << OOMOJIFU if !prev_char&.match?(/[A-Z]/) && char.match?(/[A-Z]/) && !next_char&.match?(/[A-Z]/)
        result << OOMOJIFU * 2 if !prev_char&.match?(/[A-Z]/) && char.match?(/[A-Z]/) && next_char&.match?(/[A-Z]/)
        result << convert_alphabet_to_braille(char)
      end
    end
    result.join
  end

  def convert_to_indented_braille(raised_braille)
    raised_braille.chars.map { |char| braille_mirror(char) }.reverse.join
  end

    private

  def initialize_raised_braille
    if original_text.present?
      self.raised_braille = convert_to_braille(original_text)
      puts self.raised_braille
    end
  end

  def generate_indented_braille
    if raised_braille.present?
      self.indented_braille = convert_to_indented_braille(raised_braille)
    else
      self.indented_braille = nil
    end
  end

  def normalize_for_braille(text)
    result = ''
    text.each_char do |char|
      result << to_hankaku(to_kana(char))
    end
    result
  end

  def to_kana(char)
    char&.tr('ぁ-んゔ', 'ァ-ンヴ')
  end

  def to_hankaku(char)
    char&.tr('０-９．，？！', '0-9.,?!')
  end

  def convert_kana_to_braille(char, next_char)
    return if %w[ャ ュ ョ].include?(char) || %w[ァ ィ ゥ ェ ォ ュ].include?(char)

    is_yoon = %w[キ シ チ ニ ヒ ミ リ ギ ジ ヂ ビ ピ].include?(char) && %w[ャ ュ ョ].include?(next_char)
    is_tokusyuon = %w[ァ ィ ゥ ェ ォ ュ ョ].include?(next_char) && TOKUSYUON[next_char].include?(char)
    if is_yoon || is_tokusyuon
      one_kana = char << next_char
      KANA[one_kana]
    else
      KANA[char]
    end
  end

  def convert_num_to_braille(char)
    NUNBER[char]
  end

  def convert_alphabet_to_braille(char)
    lowercase = char.downcase
    ALPHABET[lowercase]
  end

  def braille_mirror(char)
    code_point = char.ord
    return char unless (0x2800..0x283F).cover?(code_point)

    dots = code_point - 0x2800
    mirrored = 0
    mirrored |= 0x08 if dots & 0x01 != 0 # 1→4
    mirrored |= 0x10 if dots & 0x02 != 0 # 2→5
    mirrored |= 0x20 if dots & 0x04 != 0 # 3→6
    mirrored |= 0x01 if dots & 0x08 != 0 # 4→1
    mirrored |= 0x02 if dots & 0x10 != 0 # 5→2
    mirrored |= 0x04 if dots & 0x20 != 0 # 6→3

    (0x2800 + mirrored).chr(Encoding::UTF_8)
  end
end

# TODO: リリース前に削除すること
# '0 1 2 3 4 5  6 7 8 9 A  B C D E F'
# '⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏'
# '⠐ ⠑ ⠒ ⠓ ⠔ ⠕ ⠖ ⠗ ⠘ ⠙ ⠚ ⠛ ⠜ ⠝ ⠞ ⠟'
# '⠠ ⠡ ⠢ ⠣ ⠤ ⠥ ⠦ ⠧ ⠨ ⠩ ⠪ ⠫ ⠬ ⠭ ⠮ ⠯'
# '⠰ ⠱ ⠲ ⠳ ⠴ ⠵ ⠶ ⠷ ⠸ ⠹ ⠺ ⠻ ⠼ ⠽ ⠾ ⠿'

# '0 1 2 3 4 5  6 7 8 9 A  B C D E F'
# '⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏'
# '⠐ ⠑ ⠒ ⠓ ⠔ ⠕ ⠖ ⠗ ⠘ ⠙ ⠚ ⠛ ⠜ ⠝ ⠞ ⠟'
# '⠠ ⠡ ⠢ ⠣ ⠤ ⠥ ⠦ ⠧ ⠨ ⠩ ⠪ ⠫ ⠬ ⠭ ⠮ ⠯'
# '⠰ ⠱ ⠲ ⠳ ⠴ ⠵ ⠶ ⠷ ⠸ ⠹ ⠺ ⠻ ⠼ ⠽ ⠾ ⠿'
