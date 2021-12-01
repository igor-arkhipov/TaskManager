class Task < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  validates :name, :description, :author, presence: true
  validates :description, length: { maximum: 500 }

  state_machine initial: :new_task do
    event :goes_to_dev do
      transition new_task: :in_development
    end

    event :return_to_dev do
      transition from: [:in_qa, :in_code_review], to: :in_development
    end

    event :qa_check do
      transition new_task: :in_qa
    end

    event :code_review do
      transition in_qa: :in_code_review
    end

    event :pre_release do
      transition in_code_review: :ready_for_release
    end

    event :release do
      transition ready_for_release: :released
    end

    event :archive do
      transition from: [:new_task, :released], to: :archived
    end
  end
end
