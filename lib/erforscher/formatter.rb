# encoding: utf-8

module Erforscher
  class Formatter
    def initialize(name_tag, fallback_to_private_dns=true)
      @name_tag = name_tag
      @fallback_to_private_dns = fallback_to_private_dns
    end

    def format(instance)
      [hostname(instance), instance.private_ip_address].join("\t")
    end

    private

    def hostname(instance)
      if (name = find_name(instance.tags))
        strip_domain(name)
      elsif @fallback_to_private_dns
        instance.private_dns_name
      end
    end

    def find_name(tags)
      tag = tags.find { |tag| tag[:key] == @name_tag }
      tag[:value] if tag
    end

    def strip_domain(name)
      name.split('.').first
    end
  end
end
