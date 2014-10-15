{expect} = require 'chai'
rig = require '../index'
imgflo = require 'imgflo-url'


describe 'Responsive image generator', ->

  describe 'without a block', ->

    it 'should throw an error', ->
      exercise = ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig null, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'block not provided'


  context 'with a block', ->

    describe.skip 'of invalid type', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'text'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'block must be of type "media" or a valid sub-type'


    describe 'without a cover image', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'

          params =
            graph: 'passthrough'

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'block must have a cover image'


    context 'with a cover image', ->

      describe 'without a src', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a src'


      describe 'without a width', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                src: 'https://a.com/b.png'
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a width'


      describe 'without a height', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                src: 'https://a.com/b.png'
                width: 1600

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a height'


  describe 'without an imgflo config object', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        rig fakeBlock, null, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'imgflo config not provided'


  describe 'without a graph name', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig fakeBlock, config, null, {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'imgflo graph name not provided'


  describe 'without any query items', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig fakeBlock, config, 'passthrough', {}

      expect(exercise).to.throw Error, 'query items not provided'


  context 'with a query item', ->

    describe 'without a media query', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock,config, 'passthrough', {}, [{
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'media query not provided'


    describe 'without a selector', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            width: 800
          }]

        expect(exercise).to.throw Error, 'selector not provided'


    describe 'without a width or height', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
          }]

        expect(exercise).to.throw Error, 'width or height not provided'


    describe 'specifying both width and height', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig fakeBlock, config, 'gaussianblur', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
            height: 450
          }]

        expect(exercise).to.throw Error, 'width or height must be provided, but not both'


    describe 'with a width larger than the original', ->

      it 'should use the original width', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 1920
        }]

        url = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 1600
          height: 900

        expect(css).to.equal """
          @media (max-width: 503px) {
            .media, .background {
              background-image: url('#{url}');
            }
          }
        """


    describe 'with a height larger than the original', ->

      it 'should use the original height', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 1200
        }]

        url = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 1600
          height: 900

        expect(css).to.equal """
          @media (max-width: 503px) {
            .media, .background {
              background-image: url('#{url}');
            }
          }
        """


  context 'with a valid block and query items', ->

    describe 'providing widths', ->

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          width: 800
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 800
          height: 450

        expect(css).to.equal """
          @media (max-width: 503px) {
            .media, .background {
              background-image: url('#{firstUrl}');
            }
          }

          @media (min-width: 504px) and (max-width: 1007px) {
            .media, .background {
              background-image: url('#{secondUrl}');
            }
          }
        """


    describe 'providing heights', ->

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 225
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 800
          height: 450

        expect(css).to.equal """
          @media (max-width: 503px) {
            .media, .background {
              background-image: url('#{firstUrl}');
            }
          }

          @media (min-width: 504px) and (max-width: 1007px) {
            .media, .background {
              background-image: url('#{secondUrl}');
            }
          }
        """


    describe 'providing a mixture of widths and heights', ->

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 800
          height: 450

        expect(css).to.equal """
          @media (max-width: 503px) {
            .media, .background {
              background-image: url('#{firstUrl}');
            }
          }

          @media (min-width: 504px) and (max-width: 1007px) {
            .media, .background {
              background-image: url('#{secondUrl}');
            }
          }
        """


      describe 'using a more complex imgflo graph', ->

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          params =
            'std-dev-x': 15
            'std-dev-y': 15

          css = rig fakeBlock, config, 'gaussianblur', params, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 400
          }, {
            query: '(min-width: 504px) and (max-width: 1007px)'
            selector: '.media, .background'
            height: 450
          }]

          firstUrl = imgflo config, 'gaussianblur',
            input: 'https://a.com/b.png'
            width: 400
            height: 225
            'std-dev-x': 15
            'std-dev-y': 15

          secondUrl = imgflo config, 'gaussianblur',
            input: 'https://a.com/b.png'
            width: 800
            height: 450
            'std-dev-x': 15
            'std-dev-y': 15

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 504px) and (max-width: 1007px) {
              .media, .background {
                background-image: url('#{secondUrl}');
              }
            }
          """
