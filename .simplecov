# frozen_string_literal: true

require 'yaml'


path = Pathname.new('.simplecovignore.yml')
config = YAML.load_file(path) || { 'ignore_files' => [] }
SimpleCov.start 'rails' do
    config['ignore_files'].each { |file| add_filter file }
end

