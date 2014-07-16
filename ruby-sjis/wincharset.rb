#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# 文字集合の変換表チェッカ。
class WinCharset

  # チェック結果リストを出力する。
  def create_list(name)
    puts "WIN\tUNI\tMS932(1)\tMS932(2)\tWin31J(1)\tWin31J(2)\tCOMMENT"
    parse(name).each {|entry|
      l = "#{entry.win_code}\t#{entry.uni_code}"

      win_code = entry.win_code.to_i(16)

      cp932x1 = conv(win_code, "CP932")
      cp932x2 = conv(cp932x1, "CP932")
      l << "\t#{win_code == cp932x1}\t#{cp932x1 == cp932x2}"

      win31jx1 = conv(win_code, "Windows-31J")
      win31jx2 = conv(win31jx1, "Windows-31J")
      l << "\t#{win_code == win31jx1}\t#{win31jx1 == win31jx2}"

      l << "\t#{entry.comment}"

      puts l
    }
  end

  # エンコーディングを変換 (一往復) する。
  def conv(src, enc)
    src.chr(enc).encode("UTF-8").encode(enc).codepoints {|c| return c}
  end

  # 文字集合の変換表を読込む。
  def parse(name)
    list = []
    File.foreach(name) do |line|
      token = line.chop.split("\t")
      next if token.size < 2
      next if token[0] !~ /0x[0-9A-F]{2,4}/
      next if token[1] !~ /0x[0-9A-F]{2,4}/
      list << Entry.new(token[0][2..-1], token[1][2..-1], token[2])
    end
    list
  end

  # 一文字ごとの変換の定義
  class Entry
    def initialize(w, u, c)
      @win_code = w
      @uni_code = u
      @comment = c
    end
    attr :win_code, :uni_code, :comment
  end
end

if __FILE__ == $0
  c = WinCharset.new
  c.create_list("CP932.TXT")
end
