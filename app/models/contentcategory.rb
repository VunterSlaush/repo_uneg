class Contentcategory < ActiveRecord::Base
	belongs_to :content
	belongs_to :category
end
