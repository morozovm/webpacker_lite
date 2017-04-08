# Singleton registry for accessing the packs path using generated manifest.
# This allows javascript_pack_tag, stylesheet_pack_tag, asset_pack_path to take a reference to,
# say, "calendar.js" or "calendar.css" and turn it into "/packs/calendar.js" or
# "/packs/calendar.css" in development. In production mode, it returns compiles
# files, # "/packs/calendar-1016838bab065ae1e314.js" and
# "/packs/calendar-1016838bab065ae1e314.css" for long-term caching

require "webpacker/lite/file_loader"
require "webpacker/lite/env"
require "webpacker/lite/configuration"

class Webpacker::Lite::Manifest < Webpacker::Lite::FileLoader
  class << self
    def file_path
      Webpacker::Lite::Configuration.manifest_path
    end

    def lookup(name)
      load if Webpacker::Lite::Env.development?
      raise Webpacker::Lite::FileLoader::FileLoaderError.new("Webpacker::Lite::Manifest.load must be called first") unless instance
      instance.data[name.to_s] || raise(Webpacker::Lite::FileLoader::NotFoundError.new("Can't find #{name} in #{file_path}. Is webpack still compiling?"))
    end
  end

  private
    def load
      return super unless File.exist?(@path)
      JSON.parse(File.read(@path))
    end
end