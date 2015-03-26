class ParagraphSplitter 

	attr_accessor :paragraph

	def initialize(paragraph, spaces_between_sentences)
		@paragraph = paragraph
		@spaces_between_sentences = spaces_between_sentences
	end

	def split
		sentences = @paragraph.split(/(?<=[?.!])\s*/)
	end

end 
