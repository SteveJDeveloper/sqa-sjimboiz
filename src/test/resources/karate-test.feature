@REQ_sjimboiz
Feature: Pruebas de la API de personajes de Marvel

  Background:
    Given url 'https://bp-se-test-cabcd9b246a5.herokuapp.com/sjimboiz/api/characters'
    * configure ssl = true

  @id:1
  Scenario: T-API-SJIMBOIZ-CA1 Obtener todos los personajes
    When method get
    Then status 200
    * print response
    * match response == [] || response.length > 0

  @id:3
  Scenario: T-API-SJIMBOIZ-CA3 Obtener personaje por ID (no existe)
    Given path '666'
    When method get
    Then status 404
    * match response.error == 'Character not found'