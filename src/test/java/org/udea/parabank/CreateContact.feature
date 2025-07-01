@appcontact_createcontact
Feature: Crear y validar contactos

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def faker = Java.type('com.github.javafaker.Faker')
    * def fake = new faker()
    * def randomEmail = 'contacto.' + java.lang.System.currentTimeMillis() + '@fake.com'

  Scenario: Crear contacto con datos válidos y verificar existencia
    Given path '/users/login'
    And request { "email": "correoprueba@test.com", "password": "123456789" }
    When method POST
    Then status 200
    * def authToken = response.token

    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "firstName": "Luis",
      "lastName": "Prueba",
      "birthdate": "1990-01-01",
      "email": "#(randomEmail)",
      "phone": "3001234567"
    }
    """
    When method POST
    Then status 201

    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match response[*].email contains randomEmail

  Scenario: Crear contacto con campos faltantes
    Given path '/users/login'
    And request { "email": "correoprueba@test.com", "password": "123456789" }
    When method POST
    * def authToken = response.token

    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request { "email": "correoprueba@test.com", "phone": "123456789" }
    When method POST
    Then status 400
