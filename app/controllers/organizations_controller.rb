# -*- encoding : utf-8 -*-
class OrganizationsController < ApplicationController

  before_filter :can_resources, :only => [:index, :new, :create]
  before_filter :can_resource, :only => [:show, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.create_with_admin(params[:organization], params[:admin])

    if @organization.saved?
      redirect_to organizations_path, :notice => '创建机构成功'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @organization.update_attributes(params[:organization])
       redirect_to  organization_path(@organization), :notice => '更新机构成功'
	else
		render 'edit'
    end
  end

  def show
    @organization = Organization.find(params[:id])
  end


  private
  def can_resources
    render_404 and return unless current_user.root?
  end

  def can_resource
    @organization = Organization.find(params[:id])
    render_404 and return unless current_user.root?
  end

end
