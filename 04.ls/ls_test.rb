# frozen_string_literal: true

require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_ls
    test_dir_path = './test_dir'
    texts = [
      '000  05     fugafuga',
      '01   06     hoge',
      '02   07     nyannyan',
      '03   08',
      '04   09999'
    ]
    assert_equal texts, ls([test_dir_path])
  end

  def test_ls_no_files
    test_dir_path = './test_dir/.fuga'
    assert_nil ls([test_dir_path])
  end

  def test_ls_nopath
    texts = [
      'ls.rb  ls_test.rb  test_dir'
    ]
    assert_equal texts, ls
  end

  def test_ls_with_a_option
    test_dir_path = './test_dir'
    option = '-a'
    texts = [
      '.      02  08',
      '..     03  09999',
      '.fuga  04  fugafuga',
      '.hoge  05  hoge',
      '000    06  nyannyan',
      '01     07'
    ]
    assert_equal texts, ls([test_dir_path, option])
  end

  def test_ls_with_r_option
    test_dir_path = './test_dir'
    option = '-r'
    texts = [
      'nyannyan  07  02',
      'hoge      06  01',
      'fugafuga  05  000',
      '09999     04',
      '08        03'
    ]
    assert_equal texts, ls([test_dir_path, option])
  end
end
