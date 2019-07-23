# based on GistQuestionService from test-guru project
class GistService
  def initialize(gist_id, client = octokit_client)
    @client = client
    @gist_id = gist_id
  end

  def call
    begin
      gist = @client.gist(@gist_id)
      @result = gist.files.first[1][:content]
    rescue Octokit::NotFound
      false
    end
  end

  private

  def octokit_client
    client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
  end
end
