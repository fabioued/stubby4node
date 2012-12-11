sut = null
CLI = require '../src/console/cli'
defaults = CLI.getArgs []
options = null

sinon = require 'sinon'
waitsFor = require './helpers/waits-for'
assert = require 'assert'

xdescribe 'main', ->
   sut = null
   stopStubby = (finish) ->
      if sut? then return sut.stop finish
      finish()

   beforeEach (done) ->
      finish = ->
         sut = new (require('../src/main').Stubby)()
         done()

      stopStubby finish

   afterEach stopStubby

   describe 'start', ->
      beforeEach ->
         options = {}

      describe 'callback', ->
         it 'should treat the callback as optional', (done) ->
            callback = sinon.spy()
            sut.start {}, callback

            waitsFor (-> callback.called), 'callback to have been called', 1, done

         it 'should take one parameter as a function', (done) ->
            callback = sinon.spy()
            sut.start callback

            waitsFor (-> callback.called), 'callback to have been called', 1, done

      describe 'options', ->
         it 'should default stub port to CLI port default', (done) ->
            sut.start options, ->
               assert options.stubs is defaults.stubs
               done()

         it 'should default admin port to CLI port default', (done) ->
            sut.start options, ->
               assert options.admin is defaults.admin
               done()

         it 'should default location to CLI default', (done) ->
            sut.start options, ->
               assert options.location is defaults.location
               done()

         it 'should default data to empty array', (done) ->
            sut.start options, -> 
               assert options.data instanceof Array
               assert options.data.length is 0
               done()

         it 'should default key to null', (done) ->
            sut.start options, -> 
               assert options.key is defaults.key
               done()

         it 'should default cert to null', (done) ->
            sut.start options, -> 
               assert options.cert is defaults.cert
               done()
