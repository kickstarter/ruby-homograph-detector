# frozen_string_literal: true

require 'addressable/uri'
require 'unicode/confusable'
require 'unicode/scripts'
require 'set'

class HomographDetector
  # Unicode Script names returned by the 'unicode-scripts' gem
  SCRIPT_BOPOMOFO = 'Bopomofo'
  SCRIPT_COMMON = 'Common'
  SCRIPT_CYRILLIC = 'Cyrillic'
  SCRIPT_GREEK = 'Greek'
  SCRIPT_HAN = 'Han'
  SCRIPT_HANGUL = 'Hangul'
  SCRIPT_HIRAGANA = 'Hiragana'
  SCRIPT_INHERITED = 'Inherited'
  SCRIPT_KATAKANA = 'Katakana'
  SCRIPT_LATIN = 'Latin'

  # Groups of Unicode Scripts
  SPECIAL_SCRIPTS = Set[SCRIPT_COMMON, SCRIPT_INHERITED].freeze
  JAPANESE_SCRIPTS = Set[SCRIPT_HAN, SCRIPT_HIRAGANA, SCRIPT_KATAKANA].freeze
  CHINESE_SCRIPTS = Set[SCRIPT_BOPOMOFO, SCRIPT_HAN].freeze
  KOREAN_SCRIPTS = Set[SCRIPT_HAN, SCRIPT_HANGUL].freeze

  # Certain combinations of Unicode Scripts are okay
  APPROVED_SCRIPT_COMBINATIONS = [
    Set[*JAPANESE_SCRIPTS, SCRIPT_LATIN].freeze,
    Set[*CHINESE_SCRIPTS, SCRIPT_LATIN].freeze,
    Set[*KOREAN_SCRIPTS, SCRIPT_LATIN].freeze
  ].freeze

  attr_reader :address

  def initialize(address)
    @address = address
  end

  def self.homograph_attack?(address)
    new(address).homograph_attack?
  end

  def homograph_attack?
    # If we can't determine the Unicode Scripts for the domain, return false
    return false if domain_scripts.nil?

    # If the combination of Unicode Scripts used in the domain are ones we have
    # whitelisted, return false
    return false if domain_has_approved_combination_of_scripts?

    # If the combination of Unicode Scripts in the domain are problematic,
    # return true
    return true if domain_has_sketchy_combination_of_scripts?

    # If the domain is entirely composed of Cyrillic characters and each
    # character can be confusable with a Latin character, return true
    return true if domain_has_confusable_cyrillic_chars?

    false
  end

  # Returns true if one of the following is satisfied:
  #
  # - Two Unicode Scripts are used in the domain, neither are 'Latin'
  # - More than two Unicode Scripts are used in the domain
  # - Two Unicode Scripts are used in the domain, one is 'Latin' and the other
  #   is either 'Cyrillic' or 'Greek'
  private def domain_has_sketchy_combination_of_scripts?
    (
      domain_scripts.length == 2 && !domain_scripts.include?(SCRIPT_LATIN) ||
        domain_scripts.length > 2 ||
        (
          domain_scripts.length == 2 &&
            (domain_scripts.include?(SCRIPT_CYRILLIC) ||
            domain_scripts.include?(SCRIPT_GREEK))
        )
    )
  end

  private def domain_has_confusable_cyrillic_chars?
    domain_without_tld.chars.all? do |char|
      Unicode::Scripts.scripts(char).include?(SCRIPT_CYRILLIC) &&
        Unicode::Confusable.skeleton(char) != char
    end
  end

  private def domain_has_approved_combination_of_scripts?
    APPROVED_SCRIPT_COMBINATIONS.any? do |approved_script_combination|
      domain_scripts.subset?(approved_script_combination)
    end
  end

  # Retrieve the set of Unicode Scripts used in the domain name. If the domain
  # name can't be parsed, return nil
  private def domain_scripts
    if domain_without_tld.nil?
      nil
    else
      @domain_scripts ||=
        Set[*Unicode::Scripts.scripts(domain_without_tld)] - SPECIAL_SCRIPTS
    end
  end

  # Retrieve the domain without the TLD. If there's a parsing error, return nil
  private def domain_without_tld
    @domain_without_tld ||=
      begin
        tld = addressable_uri.tld
      rescue Addressable::URI::InvalidURIError, PublicSuffix::Error
        # The `tld` can raise a couple different errors when called if the URI
        # is invalid.
        nil
      else
        addressable_uri.domain.chomp(tld).chomp('.')
      end
  end

  private def addressable_uri
    @addressable_uri ||= Addressable::URI.parse(address)
  end
end
