### Redmine Support Widget Plugin

The Redmine Support Widget plugin allows you to embed a lightweight support/help widget on any external website or application. The widget connects directly to your Redmine instance and lets users create support tickets seamlessly.

## ✨ Features

- Embed Redmine support widget on any external site with a single <script> tag.
- Generates a unique token per widget instead of exposing database IDs.
- Supports creating tickets directly from the widget.
- Automatically passes metadata like page URL and user agent.
- Option to customize header (minimize or close menu).

## 🚀 Installation

Clone this repository into your Redmine plugins directory:
```bash
cd /path/to/redmine/plugins
git clone https://github.com/sivamca19/redmine_support_widget.git support_widget
```

Install dependencies and run migrations:
```bash
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Restart your Redmine server:

```bash
rails s
```

## ⚙️ Configuration

1. Go to Administration → Support Widgets.
2. Create a new widget (this generates a unique token).
3. Copy the embed script.

## 📌 Embedding the Widget

Insert this snippet into your website/application:
```html
<script>
  (function(w,d,s,u){
    var js = d.createElement(s);
    js.async = true; js.src = u;
    var f = d.getElementsByTagName(s)[0];
    f.parentNode.insertBefore(js,f);
  })(window,document,"script","https://your-redmine.com/support_widget.js?token=YOUR_WIDGET_TOKEN");
</script>
```
- token → generated when you create a widget
- page_url → automatically captures current page URL
- user_agent → automatically passes the browser’s User-Agent

## 🎫 Ticket Creation

- Tickets are created via POST /support_widgets/create_ticket/:token
- Uses token instead of database id for security
- Captures metadata (page_url, user_agent) along with user-submitted data

## 🖥 Development

1. Run in development mode:
```bash
rails server
```
2. Visit /support_widgets/generate_script/:token to preview your widget script.

## 📄 License

This plugin is released under the MIT License.