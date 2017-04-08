# Singleton registry for determining NODE_ENV from config/webpack/paths.yml
require "webpacker/lite/file_loader"

class Webpacker::Lite::Env < Webpacker::Lite::FileLoader
  class << self
    def current
      raise Webpacker::Lite::FileLoader::FileLoaderError.new("Webpacker::Lite::Env.load must be called first") unless instance
      instance.data
    end

    def development?
      current == "development"
    end

    def file_path
      Rails.root.join("config", "webpack", "paths.yml")
    end
  end

  private
    def load
      environments = File.exist?(@path) ? YAML.load(File.read(@path)).keys : [].freeze
      return ENV["NODE_ENV"] if environments.include?(ENV["NODE_ENV"])
      return Rails.env if environments.include?(Rails.env)
      "production"
    end
end