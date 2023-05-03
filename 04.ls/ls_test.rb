# frozen_string_literal: true

require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  TEST_DIR_PATH = './test_dir'
  def test_ls
    text = <<~TEXT
      000  05     fugafuga
      01   06     hoge
      02   07     nyannyan
      03   08
      04   09999
    TEXT
    ARGV.replace([TEST_DIR_PATH])
    assert_output(text) { ls }
  end

  def test_ls_nopath
    text = <<~TEXT
      ls.rb  ls_test.rb  test_dir
    TEXT
    ARGV.replace([])
    assert_output(text) { ls }
  end
end
