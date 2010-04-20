require 'jsmin'

module AssetHat
  module JS
    ENGINES = [:weak, :jsmin]
    VENDORS = [:jquery]
      # TODO: Support jQuery UI, Prototype, MooTools, etc.

    def self.min_filepath(filepath)
      AssetHat.min_filepath(filepath, 'js')
    end

    def self.minify(input_string, options={})
      options.reverse_merge!(:engine => :jsmin)

      engine = options[:engine].to_sym
      unless ENGINES.include?(engine)
        raise %Q{
          Unknown JS minification engine '#{engine}'.
          Allowed: #{ENGINES.map{ |e| "'#{e}'" }.join(', ')}
        }.strip.gsub(/\s+/, ' ') and return
      end

      AssetHat::JS::Engines.send(engine, input_string)
    end

    # Collection of swappable CSS minification engines.
    module Engines
      # Barebones JS minification engine that:
      # - Skips leading/trailing whitespace for each line, excluding line
      #   breaks; and
      # - Removes one-line comments that had no actual code on that line.
      def self.weak(input_string)
        input   = StringIO.new(input_string)
        output  = StringIO.new

        input.each do |line|
          # Remove indentation and trailing whitespace
          line.strip!
          next if line.blank?

          # Skip single-line comments
          next if !(line =~ /^\/\//).nil?
          # TODO: Also skip single-line comments that began mid-line, but not
          #       inside a string or regex

          # TODO: Skip multi-line comments
          # - Should not strip from within a string or regex
          # - Should not strip comments that begin with `/*!` (e.g., licenses)

          output.write(line + "\n")
        end

        output.rewind
        output.read
      end

      # JS minification engine that simply uses the JSMin gem, a Ruby port
      # of Crockford's JSMin. Sources:
      # - http://github.com/rgrove/jsmin
      # - http://rubygems.org/gems/jsmin
      def self.jsmin(input_string)
        JSMin.minify(input_string)
      end
    end # module Engines

    module Vendors
      JQUERY_DEFAULT_VERSION = '1.4'

      def self.source_for(vendor, options={})
        version = options[:version]
        if version.blank?
          version = begin
            AssetHat.config['js']['vendors'][vendor.to_s]['version']
          rescue
            AssetHat::JS::Vendors.const_get(
              :"#{vendor.to_s.upcase}_DEFAULT_VERSION")
          end
        end

        case vendor
        when :jquery
          src = ActionController::Base.consider_all_requests_local ?
            "jquery-#{version}.min.js" :
            "http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js"
        else nil
        end
        src
      end
    end # module Vendors

  end

end
