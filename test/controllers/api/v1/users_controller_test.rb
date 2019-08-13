class Api::V1::UsersControllerTest < ActionController::TestCase
  def test_show
    get :show, { params: { id: users(:betty).id } }

    assert_response :success
    assert_equal Mime[:json], response.content_type
  end

  def test_show_not_found
    id_not_exist = "this doesn't exist"
    
    get :show, { params: { id: id_not_exist } }

    assert_response :not_found
    assert_equal Mime[:json], response.content_type
  end

  def test_create
    assert_difference "User.count" do
      post :create, params: { 
        user: { 
          username: 'tag', email: 'tag@example.com', password: 'secret!' 
        } 
      }
    end

    assert_response :success
    assert_equal Mime[:json], response.content_type
  end
  
  def test_create_duplicate_email
    email_already_exists = users(:happy).email

    assert_no_difference "User.count" do
      post :create, params: { 
        user: { 
          username: 'happy', email: email_already_exists, password: 'secret!' 
        } 
      }
    end

    assert_response :unprocessable_entity
    assert_equal Mime[:json], response.content_type
  end

  def test_create_with_missing_password
    assert_no_difference "User.count" do
      post :create, params: { 
        user: { 
          username: 'happy', email: 'happy@example.com', password: nil
        } 
      }
    end

    assert_response :unprocessable_entity
    assert_equal Mime[:json], response.content_type
  end

  def test_create_with_missing_email
    assert_no_difference "User.count" do
      post :create, params: { 
        user: { 
          username: 'happy', email: nil, password: 'secret!'
        } 
      }
    end

    assert_response :unprocessable_entity
    assert_equal Mime[:json], response.content_type
  end

  def test_delete_with_no_headers
    assert_no_difference "User.count" do
      post :destroy, params: { id: users(:betty).id }
    end

    assert User.exists?(users(:betty).id)

    assert_response :unauthorized
    assert_equal 'Bad credentials', response.body
    assert_equal Mime[:json], response.content_type
  end

  def test_delete
    @request.env['HTTP_AUTHORIZATION'] = 'Token token="super-secret!"';
    
    assert_difference "User.count", -1 do
      post :destroy, params: { id: users(:betty).id }
    end

    assert_not User.exists?(users(:betty).id)

    assert_response :success
    assert response.no_content?
  end

  def test_delete_with_no_id
    id_not_exist = "this doesn't exist"
    
    assert_no_difference "User.count" do
      post :destroy, params: { id: id_not_exist }
    end

    assert_response :not_found
    assert_equal Mime[:json], response.content_type
  end
end
  