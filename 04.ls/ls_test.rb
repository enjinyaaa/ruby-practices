# frozen_string_literal: true

require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_ls
    test_dir_path = './test_dir'
    text = <<~TEXT
      000  05     fugafuga
      01   06     hoge
      02   07     nyannyan
      03   08
      04   09999
    TEXT
    assert_output(text) { ls([test_dir_path]) }
  end

  def test_ls_no_files
    test_dir_path = './test_dir/.fuga'
    text = ''
    assert_output(text) { ls([test_dir_path]) }
  end

  def test_ls_nopath
    text = <<~TEXT
      ls.rb  ls_test.rb  test_dir
    TEXT
    assert_output(text) { ls }
  end
end
