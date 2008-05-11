f = File.open("#{RAILS_ROOT}/config/flags.yml")
COUNTRIES = YAML.load f
