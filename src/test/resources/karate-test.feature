@REQ_sjimboiz @characters
Feature: Pruebas de la API de personajes de Marvel

  Background:
    Given url 'https://bp-se-test-cabcd9b246a5.herokuapp.com/sjimboiz/api/characters'
    * configure ssl = true
    * def data = read('classpath:karate-data.json')

  @id:1 @obtainCharacters
  Scenario: T-API-SJIMBOIZ-CA1 Obtener todos los personajes
    When method get
    Then status 200
    * print response

  @id:2 @obtainCharacterById
  Scenario Outline: T-API-SJIMBOIZ-CA2 Obtener personaje con <ids> (no existe)
    Given path <ids>
    When method get
    Then status 404
    * match response.error == 'Character not found'
    Examples:
    | read('classpath:ids-not-exist.csv') |

  @id:3 @crudCharacter
  Scenario: T-API-SJIMBOIZ-CA3 Flujo CRUD de personaje con un mismo ID

    # Creacion de personaje
    And request data.character
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * match response == data.schemaCharacter
    * def characterId = response.id

    # Creacion de personaje (nombre duplicado)
    And request data.character
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    * match response.error == 'Character name already exists'

    # Obtener personaje por ID especifico (exitoso)
    Given path characterId
    When method get
    Then status 200
    * match response == data.schemaCharacter

    # Actualizar personaje (exitoso)
    Given path characterId
    And request data.characterUpdated
    When method put
    Then status 200
    * match response == data.schemaCharacterUpdated

    # Eliminacion de personaje (exitoso)
    Given path characterId
    When method delete
    Then status 204

  @id:4 @createCharacterIncomplete
  Scenario: T-API-SJIMBOIZ-CA4 Crear personaje (faltan campos requeridos)
    And request data.characterIncompleted
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    * match response == data.emptyFieldsResponse

  @id:5 @deleteCharacterNotExist
  Scenario Outline: T-API-SJIMBOIZ-CA5 Eliminar personaje con <ids> (no existe)
    Given path <ids>
    When method delete
    Then status 404
    * match response.error == 'Character not found'
    Examples:
    | read('classpath:ids-not-exist.csv') |

  @id:6 @updateCharacterNotExist
  Scenario Outline: T-API-SJIMBOIZ-CA6 Actualizar personaje con <ids> (no existe)
    Given path <ids>
    And request data.characterUpdated
    When method put
    Then status 404
    * match response.error == 'Character not found'
    Examples:
      | read('classpath:ids-not-exist.csv') |
