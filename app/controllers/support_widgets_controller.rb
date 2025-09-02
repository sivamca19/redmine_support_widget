class SupportWidgetsController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :set_support_widget, only: [:show, :edit, :update, :destroy, :generate_script]
  skip_forgery_protection only: [:serve_js]
  skip_before_action :verify_authenticity_token, only: [:create_ticket]

  def index
    @support_widgets = SupportWidget.all
  end

  def new
    @support_widget = SupportWidget.new
  end

  def create
    @support_widget = SupportWidget.new(support_widget_params)
    if @support_widget.save
      redirect_to support_widgets_path, notice: 'Widget created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @support_widget.update(support_widget_params)
      redirect_to support_widgets_path, notice: 'Widget updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @support_widget.destroy
    redirect_to support_widgets_path, notice: 'Widget deleted successfully.'
  end

  def generate_script
    script = generate_script_code(@support_widget)
    @support_widget.update(embed_code: script)

    redirect_to support_widget_path(@support_widget), notice: 'Script generated successfully.'
  end

  def show;end

  def create_ticket
    # basic spam check (honeypot param)
    if params[:hp].present?
      render json: { error: 'spam' }, status: :unprocessable_entity
      return
    end
    @support_widget = SupportWidget.find_by(token: params[:token])
    subject = params[:subject].to_s.strip
    description = params[:description].to_s.strip

    if subject.blank? || description.blank?
      render json: { error: 'subject and description required' }, status: :unprocessable_entity
      return
    end

    issue = Issue.new
    issue.project_id = @support_widget.project_id
    issue.tracker_id = @support_widget.tracker_id if @support_widget.tracker_id.present?
    issue.status_id  = @support_widget.status_id if @support_widget.status_id.present?
    issue.priority_id = @support_widget.priority_id if @support_widget.priority_id.present?
    issue.assigned_to_id = @support_widget.assigned_to_id if @support_widget.assigned_to_id.present?
    issue.subject = subject
    desc_lines = []
    desc_lines << description
    desc_lines << ""
    desc_lines << "----"
    desc_lines << "Submitted from: #{params[:page_url]}" if params[:page_url].present?
    desc_lines << "User agent: #{params[:user_agent]}" if params[:user_agent].present?
    desc_lines << "Widget: #{@support_widget.name}"
    issue.description = desc_lines.join("\n")
    issue.author = User.anonymous

    if issue.save(validate: false)
      render json: { ok: true, id: issue.id }, status: :created
    else
      render json: { error: issue.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def serve_js
    @widget = SupportWidget.find_by(token: params[:token])
    unless @widget
      render plain: "/* Redmine Chat Widget: no widget */", content_type: 'application/javascript'
      return
    end
    render template: 'support_widgets/script', layout: false, content_type: 'application/javascript'
  end

  private

  def set_support_widget
    @support_widget = SupportWidget.find(params[:id])
  end

  def support_widget_params
    params.require(:support_widget).permit(:name, :project_id, :status_id, :tracker_id, :priority_id, :assigned_to_id, :embed_code)
  end

  def generate_script_code(widget)
    script_url = "#{redmine_url}/support_widget.js?token=#{widget.token}"

    <<~SCRIPT
      <script>
        (function(w,d,s,u){
          var js = d.createElement(s);
          js.async = true;
          js.src = u;
          var f = d.getElementsByTagName(s)[0];
          f.parentNode.insertBefore(js,f);
        })(window,document,"script","#{script_url}");
      </script>
    SCRIPT
  end

  def redmine_url
    Setting.host_name.start_with?("http") ? Setting.host_name : "https://#{Setting.host_name}"
  end
end