# coding: utf-8
# frozen_string_literal: true
require "../../spec_helper"
require "../src/crystal-graphql/language/lexer"

describe GraphQL::Language::Lexer do
  subject = GraphQL::Language::Lexer

  describe ".lex" do
    query_string = " \
      { \
        query getCheese { \
          cheese(id: 1) { \
            ... cheeseFields \
          } \
        } \
      } \
    "

    tokens = subject.lex(query_string)

    pending "makes utf-8 comments" do
      tokens = subject.lex("# 不要!\n{")
      comment_token = tokens.first#.prev_token
      comment_token.value.should eq "# 不要!"
    end

#    pending "keeps track of previous_token" do
#      tokens[1].prev_token.should eq tokens[0]
#    end

    it "unescapes escaped characters" do
      subject.lex(
                     %{"\\" \\\\ \\/ \\b \\f \\n \\r \\t"}
      ).first.value.should eq "\" \\ / \b \f \n \r \t"
    end

    it "unescapes escaped unicode characters" do
      subject.lex( %{"\u0009"} ).first.value.should eq "\t"
    end

    it "rejects bad unicode, even when there's good unicode in the string" do
      subject.lex(%{"\\u0XXF \\u0009"}).first.type.should eq :BAD_UNICODE_ESCAPE
    end

#    pending "clears the previous_token between runs" do
#      tok_1 = subject.lex(query_string)
#      tok_2 = subject.lex(query_string)
#      tok_2[0].prev_token.should eq nil
#    end
  end
end
