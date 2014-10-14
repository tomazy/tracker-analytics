angular.module('webApp')

.factory 'Friends', ->
  # Might use a resource here that returns a JSON array

  # Some fake testing data
  friends = [
    { id: 0, name: 'Scruff McGruff' },
    { id: 1, name: 'G.I. Joe' },
    { id: 2, name: 'Miss Frizzle' },
    { id: 3, name: 'Ash Ketchum' }
  ]

  return {
    all: ->
      return friends
  }
