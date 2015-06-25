if defined?(WillPaginate)
  module WillPaginate
    module ActionView
      def will_paginate(collection = nil, options = {})
        options[:renderer] ||= BootstrapLinkRenderer
        super.try :html_safe
      end

      class BootstrapLinkRenderer < LinkRenderer
        protected

        def previous_or_next_page(page, text, classname)
          tag :div,
          link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' '),
          class: 'direction'
        end

      end
    end
  end
end
