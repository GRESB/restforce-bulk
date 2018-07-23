module Restforce
  module Bulk
    module Builder
      class Json
        attr_accessor :operation

        def initialize(operation)
          self.operation = operation
        end

        def transform(data, operation, content_type)
          operation == 'query' ? query(data) : generate(data)
        end

        def query(data)
          data
        end

        def generate(data)
          ::JSON.parse(data)
        end
      end
    end
  end
end
