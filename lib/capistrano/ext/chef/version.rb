module Capistrano
  module Ext
    module Chef
      module Version
        MAJOR = 0
        MINOR = 1
        TINY = 0xf
        STRING= [MAJOR, MINOR, TINY].join('.')
      end
    end
  end
end
