PORT = process.env.PORT || 9002
APP_URL = "http://localhost:#{PORT}"

withDriver = (f)->
  f(browser.driver)

isElementPresent = (selectorFn, selectorArg)->
  withDriver (d)->
    d.isElementPresent selectorFn(selectorArg)

waitForElement = (selectorFn, selectorArg)->
  withDriver (d)->
    d.wait(->
      isElementPresent(selectorFn, selectorArg)
    , 5000, "Failed to find element '#{selectorArg}'")

element = (selectorFn, selectorArg)->
  waitForElement(selectorFn, selectorArg)
  withDriver (d)->
    d.findElement selectorFn(selectorArg)

elements = (selectorFn, selectorArg)->
  waitForElement(selectorFn, selectorArg)
  withDriver (d)->
    d.findElements(selectorFn(selectorArg))

visit = (url)->
  withDriver (d)->
    d.get url

pageContent = ->
  element(By.css, 'body').getText()

describe 'A feature', ->
  beforeEach ->
    visit APP_URL

  it 'can display friends', ->
    expect(pageContent()).toMatch(/Miss Frizzle/)
