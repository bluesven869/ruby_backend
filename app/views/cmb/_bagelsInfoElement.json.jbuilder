json.success bagelsInfoElement.success
json.jsonObj do
	json.more_before bagelsInfoElement.jsonObj.more_before
	json.more_after bagelsInfoElement.jsonObj.more_after
	json.cursor_before bagelsInfoElement.jsonObj.cursor_before
	json.cursor_after bagelsInfoElement.jsonObj.cursor_after
	json.current_token bagelsInfoElement.jsonObj.current_token

	json.array!(bagelsInfoElement.jsonObj.results) do |result|
	    json.decoupling_date result.decoupling_date
	    json.meetup_prompt_answer result.meetup_prompt_answer
	    json.feedback result.feedback
	    json.block_reason result.block_reason
	    json.is_bonus_bagel result.is_bonus_bagel
	    json.pair_chat_removed result.pair_chat_removed
	    json.given_by_first_name result.given_by_first_name
	    json.pair_bagel_type result.pair_bagel_type
	    json.total_woos result.total_woos
	    json.block_type result.block_type
	    json.id result.id
	    json.last_updated result.last_updated
	    json.response_award result.response_award
	    json.rising_bagel_count result.rising_bagel_count
	    json.reveal_purchased result.reveal_purchased
	    json.bagel_type result.bagel_type
	    json.meetup_follow_up_answer result.meetup_follow_up_answer
	    json.is_one_way_bagel result.is_one_way_bagel
	    json.pair_total_woos result.pair_total_woos
	    json.total_woos_seen result.total_woos_seen
	    json.start_date result.start_date

	    json.profile do 
	        json.last_updated result.profile.last_updated
	        json.user__first_name result.profile.user__first_name
	        json.id result.profile.id
	        json.ethnicity result.profile.ethnicity
	        json.occupation result.profile.occupation
	        json.city result.profile.city
	        json.education do
	        	json.array! @education
	        end 
	        json.criteria__gender result.profile.criteria__gender
	        json.employer result.profile.employer
	        json.religion result.profile.religion
	        json.state result.profile.state
	        json.location result.profile.location
	        json.interest do
	        	json.array! @interest
	        end 
	        json.dating do
	        	json.array! @dating
	        end 
	        json.personality do
	        	json.array! @personality
	        end 
	        json.degree do
	        	json.array! @degree
	        end 

	    end
	end 
end

# json.(bagelsInfoElement, :success, :jsonObj)