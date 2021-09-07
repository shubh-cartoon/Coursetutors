# frozen_string_literal: true

module Api
  module V1
    class CoursesController < ApplicationController
      include AuthenticationConcern

      def index
        course_data = Course.includes(:tutors).as_json(
          only: %i[name code], include: { tutors: { only: %i[name aadhar] } }
        )
        render json: { data: course_data }
      end

      def create
        @course = Course.new(course_params)

        if @course.save
          render json: { status: true, message: I18n.t('course.created') }, status: :ok
        else
          errors = @course.errors.full_messages.uniq.join(',')
          render json: { status: false, message: errors }, status: :unprocessable_entity
        end
      end

      private

      def course_params
        params.require(:course).permit(:name, :code, tutors_attributes: %i[name aadhar])
      end
    end
  end
end
