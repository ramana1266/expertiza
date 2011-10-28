#Allows a user to update their own profile information
class ProfileController < ApplicationController
require 'aquarium'

#load the view with the current fields
#only valid if user is logged in
 def edit 
    @user = session[:user]    
    @assignment_questionnaires = AssignmentQuestionnaires.find(:first, :conditions => ['user_id = ? and assignment_id is null and questionnaire_id is null',@user.id])     
 end
  
 #store parameters to user object
 def update
    @user = session[:user]
    
    unless params[:assignment_questionnaires].nil? or params[:assignment_questionnaires][:notification_limit].blank?
      aq = AssignmentQuestionnaires.find(:first, :conditions => ['user_id = ? and assignment_id is null and questionnaire_id is null',@user.id])
      aq.update_attribute('notification_limit',params[:assignment_questionnaires][:notification_limit])                    
    end
    
    if @user.update_attributes(params[:user])
      flash[:note] = 'Profile was successfully updated.'
      redirect_to :action => 'edit', :id => @user
    else
      flash[:note] = 'Profile was not updated.'
      render :action => 'edit'
    end
  end

include Aquarium::DSL
  around :methods => [:edit, :update] do |join_point, object, *args|
    logger.info "[info] Entering: #{join_point.target_type.name}##{join_point.method_name}: object = #{object}, args = #{args}" 
    result = join_point.proceed
    logger.info "[info] Leaving: #{join_point.target_type.name}##{join_point.method_name}: object = #{object}, args = #{args}" 
    result  # block needs to return the result of the "proceed"!
  end
  
end
