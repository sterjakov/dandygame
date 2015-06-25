# -*- encoding : utf-8 -*-
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class Admin::<%= controller_class_name %>Controller < ApplicationController

  load_and_authorize_resource

  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  layout 'back'

  before_action :current_user

  # GET /admin<%= route_url %>
  def index
    @<%= plural_table_name %> = <%= class_name %>.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin<%= route_url %>/1
  def show
  end

  # GET /admin<%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET /admin<%= route_url %>/1/edit
  def edit
  end

  # POST /admin<%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to [:edit, :admin, @<%= singular_table_name %>], notice: 'Создание ' + t('activerecord.models.<%= singular_table_name %>.sozdanie') + ' прошло успешно!'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin<%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to [:edit, :admin, @<%= singular_table_name %>], notice: 'Обновление ' + t('activerecord.models.<%= singular_table_name %>.sozdanie') + ' прошло успешно!'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin<%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to admin_<%= index_helper %>_url, notice: 'Удаление ' + t('activerecord.models.<%= singular_table_name %>.sozdanie') + ' прошло успешно!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
  <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
