require "rubocop"
require_relative "detects_fixability"

module Standard
  class Formatter < RuboCop::Formatter::BaseFormatter
    CALL_TO_ACTION_MESSAGE = <<-CALL_TO_ACTION.gsub(/^ {6}/, "")
      Notice: Disagree with these rules? While StandardRB is pre-1.0.0, feel free to submit suggestions to:
        https://github.com/testdouble/standard/issues/new
    CALL_TO_ACTION

    def initialize(*args)
      super
      @detects_fixability = DetectsFixability.new
      @header_printed_already = false
      @fix_suggestion_printed_already = false
      @any_uncorrected_offenses = false
    end

    def file_finished(file, offenses)
      return unless (uncorrected_offenses = offenses.reject(&:corrected?)).any?
      @any_uncorrected_offenses = true

      print_header_once
      print_fix_suggestion_once(uncorrected_offenses)

      uncorrected_offenses.each do |o|
        output.printf("  %s:%d:%d: %s\n", path_to(file), o.line, o.real_column, o.message.tr("\n", " "))
      end
    end

    def finished(_)
      print_call_for_feedback if @any_uncorrected_offenses
    end

    private

    def print_header_once
      return if @header_printed_already

      output.print <<-HEADER.gsub(/^ {8}/, "")
        standard: Use Ruby Standard Style (https://github.com/testdouble/standard)
      HEADER

      @header_printed_already = true
    end

    def print_fix_suggestion_once(offenses)
      if !@fix_suggestion_printed_already && should_suggest_fix?(offenses)
        command = if File.split($PROGRAM_NAME).last == "rake"
          "rake standard:fix"
        else
          "standardrb --fix"
        end

        output.print <<-HEADER.gsub(/^ {10}/, "")
          standard: Run `#{command}` to automatically fix some problems.
        HEADER
        @fix_suggestion_printed_already = true
      end
    end

    def path_to(file)
      Pathname.new(file).relative_path_from(Pathname.new(Dir.pwd))
    end

    def print_call_for_feedback
      output.print "\n"
      output.print CALL_TO_ACTION_MESSAGE
    end

    def auto_correct_option_provided?
      options[:auto_correct] || options[:safe_auto_correct]
    end

    def should_suggest_fix?(offenses)
      !auto_correct_option_provided? && @detects_fixability.call(offenses)
    end
  end
end
