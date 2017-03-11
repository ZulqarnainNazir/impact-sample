desc 'Create Post Index'
task create_post_index: [:environment] do

	post_index_status = HTTParty.get("#{ENV["BONSAI_URL"]}/posts")
	delete_index = "conditional failed, no value assigned (#{post_index_status}"

	if post_index_status.parsed_response["error"].present? && post_index_status.parsed_response["error"]["root_cause"].first["type"] == "index_not_found_exception"

		delete_index = nil

	elsif post_index_status.parsed_response["posts"].present?

		delete_index = Post.__elasticsearch__.client.indices.delete index: Post.index_name

	end

	if (!delete_index.nil? && delete_index == {"acknowledged"=>true}) || delete_index.nil?

		a = {
		  mappings: {
		    post: {
		      properties: {
		        business_id: {
		          type: "long"
		        },
		        content_category_ids: {
		          type: "long"
		        },
		        content_tag_ids: {
		          type: "long"
		        },
		        created_at: {
		          type: "date",
		          format: "dateOptionalTime"
		        },
		        facebook_id: {
		          type: "string"
		        },
		        id: {
		          type: "long"
		        },
		        meta_description: {
		          type: "string"
		        },
		        post_sections: {
		          type: "nested",
		          properties: {
		            ancestry: {
		              type: "string"
		            },
		            content: {
		              type: "string"
		            },
		            created_at: {
		              type: "date",
		              format: "dateOptionalTime"
		            },
		            heading: {
		              type: "string"
		            },
		            id: {
		              type: "long"
		            },
		            kind: {
		              type: "string"
		            },
		            position: {
		              type: "long"
		            },
		            post_id: {
		              type: "long"
		            },
		            updated_at: {
		              type: "date",
		              format: "dateOptionalTime"
		            }
		          }
		        },
		        published_on: {
		          type: "date",
		          format: "dateOptionalTime"
		        },
		        published_status: {
		          type: "boolean"
		        },
		        slug: {
		          type: "string"
		        },
		        sorting_date: {
		          type: "date",
		          format: "dateOptionalTime"
		        },
		        title: {
		          type: "string"
		        },
		        updated_at: {
		          type: "date",
		          format: "dateOptionalTime"
		        }
		      }
		    }
		  }
		}

		response = HTTParty.put("#{ENV["BONSAI_URL"]}/posts", :body => a.to_json)
		
		if response.parsed_response["acknowledged"] == true
			result = Post.import
			if result == 0
				puts "Post index mapped, created, and data imported."
			else
				puts "Data import failed. Rake task aborted. Details: #{result}"
			end
		else
			puts "PUT request failed. Rake task aborted. Details: #{response}"
		end
	else
		puts "Index was not deleted. Rake task aborted. Details: #{delete_index}"
	end

end