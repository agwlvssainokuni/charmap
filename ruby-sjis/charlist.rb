#!/usr/bin/ruby
# -*- coding: utf-8 -*-

class CharList

  def create_list(name)
    puts "UNICODE\t文字\t重複数\tWin31J代表コード\tWin31J副コード"
    parse(name).each do |entry|

      rep = entry.result.reject {|k, v|
        entry.cp932[k] || entry.win31j[k]
      }
      rej = entry.result.select {|k, v|
        entry.cp932[k] || entry.win31j[k]
      }

      l = "#{entry.uni_code}\t#{entry.char}\t#{entry.count}\t"
      lst = []
      rep.each {|k, v| lst << "#{k}:#{v}" }
      l << lst.join(",") << "\t" << rej.keys.join(",")

      puts l
    end
  end

  def parse(name)
    list = []
    File.foreach(name) do |line|
      token = line.chop.split("\t")
      list << Entry.new(*token)
    end
    list
  end

  class Entry
    def initialize(ucd, cnt, rslt, cp, win)
      @uni_code = ucd
      @char = @uni_code.to_i(16).chr("UTF-8")
      @count = cnt.to_i

      @result = {}
      rslt.gsub("{(", "").gsub(")}", "").split("),(").each do |e|
        token = e.split(",")
        @result[token[0]] = token[1]
      end

      @cp932 = {}
      cp.gsub("{(", "").gsub(")}", "").split("),(").each do |e|
        token = e.split(",")
        @cp932[token[0]] = token[1]
      end

      @win31j = {}
      win.gsub("{(", "").gsub(")}", "").split("),(").each do |e|
        token = e.split(",")
        @win31j[token[0]] = token[1]
      end
    end
    attr :uni_code, :char, :count, :result, :cp932, :win31j
  end
end

if __FILE__ == $0
  l = CharList.new
  l.create_list(ARGV[0])
end
