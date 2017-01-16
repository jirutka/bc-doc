require 'naturally'
require 'yaml'
require_relative 'core_ext'

module MiddlemanHelpers

  GITHUB_URL = 'https://github.com'
  NAVIGATION_FILE = File.join(__dir__, '../data/navigation.yml')

  # Returns URI of the current page's source file in the GitHub repository for
  # online edit.
  def github_edit_link
    source_file_path = current_page.file_descriptor.relative_path
    repo_slug = config[:site][:github][:repo_slug]
    branch = config[:site][:github][:branch]

    [GITHUB_URL, repo_slug, 'edit', branch, config[:source], source_file_path].join('/')
  end

  # Returns HTML markup for Google Tag Manager (Analytics).
  #
  # @param type [:script, :noscript, nil]
  def gtm_analytics(type = :script)
    container_id = config[:site][:google_tag_manager][:container_id]

    case type
    when :script
      content_tag :script, <<-EOF.unindent
        (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','#{container_id}');
      EOF
    when :noscript
      content_tag :noscript do
        content_tag :iframe, '',
          src: "https://www.googletagmanager.com/ns.html?id=#{container_id}",
          height: 0, width: 0, style: 'display:none;visibility:hidden'
      end
    end
  end

  # Returns title of the current page prefixed with the site name.
  # This is used in HTML title.
  def page_full_title
    [config[:site][:name], current_page.data.title].compact.join(' - ')
  end

  # Returns SVG code to use beforehand declared SVG symbol.
  def use_icon(icon_id)
    content_tag :svg, xmlns: 'http://www.w3.org/2000/svg', class: 'icon' do
      tag :use, 'xlink:href' => "#icon-#{icon_id}"
    end
  end

  #### Static Navigation ####

  NavLink = Struct.new('NavLink', :title, :resource, :children)

  def navigation
    transform_nav YAML.load_file(NAVIGATION_FILE)
  end

  # Returns root page (index) of the site.
  def root_page
    sitemap.find_resource_by_path(config.index_file)
  end

  private

  def transform_nav(items)
    (items || []).map do |item|
      path, title = item.first
      resource = ["#{path}.html", "#{path}/index.html"]
        .map { |path| sitemap.find_resource_by_path(path) }
        .compact.first

      NavLink.new(title, resource, transform_nav(item[':']))
    end
  end
end
