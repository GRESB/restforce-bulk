require "csv"
require "multi_xml"
require "nokogiri"
require "faraday"
require "faraday_middleware"
require "faraday_middleware/response_middleware"
require "restforce"
require "restforce/bulk/version"
require "active_support/inflector"
require "zip"

module Restforce
  module Bulk
    autoload :Client, 'restforce/bulk/client'
    autoload :Job,    'restforce/bulk/job'
    autoload :Batch,  'restforce/bulk/batch'
    autoload :Result, 'restforce/bulk/result'

    autoload :Attributes, 'restforce/bulk/attributes'

    autoload :Zipper, 'restforce/bulk/zipper'

    module Builder
      autoload :Xml,    'restforce/bulk/builder/xml'
      autoload :Csv,    'restforce/bulk/builder/csv'
      autoload :ZipXml, 'restforce/bulk/builder/zip_xml'
      autoload :ZipCsv, 'restforce/bulk/builder/zip_csv'
      autoload :Json,   'restforce/bulk/builder/json'
    end

    module Parser
      autoload :Xml,  'restforce/bulk/parser/xml'
      autoload :Csv,  'restforce/bulk/parser/csv'
      autoload :Json, 'restforce/bulk/parser/json'
    end

    module Middleware
      autoload :Authorization, 'restforce/bulk/middleware/authorization'
      autoload :ParseCsv,      'restforce/bulk/middleware/parse_csv'
    end

    MIME_TYPE_MAPPING = {
      csv: 'text/csv',
      xml: 'application/xml',
      zip_csv: 'zip/csv',
      zip_xml: 'zip/xml',
      json: 'application/json'
    }

    def self.client
      @client ||= Restforce::Bulk::Client.new
    end

    def self.client=(client)
      @client = client
    end
  end
end
