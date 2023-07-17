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
    assert_equal text, ls([test_dir_path])
  end

  def test_ls_no_files
    test_dir_path = './test_dir/.fuga'
    assert_nil ls([test_dir_path])
  end

  def test_ls_nopath
    text = <<~TEXT
      ls.rb  ls_test.rb  test_dir
    TEXT
    assert_equal text, ls
  end

  def test_ls_with_a_option
    test_dir_path = './test_dir'
    option = '-a'
    text = <<~TEXT
      .      02  08
      ..     03  09999
      .fuga  04  fugafuga
      .hoge  05  hoge
      000    06  nyannyan
      01     07
    TEXT
    assert_equal text, ls([test_dir_path, option])
  end

  def test_ls_with_r_option
    test_dir_path = './test_dir'
    option = '-r'
    text = <<~TEXT
      nyannyan  07  02
      hoge      06  01
      fugafuga  05  000
      09999     04
      08        03
    TEXT
    assert_equal text, ls([test_dir_path, option])
  end

  def test_ls_with_l_option
    test_dir_path = './test_dir'
    option = '-l'
    text = <<~TEXT
      合計 12
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 000
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 01
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 02
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 03
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 04
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 05
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 06
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 07
      -rw-r--r-- 1 debian debian    0  5月  3 14:09 08
      lrwxrwxrwx 1 debian debian    5  6月 18 16:30 09999 -> ls.rb
      -rw-r--r-- 1 debian debian    8  6月 18 16:26 fugafuga
      -rw-r--r-- 1 debian debian    4  6月 18 16:26 hoge
      drwxr-xr-x 2 debian debian 4096  5月  3 20:48 nyannyan
    TEXT
    assert_equal text, ls([test_dir_path, option])
  end
end
