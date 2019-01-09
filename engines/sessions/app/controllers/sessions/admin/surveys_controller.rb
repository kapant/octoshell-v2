module Sessions
  class Admin::SurveysController < Admin::ApplicationController
    def new
      @session = Session.find(params[:session_id])
      @survey = @session.surveys.build
      @template_surveys = Survey.includes(:session).group_by{ |s| s.session.description }
    end

    def edit
      @survey = Survey.find params[:id]
      @session = @survey.session
    end

    def update
      @survey = Survey.find params[:id]
      @session = @survey.session
      if @survey.update survey_params
        redirect_to [:admin, @survey]
      else
        render :edit
      end
    end

    def create
      @session = Session.find(params[:session_id])
      @survey = @session.surveys.new(survey_params)
      if params[:survey][:template_survey_id].present?
        @template_survey = Survey.find(params[:survey][:template_survey_id])
        @template_survey.fields.each do |field|
          @survey.fields << field.dup
        end

        if @survey.save
          redirect_to [:admin, @survey]
        else
          @template_surveys = Survey.includes(:session).group_by{ |s| s.session.description }
          render :new
        end
      else
        if @survey.save
          redirect_to [:admin, @survey]
        else
          @template_surveys = Survey.includes(:session).group_by{ |s| s.session.description }
          render :new
        end
      end
    end

    def show
      @survey = Survey.find(params[:id])
    end

    def destroy
      survey = Survey.find(params[:id])
      survey.destroy
      redirect_to [:admin, survey.session]
    end

    private

    def survey_params
      params.require(:survey).permit(*Survey.locale_columns(:name), :only_for_project_owners)
    end
  end
end
