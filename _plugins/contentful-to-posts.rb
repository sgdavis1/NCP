require "yaml"

# Define our custom class to handle Contentful -> Post transformation
class ToPosts 
  def self.generatePosts(site)
    # Since we do a full build each time, updates and deletes are handled
    # by clearing the _posts directory before processing.
    Dir.glob("_posts/*").each{ |old| File.delete(old) }

    # Now process data from Contentful
    Dir.glob("_data/contentful/spaces/*.yaml").each { |file|
      puts("Reading Contentful data from '#{file}'...")
      data = YAML.load_file(file)

      # Read all articles into files as a separate "post" in Jekyll terms
      data['article'].each{ |article|
        date_str = article['sys']['createdAt'].strftime("%Y-%m-%d")
        title_str = article['title'].gsub(" ", "-").downcase
        filename = "_posts/#{date_str}-#{title_str}.md"

        # Ensure directory (since it is git excluded)
        Dir.mkdir("_posts") unless Dir.exists?("_posts")


        # Indicate processing status
        puts("  Creating post for '#{article['title']}' as '#{filename}'")

        File.open(filename, "w") { |post|
          # Front matter
          post.puts("---")
          post.puts("layout: post")
          post.puts("title: #{article['title']}")
          # end Front matter
          post.puts("---")

          # Add body as is (already in Markdown):
          post.puts(article['body'])

          # Now add documents
          post.puts("")
          if (article['documents'])
            article['documents'].each{ |doc| 
              post.puts("* [#{doc['title']}](#{doc['url']})")
            }
          end
        }
      }
    }
  end
end


# Register our class to transform the Contentful data into posts files
Jekyll::Hooks.register :site, :after_reset do |site|
  ToPosts.generatePosts(site)
end
