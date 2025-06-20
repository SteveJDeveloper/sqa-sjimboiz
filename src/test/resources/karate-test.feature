@REQ_sjimboiz
Feature: Pruebas de la API de personajes de Marvel

  Background:
    Given url 'https://bp-se-test-cabcd9b246a5.herokuapp.com/sjimboiz/api/characters'
    * configure ssl = true
    * def data = read('classpath:karate-data.json')

  @id:1
  Scenario: T-API-SJIMBOIZ-CA1 Obtener todos los personajes
    When method get
    Then status 200
    * print response

  @id:2
  Scenario Outline: T-API-SJIMBOIZ-CA2 Obtener personaje con <ids> (no existe)
    Given path <ids>
    When method get
    Then status 404
    * match response.error == 'Character not found'
    Examples:
    | read('classpath:ids-not-exist.csv') |

  @id:3
  Scenario: T-API-SJIMBOIZ-CA3 Flujo Creacion - ID Especifico - Creacion Duplicado - Eliminacion
    # Creacion de personaje
    And request data.character
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * match response == { id: '#number', name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    * karate.set('characterId', response.id)
    * def characterId = response.id

    # Obtener personaje por ID especifico (exitoso)
    Given path characterId
    When method get
    Then status 200
    * match response == { id: '#number', name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

    # Eliminacion de personaje (exitoso)
    Given path characterId
    When method delete
    Then status 204

  @id:4
  Scenario Outline: T-API-SJIMBOIZ-CA4 Eliminar personaje con <ids> (no existe)
    Given path <ids>
    When method delete
    Then status 404
    * match response.error == 'Character not found'
    Examples:
    | read('classpath:ids-not-exist.csv') |