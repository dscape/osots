module ActionView
  module Helpers
    module TextHelper
      module_function :pluralize, :truncate
    end
    module DateHelper
      module_function :time_ago_in_words, :distance_of_time_in_words
    end
  end
end