namespace :simplecov do
  desc "Run tests with coverage"
  task :coverage_report do
    require "simplecov"
    SimpleCov.start "rails"

    Rake::Task["test"].invoke
  end
end
