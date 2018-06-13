# frozen_string_literal: true

require_relative './test_helper'
require_relative '../lib/homograph_detector'

class HomographDetectorTest < Minitest::Test
  context '#homograph_attack?' do
    should 'return true if detected to be an attack' do
      assert HomographDetector.homograph_attack?('http://αaβbγcχxψyωz.com/')
      assert HomographDetector.homograph_attack?('http://аaбbгcдdеeжf.com/')
      assert HomographDetector.homograph_attack?('http://αаβбγгχдψеωж.com/')
      assert HomographDetector.homograph_attack?('http://ㄈㄉㄊおかが.com/')
      assert HomographDetector.homograph_attack?('http://ㄈㄉㄊᄊᄋᄌ.com/')
      assert HomographDetector.homograph_attack?('http://おかがᄊᄋᄌ.com/')
      assert HomographDetector.homograph_attack?('http://abꓚꓛᎪᎫ.com/')
      assert HomographDetector.homograph_attack?('http://ꓚꓛꓜᎪᎫᎬ.com/')
      assert HomographDetector.homograph_attack?('http://раураӏ.com')
    end

    should 'return false if not detected to be an attack' do
      assert !HomographDetector.homograph_attack?('http://Aabcdef.com/')
      assert !HomographDetector.homograph_attack?('http://αβγχψω.com/')
      assert !HomographDetector.homograph_attack?('http://абгдеж.com/')
      assert !HomographDetector.homograph_attack?('http://おかがキギク.com/')
      assert !HomographDetector.homograph_attack?('http://おaかbがcキdギeクf.com/')
      assert !HomographDetector.homograph_attack?('http://ㄈㄉㄊ⻕⻒夕.com/')
      assert !HomographDetector.homograph_attack?('http://ㄈaㄉbㄊc⻕d⻒e夕f.com/')
      assert !HomographDetector.homograph_attack?('http://ᄊᄋᄌᄍᄎᄏ.com/')
      assert !HomographDetector.homograph_attack?('http://ᄊaᄋbᄌcᄍdᄎeᄏf.com/')
      assert !HomographDetector.homograph_attack?('http://abc𐒊𐒋𐒌.com/')
    end

    should 'return false for an invalid address' do
      assert !HomographDetector.homograph_attack?('http://.google.com')
      assert !HomographDetector.homograph_attack?('Twitter http://twitter.com/')
    end
  end
end
