# frozen_string_literal: true

require 'open3'

module RRA
  # This class contains information relating to our Gem configuration, and is
  # used to produce a gemspec.
  class Gem
    # @!visibility private
    GEM_DIR = File.expand_path format('%s/../..', File.dirname(__FILE__))

    class << self
      # Returns the gem specification
      # @return [Gem::Specification]
      def specification
        ::Gem::Specification.new do |s|
          s.name        = 'rra'
          s.version     = '0.3'
          s.required_ruby_version = '>= 3.0.0'
          s.licenses    = ['LGPL-2.0']
          s.authors     = ['Chris DeRose']
          s.email       = 'chris@chrisderose.com'
          s.metadata    = { 'source_code_uri' => 'https://github.com/brighton36/rra' }

          s.summary = 'A workflow tool to: transform bank-downloaded csv\'s into ' \
                      'categorized pta journals. Run finance validations on those ' \
                      'journals. And generate csvs and plots on the output.'
          s.homepage = 'https://github.com/brighton36/rra'

          s.files = files

          s.executables = ['rra']

          s.add_development_dependency 'minitest', '~> 5.16.0'
          s.add_development_dependency 'yard', '~> 0.9.34'

          s.add_dependency 'open3', '~> 0.1.1'
          s.add_dependency 'shellwords', '~> 0.1.0'
          s.add_dependency 'google-apis-sheets_v4', '~> 0.22.0'
          s.add_dependency 'faker', '~> 3.2.0'
          s.add_dependency 'finance', '~> 2.0.0'
          s.add_dependency 'tty-table', '~> 0.12.0'
        end
      end

      # This is a git-less alternative to : `git ls-files`.split "\n"
      # @return [Array<String>] the paths of all rra development files in this gem.
      def files
        output, exit_code = Open3.capture2(format("find %s -type f -printf '%%P\n'", root))
        raise StandardError, 'find command failed' unless exit_code.success?

        output.split("\n").reject do |file|
          ignores = ['.git/*'] + File.read(format('%s/.gitignore', GEM_DIR)).split("\n")
          ignores.any? { |glob| File.fnmatch glob, file }
        end
      end

      # Return all ruby (code) files in this project.
      # @return [Array<String>] the paths of all ruby files in this gem.
      def ruby_files
        files.select { |f| /\A(?:bin.*|Rakefile|.*\.rb)\Z/.match f }
      end

      # The directory path to the rra gem, as calculated from the location of this gem.rb file.
      # @param [String] sub_path If provided, append this path to the output
      # @return [String] The full path to the gem root, plus any subpathing, if appropriate
      def root(sub_path = nil)
        sub_path ? [GEM_DIR, sub_path].join('/') : GEM_DIR
      end
    end
  end
end
