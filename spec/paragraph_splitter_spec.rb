# encoding: utf-8
require 'spec_helper'
require './paragraph_splitter'
 
describe ParagraphSplitter do
 
  # languages that do not have spaces in between sentences (Korean)
  let(:no_spaces_between_sentences) { true }
  # languages that have spaces in between sentences (English)
  let(:spaces_between_sentences) { false }
 
  describe 'split' do
 
    describe 'latin alphabet languages' do
 
      it 'splits a paragraph with periods as the boundaries' do
        paragraph = "Hi, I'm the first sentence. I'm the second."
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Hi, I'm the first sentence.", "I'm the second."]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a paragraph with exclamation points as boundaries' do
        paragraph = "Hi, I'm the first sentence! I'm the second."
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Hi, I'm the first sentence!", "I'm the second."]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a paragraph with question marks as boundaries' do
        paragraph = "Hi, am I the first sentence? I'm the second. Who is the third?"
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Hi, am I the first sentence?", "I'm the second.", "Who is the third?"]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a longer paragaph' do
        paragraph = "Hi, am I the first sentence? I'm the second. Who is the third?" <<
          " This is a really really long paragraph. Check out all these sentences."
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          "Hi, am I the first sentence?", "I'm the second.", "Who is the third?",
          "This is a really really long paragraph.", "Check out all these sentences."
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'splits paragraphs that do not end in a punctuation mark' do
        paragraph = "Hi, I'm the first sentence! I'm kind of the second"
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Hi, I'm the first sentence!", "I'm kind of the second"]
        expect(sentences).to eq(expected)
      end
 
      it 'does not split up a sentence if there are no sentence boundaries' do
        paragraph = "I'm not a sentence, so just return me"
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split up a sentence if the sentence boundary is within quotes' do
        paragraph = 'she said "Hey! George"'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'splits up paragraphs that have parts within quotes' do
        paragraph = 'she said "Hey! George". Then she left.'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['she said "Hey! George".', 'Then she left.']
        expect(sentences).to eq(expected)
      end
 
      it 'does not split up a sentence if the sentence boundary is within parenthesis' do
        paragraph = 'This is a sentence (with parenthesis! Woo).'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'splits up paragraphs that have parenthesis in them' do
        paragraph = 'This sentence has some stuff (things) in it. Cool.'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['This sentence has some stuff (things) in it.', 'Cool.']
        expect(sentences).to eq(expected)
      end
 
      it 'does not split on abbreviations that are all caps' do
        paragraph = 'I love the USA, it is so cool!'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split on abbreviations that have periods in them' do
        paragraph = 'I love the U.S.A., it is so cool!'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split on abbreviations followed by an uppercase word' do
        paragraph = 'E.G. Kevin'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split on lowercase abbreviations that have periods in them' do
        paragraph = 'e.g. Kevin'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split on dates' do
        paragraph = 'Mon. Jan. 21st, 2015.'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'does not split on dates within long sentences' do
        paragraph = 'I was walking down the road on Mon. Jan. 21st, 2015'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expect(sentences).to eq([paragraph])
      end
 
      it 'splits a french paragraph into sentences' do
        paragraph = "Je m'appelle Nate. J'ai 24 ans."
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Je m'appelle Nate.", "J'ai 24 ans."]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a spanish paragraph with exclamation points into sentences' do
        paragraph = "Me llamo Nate. ¿Y usted?"
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ["Me llamo Nate.", "¿Y usted?"]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a portuguese paragraph into sentences' do
        paragraph = 'Todos os seres humanos nascem livres e iguais em dignidade e em direitos.' +
          ' Dotados de razão e de consciência, devem agir uns para com os outros em espírito de fraternidade.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          'Todos os seres humanos nascem livres e iguais em dignidade e em direitos.',
          'Dotados de razão e de consciência, devem agir uns para com os outros em espírito de fraternidade.'
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'splits a romanian sentence into paragraphs' do
        paragraph = 'Toate ființele umane se nasc libere și egale în demnitate și în drepturi.' +
          ' Ele sunt înzestrate cu rațiune și conștiință și trebuie să se comporte unele' +
          ' față de altele în spiritul fraternității.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          'Toate ființele umane se nasc libere și egale în demnitate și în drepturi.',
          'Ele sunt înzestrate cu rațiune și conștiință și trebuie să se comporte' +
            ' unele față de altele în spiritul fraternității.'
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'removes spaces from sentences that end in multiple spaces' do
        paragraph = "\r\nIn order to process your refund, we'll need some additional info.  "
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = "In order to process your refund, we'll need some additional info."
        expect(sentences).to eq([expected])
      end
 
      it 'removes the \n from sentences that end in a \n' do
        paragraph = "In order to process your refund, we'll need some additional info. \n"
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = "In order to process your refund, we'll need some additional info."
        expect(sentences).to eq([expected])
      end
 
      it 'removes the \r from sentences that end in a \r' do
        paragraph = "In order to process your refund, we'll need some additional info. \r"
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = "In order to process your refund, we'll need some additional info."
        expect(sentences).to eq([expected])
      end
 
      it 'removes the \t sentences that end in a \t' do
        paragraph = "In order to process your refund, we'll need some additional info. \t"
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = "In order to process your refund, we'll need some additional info."
        expect(sentences).to eq([expected])
      end
 
      it 'splits paragraphs that are separated by 2 spaces' do
        paragraph = "Ever feel like you have so much to say that one video lecture doesn't quite cut it?  "+
          "Sounds like you'd love adding some resources to your course!  "+
          "Much like it sounds, supplemental material is anything that you think will "+
          "supplement the learning experience of your students as they work through your curriculum.  "
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          "Ever feel like you have so much to say that one video lecture doesn't quite cut it?",
          "Sounds like you'd love adding some resources to your course!",
          "Much like it sounds, supplemental material is anything that you think will " +
            "supplement the learning experience of your students as they work through your curriculum."
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'splits sentences on \n and \t' do
        paragraph = "Isn't that weird.\n Check out that newline too.\tAnd a tab."
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          "Isn't that weird.", "Check out that newline too.", "And a tab."
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'does not split on sentences with ^^ in them' do
        paragraph = '^^Hello there. My name is Chris.^^'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          '^^Hello there. My name is Chris.^^'
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'splits on sentences with only 1 ^ in them' do
        paragraph = '^Hello there. My name is Chris.^'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          '^Hello there.', 'My name is Chris.^'
        ]
        expect(sentences).to eq(expected)
      end
 
    end
 
    describe 'cyrillic alphabet' do
 
      it 'splits a two sentence paragraph' do
        paragraph = 'Меня зовут Нейт. Я 24 лет.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['Меня зовут Нейт.', 'Я 24 лет.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits a longer paragraph' do
        paragraph = 'Именно здесь сосредоточены всемирно известные художественные галери,' +
          ' образцы великолепной архитектуры и два крупнейших в мире футбольных клуба' +
          ' «Реал» и «Атлетико». Для того чтобы исследовать этот величественный город,' +
          ' услуги водителя Blacklane, предлагаемые круглосуточно, подойдут лучше всего,' +
          ' поскольку машина всегда будет рядом в нужную минуту.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          'Именно здесь сосредоточены всемирно известные художественные галери,' +
            ' образцы великолепной архитектуры и два крупнейших в мире футбольных клуба' +
            ' «Реал» и «Атлетико».', 'Для того чтобы исследовать этот величественный город,' +
            ' услуги водителя Blacklane, предлагаемые круглосуточно, подойдут лучше всего,' +
            ' поскольку машина всегда будет рядом в нужную минуту.'
        ]
        expect(sentences).to eq(expected)
      end
 
      it 'splits on exclamation points' do
        paragraph = 'Меня зовут Нейт! Мне 24 лет.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['Меня зовут Нейт!', 'Мне 24 лет.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits many short sentences with all kinds of punctuation' do
        paragraph = 'Меня зовут Нейт! "Я 24 лет", сказал он. Как тебя зовут? Место, где я вы живете (я живу в г. Боулдер)?'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = [
          'Меня зовут Нейт!', '"Я 24 лет", сказал он.', 'Как тебя зовут?',
          'Место, где я вы живете (я живу в г. Боулдер)?'
        ]
        expect(sentences).to eq(expected)
      end
 
    end
 
    describe 'arabic alphabet' do
 
      it 'splits up a simple paragraph' do
        paragraph = 'مرحبا، اسمي نيت! أنا عمري 24 سنة.'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['مرحبا، اسمي نيت!', 'أنا عمري 24 سنة.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits up a paragraph with parenthesis in it' do
        paragraph = 'هذه الجملة لديه بعض الاشياء (الأشياء) في ذلك. باردة.'
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
 
        expected = ['هذه الجملة لديه بعض الاشياء (الأشياء) في ذلك.', 'باردة.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits up a paragraph with multiple short sentences' do
        paragraph = 'اسمي نيت! وقال "أنا عمري 24 سنة". ما اسمك؟'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
        expected = ['اسمي نيت!', 'وقال "أنا عمري 24 سنة".', 'ما اسمك؟']
        expect(sentences).to eq(expected)
      end
 
    end
 
    describe 'hebrew alphabet' do
 
      it 'splits a simple paragraph' do
        paragraph = 'השם שלי הוא נייט! אני בן 24 שנים.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
        expected = ['השם שלי הוא נייט!', 'אני בן 24 שנים.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits a paragraph with parenthesis in it' do
        paragraph = 'יש משפט זה דברים (דברים) כמה בזה. מגניב.'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
        expected = ['יש משפט זה דברים (דברים) כמה בזה.', 'מגניב.']
        expect(sentences).to eq(expected)
      end
 
      it 'splits up a paragraph with multiple short sentences' do
        paragraph = 'השם שלי הוא נייט! "אני בן 24 שנים", הוא אמר. מה שמך? איפה אתה גר (אני גר בבולדר)?'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
        # only splits into 3 because "מה שמך?" is too few characters
        expected = ['השם שלי הוא נייט!', '"אני בן 24 שנים", הוא אמר.', 'מה שמך? איפה אתה גר (אני גר בבולדר)?']
        expect(sentences).to eq(expected)
      end
 
    end
 
    describe 'character based languages' do
 
      describe 'Traditional Chinese' do
 
        it 'splits up a simple paragraph' do
          paragraph = '我的名字是內特！我今年24歲。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['我的名字是內特！', '我今年24歲。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with parenthesis in it' do
          paragraph = '這句話有一些東西（的事情）吧。酷。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['這句話有一些東西（的事情）吧。', '酷。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with multiple short sentences' do
          paragraph = '我的名字是內特！“我今年24歲了，”他說。你叫什麼名字？你住在哪裡（我住在Boulder）？'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['我的名字是內特！', '“我今年24歲了，”他說。', '你叫什麼名字？', '你住在哪裡（我住在Boulder）？']
          expect(sentences).to eq(expected)
        end
 
      end
 
      describe 'Simplified Chinese' do
 
        it 'splits up a simple paragraph' do
          paragraph = '我的名字是内特！我今年24岁。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['我的名字是内特！', '我今年24岁。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with parenthesis in it' do
          paragraph = '这句话有一些东西（的事情）吧。酷。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['这句话有一些东西（的事情）吧。', '酷。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with multiple short sentences' do
          paragraph = '我的名字是内特！“我今年24岁了，”他说。你叫什么名字？你住在哪里（我住在Boulder）？'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['我的名字是内特！', '“我今年24岁了，”他说。', '你叫什么名字？', '你住在哪里（我住在Boulder）？']
          expect(sentences).to eq(expected)
        end
 
      end
 
      describe 'Japanese' do
 
        it 'splits up a simple paragraph' do
          paragraph = '私の名前はネイトです！私は24歳です。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['私の名前はネイトです！', '私は24歳です。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with parenthesis in it' do
          paragraph = 'この文は、その中にいくつかのもの（物事を）持っています。クール。'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['この文は、その中にいくつかのもの（物事を）持っています。', 'クール。']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with multiple short sentences' do
          paragraph = '私の名前はネイトです！「私は24歳です」、と彼は言った。お名前は何ですか？' +
            'どこで（私はボールダーに住んで）住んでいますか？'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = [
            '私の名前はネイトです！', '「私は24歳です」、と彼は言った。', 'お名前は何ですか？',
            'どこで（私はボールダーに住んで）住んでいますか？'
          ]
          expect(sentences).to eq(expected)
        end
 
        it 'does not split a sentence on an ideographic space' do
          space = '　'
          paragraph = '私の名前はネイトです！' << space
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
          sentences = paragraph_splitter.split
          expect(sentences).to eq([paragraph])
        end
 
      end
 
      describe 'Korean' do
 
        it 'splits up a simple paragraph' do
          paragraph = '내 이름은 네이트입니다! 나는 24 살이다.'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['내 이름은 네이트입니다!', '나는 24 살이다.']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with parenthesis in it' do
          paragraph = '이 문장은 거기에 몇 가지 물건 (물건을)이있다. 쿨.'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = ['이 문장은 거기에 몇 가지 물건 (물건을)이있다.', '쿨.']
          expect(sentences).to eq(expected)
        end
 
        it 'splits up a paragraph with multiple short sentences' do
          paragraph = '내 이름은 네이트입니다! "나는 24 살이다"고 말했다. 당신의 이름은 무엇입니까?' +
            ' 어디 (I 볼더에 살고) 살고 있습니까?'
 
          paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
          sentences = paragraph_splitter.split
          expected = [
            '내 이름은 네이트입니다!', '"나는 24 살이다"고 말했다.', '당신의 이름은 무엇입니까?',
            '어디 (I 볼더에 살고) 살고 있습니까?'
          ]
          expect(sentences).to eq(expected)
        end
 
      end
 
    end
 
    describe 'thai alphabet' do
 
      # sitting here with Thai right now...
      # per http://en.wikipedia.org/wiki/Full_stop:
      # "In Thai, no symbol corresponding to the full stop is used as terminal punctuation.
      # A sentence is written without spaces, and a space is typically used to mark
      # the end of a clause or sentence."
      # when we get more thai -> english work we can look into better ways to parse
      # maybe: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.42.8991
 
      it 'splits up a simple paragraph' do
        paragraph = 'ชื่อของฉันคือเนท! ผมอายุ 24 ปี'
 
        paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
        sentences = paragraph_splitter.split
        expected = ['ชื่อของฉันคือเนท!', 'ผมอายุ 24 ปี']
        expect(sentences).to eq(expected)
      end
 
    end
 
  end
 
  describe 'spaces' do
 
    it 'gets spaces for this thing' do
      paragraph =  "I'm a founder of about.me & Sphere. I'm also a Partner at True Ventures."
      paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
 
      spaces = paragraph_splitter.spaces
      expect(spaces).to eq([" "])
    end
 
    it 'returns an array of all the spaces between sentences' do
      paragraph = "Hi, I'm the first sentence. I'm the second."
      paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
 
      expect(paragraph_splitter.spaces).to eq([' '])
    end
 
    it 'returns all the spaces between sentences when there are 2 spaces' do
      paragraph = "Hi, I'm the first sentence.  I'm the second.  "
      paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
 
      expect(paragraph_splitter.spaces).to eq(['  ', '  '])
    end
 
    it 'returns all the spaces between sentences when they are \n' do
      paragraph = "Hi, I'm the first sentence.\nI'm the second."
      paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
 
      expect(paragraph_splitter.spaces).to eq(["\n"])
    end
 
    it 'returns all the spaces between sentences when they are \t' do
      paragraph = "Hi, I'm the first sentence.\tI'm the second."
      paragraph_splitter = ParagraphSplitter.new(paragraph, spaces_between_sentences)
 
      expect(paragraph_splitter.spaces).to eq(["\t"])
    end
 
    it 'returns an array of empty strings for languages with no spaces between sentences' do
      paragraph = '私の名前はネイトです！私は24歳です。'
      paragraph_splitter = ParagraphSplitter.new(paragraph, no_spaces_between_sentences)
 
      expect(paragraph_splitter.spaces).to eq(['', ''])
    end
 
  end
 
end