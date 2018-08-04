class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests
  # GET /tests.json
  def index
    @tests = Test.all
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
  end

  def start
    @test = Test.find(params[:test_id])
    @q_details = []
    @test.question_details.each do |q_d|
      question = Question.find(q_d["question_id"])
      question_title = [question.id, question.title]
      option_ids = q_d["option_ids"] - [q_d["answer_id"]]
      option_titles = Option.where(id: option_ids).pluck(:id, :title)
      answer = Answer.find(q_d["answer_id"])
      option_titles << [answer.id, answer.title]
      @q_details << {question_title: question_title, option_titles: option_titles.shuffle!}
    end
  end

  def result
    @test = Test.find(params[:test_id])
    correct_answers = 0
    wrong_answers = 0
    @test.question_details.each do |q_details|
      if params[q_details["question_id"].to_s]
        if q_details["answer_id"].to_i == params[q_details["question_id"].to_s].to_i
          correct_answers += 1
        else
          wrong_answers += 1
        end
      end
    end
    @test.scores.create({answer_details: {correct_answers: correct_answers, wrong_answers: wrong_answers, total_questions: @test.number_of_questions}, users_raw_answers: params.except("authenticity_token", "utf8", "commit", "controller", "action")})
    respond_to do |format|
      format.html { redirect_to test_my_score_path(@test), notice: 'Test was successfully created.' }
    end
  end

  def my_score
    @my_score_board = []
    @score = Score.last
    @wrong_answers = @score.answer_details["wrong_answers"]
    @correct_answers = @score.answer_details["correct_answers"]
    @total_questions = @score.answer_details["total_questions"]
    @total_attempts = @wrong_answers + @correct_answers
    user_answer = @score.users_raw_answers
    question_details = @score.test.question_details
    question_details.each do |question|
      user_answer_check = {}
      if user_answer[question["question_id"].to_s]
        user_answer_check.merge!({
          user_attempt: true,
          user_answer: (user_answer[question["question_id"].to_s].to_i == question["answer_id"].to_i) ? Answer.find(user_answer[question["question_id"].to_s]).title : Option.find(user_answer[question["question_id"].to_s]).title,
          is_correct?: (user_answer[question["question_id"].to_s].to_i == question["answer_id"].to_i) ? true : false,
          correct_answer: Answer.find(question["answer_id"]).title,
          class_name: (user_answer[question["question_id"].to_s].to_i == question["answer_id"].to_i) ? 'table-success' : 'table-danger'
          })
      else
        user_answer_check.merge!({
          user_attempt: false,
          user_answer: nil,
          is_correct?: nil,
          class_name: 'table-primary',
          correct_answer: Answer.find(question["answer_id"]).title
          })
      end
      user_answer_check.merge!({
        question: Question.find(question["question_id"]).title,
      })
      @my_score_board << user_answer_check
    end
  end

  def all_my_score
    @all_score = Score.all
  end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)
    @test.update_question_details(test_params)
    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      @test.update_question_details(test_params)
      if @test.update(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      # params.fetch(:test, {})
      params.require(:test).permit(:subject_id, :time_required, :number_of_questions, :user_id)
    end
end
