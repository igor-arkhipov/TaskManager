class Task < ApplicationRecord
	belongs_to :author, class_name: 'User'
	belongs_to :assignee, class_name: 'User', optional: true

	validates :name, :description, :author, presence: true
	validates :description, length: { maximum: 500 }
	
	state_machine initial: => :new_task do
		event :to_dev do
			transition new_task: => :in_development
		end
	
		event :back_to_dev do
			transition in_qa: => :in_development
			transition in_code_review: => :in_development
		end
	
		event :to_qa do
			transition new_task: => :in_qa
		end
	
		event :to_code_reveiw do
			transition in_qa: => :in_code_review
		end
	
		event :pre_release do
			transition in_code_review: => :ready_for_release
		end
	
		event :release do
			transition ready_for_release: => :released
		end
	
		event :archive do
			transition new_task: => :archived
			transition released: => :archived
		end
	end
end