module Jekyll
  class BoxBlock < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @type = text
    end

    require "kramdown"

    def render(context)
      if tag_contents = determine_arguments(@markup.strip)
        content = super
        box_type = tag_contents[0]
        box_tag(content, box_type)
      else
        raise ArgumentError.new <<-eos
Syntax error in tag 'alert' while parsing the following markup:
  #{@markup}
Valid syntax:
  opening: {% box success|warning|info|alert|large|small %}
  closing: {% endbox %}
eos
      end

    end

    private

    def determine_arguments(input)
      matched = input.match(/\A(\S+) ?(\S+)?\Z/)
      [matched[1].to_s.strip] if matched && matched.length >= 2
    end

    def box_tag(content, box_type)
      str = "<div class='alert-box #{box_type}'>"
        str << "#{Kramdown::Document.new(content).to_html}"
      str << "</div>"
    end

  end
end
Liquid::Template.register_tag('box', Jekyll::BoxBlock)
