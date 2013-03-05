module SendGridWebApi::Modules
  class Newsletter < SendGridWebApi::Client

    def get options = {}
      get_url = "newsletter/get.json"
      query_api(get_url, options)
    end
    def add options = {}
      add_url = "newsletter/add.json"
      query_post_api(add_url, options)
    end
    def edit options = {}
      edit_url = "newsletter/edit.json"
      query_post_api(edit_url, options)
    end
    def list options = {}
      list_url = "newsletter/list.json"
      query_api(list_url, options)
    end
    def delete options = {}
      delete_url = "newsletter/delete.json"
      query_post_api(delete_url, options)
    end

    def get_lists options = {}
      get_lists_url = "newsletter/lists/get.json"
      query_api(get_lists_url, options)
    end
    def add_list options = {}
      add_list_url = "newsletter/lists/add.json"
      query_post_api(add_list_url, options)
    end
    def edit_list options = {}
      edit_list_url = "newsletter/lists/edit.json"
      query_post_api(edit_list_url, options)
    end
    def delete_list options = {}
      delete_list_url = "newsletter/lists/delete.json"
      query_post_api(delete_list_url, options)
    end

    def get_list_emails options = {}
      get_lists_emails_url = "newsletter/lists/email/get.json"
      query_api(get_lists_emails_url, options)
    end
    def add_list_emails options = {}
      add_list_emails_url = "newsletter/lists/email/add.json"
      query_post_api(add_list_emails_url, options)
    end
    def delete_list_emails options = {}
      delete_list_emails_url = "newsletter/lists/email/delete.json"
      query_post_api(delete_list_emails_url, options)
    end

    def get_identity options = {}
      get_identity_url = "newsletter/identity/get.json"
      query_api(get_identity_url, options)
    end
    def add_identity options = {}
      add_identity_url = "newsletter/identity/add.json"
      query_post_api(add_identity_url, options)
    end
    def edit_identity options = {}
      edit_identity_url = "newsletter/identity/edit.json"
      query_post_api(edit_identity_url, options)
    end
    def list_identities options = {}
      list_identities_url = "newsletter/identity/list.json"
      query_api(list_identities_url, options)
    end
    def delete_identity options = {}
      delete_identity_url = "newsletter/identity/delete.json"
      query_post_api(delete_identity_url, options)
    end

    def get_recipients options = {}
      get_recipients_url = "newsletter/recipients/get.json"
      query_api(get_recipients_url, options)
    end
    def add_recipients options = {}
      add_recipients_url = "newsletter/recipients/add.json"
      query_post_api(add_recipients_url, options)
    end
    def remove_recipients options = {}
      remove_recipients_url = "newsletter/recipients/delete.json"
      query_post_api(remove_recipients_url, options)
    end

    def get_schedule options = {}
      get_schedule_url = "newsletter/schedule/get.json"
      query_api(get_schedule_url, options)
    end
    def add_schedule options = {}
      add_schedule_url = "newsletter/schedule/add.json"
      query_post_api(add_schedule_url, options)
    end
    def delete_schedule options = {}
      delete_schedule_url = "newsletter/schedule/delete.json"
      query_post_api(delete_schedule_url, options)
    end
  end
end