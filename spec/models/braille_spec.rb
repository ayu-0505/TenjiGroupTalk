require 'rails_helper'

RSpec.describe Braille, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user: user) }
  let(:talk) { create(:talk, user: user) }
  let(:braille) { create(:talk_braille, user: user) }

  # WARNING: 点字のスペースはスペースのコードではなく、点字の無点（U+2800）
  describe '#convert_to_braille' do
    it 'converts text containing only hiragana and katakana' do
      # 清音
      seion = 'あいうえお　かきくけこ　さしすせそ　たちつてと　なにぬねの　はひふへほ　まみむめも　やゆよ　らりるれろ　わをん'
      seion_kana = 'アイウエオ カキクケコ　サシスセソ　タチツテト　ナニヌネノ　ハヒフヘホ　マミムメモ　ヤユヨ　ラリルレロ　ワヲン'
      expect(braille.convert_to_braille(seion)).to eq('⠁⠃⠉⠋⠊⠀⠡⠣⠩⠫⠪⠀⠱⠳⠹⠻⠺⠀⠕⠗⠝⠟⠞⠀⠅⠇⠍⠏⠎⠀⠥⠧⠭⠯⠮⠀⠵⠷⠽⠿⠾⠀⠌⠬⠜⠀⠑⠓⠙⠛⠚⠀⠄⠔⠴')
      expect(braille.convert_to_braille(seion_kana)).to eq('⠁⠃⠉⠋⠊⠀⠡⠣⠩⠫⠪⠀⠱⠳⠹⠻⠺⠀⠕⠗⠝⠟⠞⠀⠅⠇⠍⠏⠎⠀⠥⠧⠭⠯⠮⠀⠵⠷⠽⠿⠾⠀⠌⠬⠜⠀⠑⠓⠙⠛⠚⠀⠄⠔⠴')

      # 濁音、半濁音
      dakuon = 'がぎぐげご　ざじずぜぞ　だぢづでど　ばびぶべぼ　ぱぴぷぺぽ'
      dakuon_kana = 'ガギグゲゴ　ザジズゼゾ　ダヂヅデド　バビブベボ　パピプペポ'
      expect(braille.convert_to_braille(dakuon)).to eq('⠐⠡⠐⠣⠐⠩⠐⠫⠐⠪⠀⠐⠱⠐⠳⠐⠹⠐⠻⠐⠺⠀⠐⠕⠐⠗⠐⠝⠐⠟⠐⠞⠀⠐⠥⠐⠧⠐⠭⠐⠯⠐⠮⠀⠠⠥⠠⠧⠠⠭⠠⠯⠠⠮')
      expect(braille.convert_to_braille(dakuon_kana)).to eq('⠐⠡⠐⠣⠐⠩⠐⠫⠐⠪⠀⠐⠱⠐⠳⠐⠹⠐⠻⠐⠺⠀⠐⠕⠐⠗⠐⠝⠐⠟⠐⠞⠀⠐⠥⠐⠧⠐⠭⠐⠯⠐⠮⠀⠠⠥⠠⠧⠠⠭⠠⠯⠠⠮')

      # 拗音、拗濁音、拗半濁音
      yoon = 'きゃきゅきょ　しゃしゅしょ　ちゃちゅちょ　にゃにゅにょ　ひゃひゅひょ　みゃみゅみょ　りゃりゅりょ　ぎゃぎゅぎょ　じゃじゅじょ　ぢゃぢゅぢょ　びゃびゅびょ　ぴゃぴゅぴょ'
      yoon_kana = 'キャキュキョ　シャシュショ　チャチュチョ　ニャニュニョ　ヒャヒュヒョ　ミャミュミョ　リャリュリョ　ギャギュギョ　ジャジュジョ　ヂャヂュヂョ　ビャビュビョ　ピャピュピョ'
      expect(braille.convert_to_braille(yoon)).to eq('⠈⠡⠈⠩⠈⠪⠀⠈⠱⠈⠹⠈⠺⠀⠈⠕⠈⠝⠈⠞⠀⠈⠅⠈⠍⠈⠎⠀⠈⠥⠈⠭⠈⠮⠀⠈⠵⠈⠽⠈⠾⠀⠈⠑⠈⠙⠈⠚⠀⠘⠡⠘⠩⠘⠪⠀⠘⠱⠘⠹⠘⠺⠀⠘⠕⠘⠝⠘⠞⠀⠘⠥⠘⠭⠘⠮⠀⠨⠥⠨⠭⠨⠮')
      expect(braille.convert_to_braille(yoon_kana)).to eq('⠈⠡⠈⠩⠈⠪⠀⠈⠱⠈⠹⠈⠺⠀⠈⠕⠈⠝⠈⠞⠀⠈⠅⠈⠍⠈⠎⠀⠈⠥⠈⠭⠈⠮⠀⠈⠵⠈⠽⠈⠾⠀⠈⠑⠈⠙⠈⠚⠀⠘⠡⠘⠩⠘⠪⠀⠘⠱⠘⠹⠘⠺⠀⠘⠕⠘⠝⠘⠞⠀⠘⠥⠘⠭⠘⠮⠀⠨⠥⠨⠭⠨⠮')

      # 特殊音
      tokusyu = 'いぇきぇしぇじぇちぇにぇひぇ　うぃうぇうぉ　くぁくぃくぇくぉ　ぐぁぐぃぐぇぐぉ　つぁつぃつぇつぉ　ふぁふぃふぇふぉ　ゔぁゔぃゔぇゔぉ　すぃずぃてぃでぃとぅどぅてゅでゅふゅゔゅふょゔょゔ'
      tokusyu_kana = 'イェキェシェジェチェニェヒェ　ウィウェウォ　クァクィクェクォ　グァグィグェグォ　ツァツィツェツォ　ファフィフェフォ　ヴァヴィヴェヴォ　スィズィティディトゥドゥテュデュフュヴュフョヴョヴ'
      expect(braille.convert_to_braille(tokusyu)).to eq('⠈⠋⠈⠫⠈⠻⠘⠻⠈⠟⠈⠏⠈⠯⠀⠢⠃⠢⠋⠢⠊⠀⠢⠡⠢⠣⠢⠫⠢⠪⠀⠲⠡⠲⠣⠲⠫⠲⠪⠀⠢⠕⠢⠗⠢⠟⠢⠞⠀⠢⠥⠢⠧⠢⠯⠢⠮⠀⠲⠥⠲⠧⠲⠯⠲⠮⠀⠈⠳⠘⠳⠈⠗⠘⠗⠢⠝⠲⠝⠨⠝⠸⠝⠨⠬⠸⠬⠨⠜⠸⠜⠐⠉')
      expect(braille.convert_to_braille(tokusyu_kana)).to eq('⠈⠋⠈⠫⠈⠻⠘⠻⠈⠟⠈⠏⠈⠯⠀⠢⠃⠢⠋⠢⠊⠀⠢⠡⠢⠣⠢⠫⠢⠪⠀⠲⠡⠲⠣⠲⠫⠲⠪⠀⠢⠕⠢⠗⠢⠟⠢⠞⠀⠢⠥⠢⠧⠢⠯⠢⠮⠀⠲⠥⠲⠧⠲⠯⠲⠮⠀⠈⠳⠘⠳⠈⠗⠘⠗⠢⠝⠲⠝⠨⠝⠸⠝⠨⠬⠸⠬⠨⠜⠸⠜⠐⠉')

      # 促音、長音符
      text = 'あっち　そっち　どっち　おかあさん　おとーさんと　うんどーかいへ　いった'
      expect(braille.convert_to_braille(text)).to eq('⠁⠂⠗⠀⠺⠂⠗⠀⠐⠞⠂⠗⠀⠊⠡⠁⠱⠴⠀⠊⠞⠒⠱⠴⠞⠀⠉⠴⠐⠞⠒⠡⠃⠯⠀⠃⠂⠕')
    end

    context 'when text containing the number' do
      it 'converts all numbers and symbols' do
        text = '1234567890 3.14 1,234,567'
        expect(braille.convert_to_braille(text)).to eq('⠼⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠀⠼⠉⠂⠁⠙⠀⠼⠁⠄⠃⠉⠙⠄⠑⠋⠛')
      end

      it 'converts numbers even when mixed with hiragana' do
        text = '1ちょー　２４００まん　３ぶんの１'
        expect(braille.convert_to_braille(text)).to eq('⠼⠁⠈⠞⠒⠀⠼⠃⠙⠚⠚⠵⠴⠀⠼⠉⠐⠭⠴⠎⠼⠁')
      end

      it 'adds 数符 when the following character belongs to the あ row or the ら row' do
        text = '1えん　２り　３うぉん　４い　５りょう'
        expect(braille.convert_to_braille(text)).to eq('⠼⠁⠤⠋⠴⠀⠼⠃⠤⠓⠀⠼⠉⠢⠊⠴⠀⠼⠙⠤⠃⠀⠼⠑⠈⠚⠉')
      end
    end

    context 'when text containing the alphabet' do
      it 'adds 外字符 when text containing the alphabet' do
        text = 'abcdefg hijklmn opqrstu vwxyz'
        expect(braille.convert_to_braille(text)).to eq('⠰⠁⠃⠉⠙⠑⠋⠛⠀⠰⠓⠊⠚⠅⠇⠍⠝⠀⠰⠕⠏⠟⠗⠎⠞⠥⠀⠰⠧⠺⠭⠽⠵')
      end

      it 'adds 大文字符 before uppercase alphabet characters' do
        text = 'No 1だね A B C'
        expect(braille.convert_to_braille(text)).to eq('⠰⠠⠝⠕⠀⠼⠁⠐⠕⠏⠀⠰⠠⠁⠀⠰⠠⠃⠀⠰⠠⠉')
      end

      it 'adds two 大文字符 if uppercase alphabet characters occur consecutively.' do
        text = 'OPEC CD PC PTA TV VIP SF PDF'
        expect(braille.convert_to_braille(text)).to eq('⠰⠠⠠⠕⠏⠑⠉⠀⠰⠠⠠⠉⠙⠀⠰⠠⠠⠏⠉⠀⠰⠠⠠⠏⠞⠁⠀⠰⠠⠠⠞⠧⠀⠰⠠⠠⠧⠊⠏⠀⠰⠠⠠⠎⠋⠀⠰⠠⠠⠏⠙⠋')
      end
    end

    context 'when text containing a mix of kanji, numbers, alphabets, and hiragana' do
      it 'onverts numbers, alphabets, and hiragana, and removes all other characters' do
        text = 'その　人と　２ねんも　あってない。　けつえきがたわ　A B O AB　のどれ？　わ　びっくりした！'
         expect(braille.convert_to_braille(text)).to eq('⠺⠎⠀⠞⠀⠼⠃⠏⠴⠾⠀⠁⠂⠟⠅⠃⠲⠀⠫⠝⠋⠣⠐⠡⠕⠄⠀⠰⠠⠁⠀⠰⠠⠃⠀⠰⠠⠕⠀⠰⠠⠠⠁⠃⠀⠎⠐⠞⠛⠢⠀⠄⠀⠐⠧⠂⠩⠓⠳⠕⠖')
      end
    end
  end

  describe '#convert_to_indented_braille' do
    it 'mirrors braille horizontally for the entire text' do
      text = '⠀⠁⠂⠃⠄⠅⠆⠇⠉⠊⠋⠌⠍⠎⠏⠒⠓⠔⠕⠖⠗⠛⠜⠝⠞⠟⠤⠥⠦⠧⠭⠮⠯⠶⠷⠿'
      expect(braille.convert_to_indented_braille(text)).to eq('⠿⠾⠶⠽⠵⠭⠼⠴⠬⠤⠻⠳⠫⠣⠛⠺⠲⠪⠢⠚⠒⠹⠱⠩⠡⠙⠑⠉⠸⠰⠨⠠⠘⠐⠈⠀')
    end
  end
end
