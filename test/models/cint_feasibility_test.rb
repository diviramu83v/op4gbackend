# frozen_string_literal: true

require 'test_helper'

class Employee::CintFeasibilityTest < ActionDispatch::IntegrationTest
  setup do
    @feasibility = cint_feasibilities(:standard)

    @return_body = [
      {
        'id' => 22,
        'name' => 'USA',
        'regionTypes' => [
          {
            'id' => 1,
            'regions' => []
          },
          {
            'id' => 2,
            'regions' => []
          },
          {
            'id' => 3,
            'regions' => []
          },
          {
            'id' => 4,
            'regions' => [{ 'id' => 1, 'name' => 'Los Angeles' }, { 'id' => 2, 'name' => 'Buffalo' }]
          },
          {
            'id' => 5,
            'regions' => [{ 'id' => 3, 'name' => 'California' }, { 'id' => 4, 'name' => 'New York' }]
          }
        ]
      }
    ]
  end

  describe '#option_variables_hash' do
    test 'returns hash' do
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200,
                                                                                                      body: '[{"id":4,"name":"Number of children",
                                                                                                              "variables":[{"id":2,"name":"None"},
                                                                                                              {"id":3,"name":"One"}]}]',
                                                                                                      headers: { 'Content-Type' => 'application/json' })

      assert_equal @feasibility.option_variables_hash.class, Hash
    end
  end

  describe '#formatted_postal_codes' do
    test 'returns array' do
      @feasibility.update!(employee: employees(:operations))
      @feasibility.update!(postal_codes: '29401,  29407,29414')

      assert_equal @feasibility.formatted_postal_codes.class, Array
    end

    test 'formats postal codes correctly' do
      @feasibility.update!(employee: employees(:operations))
      @feasibility.update!(postal_codes: '29401,  29407,29414')

      assert_equal @feasibility.formatted_postal_codes, %w[29401 29407 29414]
    end
  end

  describe '#state_names' do
    test 'returns array' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/countries').to_return(status: 200)

      @feasibility.update(region_ids: [3, 4])
      @feasibility.save

      assert_equal @feasibility.state_names.class, Array
    end

    test 'collects state names' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/countries').to_return(status: 200)

      @feasibility.update(region_ids: [3, 4])
      @feasibility.save

      assert_equal @feasibility.state_names, ['California', 'New York']
    end
  end

  describe '#city_names' do
    test 'returns array' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/countries').to_return(status: 200)

      @feasibility.update(region_ids: [1, 2])
      @feasibility.save

      assert_equal @feasibility.city_names.class, Array
    end

    test 'collects city names' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200)
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/countries').to_return(status: 200)

      @feasibility.update(region_ids: [1, 2])
      @feasibility.save

      assert_equal @feasibility.city_names, ['Los Angeles', 'Buffalo']
    end
  end

  describe '#age_present?' do
    test 'returns false - no min_age or max_age' do
      assert_equal @feasibility.age_present?, false
    end

    test 'returns false - no max_age' do
      @feasibility.update(min_age: 18)
      @feasibility.save

      assert_equal @feasibility.age_present?, false
    end

    test 'returns true' do
      @feasibility.update(min_age: 18, max_age: 35)
      @feasibility.save

      assert_equal @feasibility.age_present?, true
    end
  end
end
