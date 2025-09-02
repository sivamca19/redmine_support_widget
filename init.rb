Redmine::Plugin.register :redmine_support_widget do
  name 'Redmine Support Widget plugin'
  author 'Sivamanikandan'
  description 'The Redmine Support Widget plugin allows you to embed a lightweight support/help widget on any external website or application. The widget connects directly to your Redmine instance and lets users create support tickets seamlessly.'
  version '0.0.1'
  url 'https://github.com/sivamca19/redmine_support_widget.git'
  author_url 'https://github.com/sivamca19'


  menu :admin_menu, :chat_widgets, { controller: 'support_widgets', action: 'index' },
     caption: 'Support Widgets', html: { class: 'icon' }
end
