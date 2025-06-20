@REQ_sjimboiz
Feature: Pruebas de la API de personajes de Marvel

  Background:
    Given url 'https://bp-se-test-cabcd9b246a5.herokuapp.com/sjimboiz/api/characters'
    * configure ssl = true
    * def data = read('classpath:karate-data.json')
    * print data

  @id:1
  Scenario: T-API-SJIMBOIZ-CA1 Obtener todos los personajes
    When method get
    Then status 200
    * print response

  @id:3
  Scenario: T-API-SJIMBOIZ-CA3 Obtener personaje por ID (no existe)
    Given path '666'
    When method get
    Then status 404
    * match response.error == 'Character not found'

  @id:4
  Scenario: T-API-SJIMBOIZ-CA4 Crear personaje (exitoso)
    And request data.character
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * match response == { id: '#number', name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }