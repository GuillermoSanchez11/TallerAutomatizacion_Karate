@appcontact_login
Feature: Login de usuario para Contact List App

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Login exitoso con credenciales válidas
    Given path '/users/login'
    And request { "email": "correoprueba@test.com", "password": "123456789" }
    When method POST
    Then status 200
    And match response.token != null
    * def authToken = response.token

    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200

  Scenario: Login con credenciales inválidas
    Given path '/users/login'
    And request { "email": "usuario@falso.com", "password": "nada" }
    When method POST
    Then status 401